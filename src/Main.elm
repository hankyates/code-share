import Debug
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Gists
import Task
import Http

main =
  Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = \_ -> Sub.none
  }

init : (Model, Cmd Msg)
init =
  (Model 0 True Gists.init Nothing, Task.perform Fail GistsSuccess Gists.getGist)

-- MODEL

type alias Model = {
  page: Int,
  loading: Bool,
  gists: Gists.Model,
  msg: Maybe Http.Error
}


-- UPDATE

type Msg
  = NextPage
  | PrevPage
  | Loading Bool
  | GistsSuccess Gists.Model
  | Fail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    Loading loading ->
      ({model | loading = loading}, Cmd.none)
    GistsSuccess gists ->
      ({
        model |
          gists = gists,
          loading = False
      }, Cmd.none)
    Fail msg ->
      ({
        model |
          loading = False,
          msg = Just (Debug.log "msg" msg)
      }, Cmd.none)
    NextPage ->
      ({ model | page = model.page + 1 }, Cmd.none)
    PrevPage ->
      ({ model | page = model.page - 1 }, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  main' [] [
    header [] [
      a [href "/"] [
        img [src ""] []
      ],
      section [] [
        h2 [] [
          text "Hank Yates"
        ]
      ]
    ],
    section [] [
      if model.loading
      then text "Loading ..."
      else div [] [gistTemplate model.gists]
    ]
  ]

gistTemplate : Gists.GistModel -> Html Msg
gistTemplate gist =
  div [] [
    span [] [text gist.name],
    span [] [text gist.content],
    span [] [text gist.description]
  ]
