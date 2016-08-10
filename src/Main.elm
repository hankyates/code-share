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
  (Model True Gists.init Nothing, Task.perform Fail GistsSuccess Gists.getGist)

-- MODEL

type alias Model = {
  loading: Bool,
  gists: (List Gists.Model),
  msg: Maybe Http.Error
}


-- UPDATE

type Msg
  = Loading Bool
  | GistsSuccess (List Gists.Model)
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
      h3 [] [text "Latest Gists:"],
      if model.loading
      then text "Loading ..."
      else div [] (List.map gistView model.gists)
    ]
  ]

gistView : Gists.Model -> Html Msg
gistView gist =
  div [] [
    div [] [text gist.name],
    div [] [
      code [] [
        text gist.content
      ]
    ]
  ]
