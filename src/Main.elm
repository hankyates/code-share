import Debug
import String
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Gists
import Task
import Http
import Ports

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
      ({ model | gists = gists, loading = False }, Ports.gistFetch Nothing)
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
        img [src "https://www.gravatar.com/avatar/2b25725ad1d27ab6d0b467cc841581e0"] []
      ],
      div [class "description"] [
        h1 [] [text "Code share"],
        div [] [text "Just a place where I share snippets of code."]
      ]
    ],
    section [class "gist-list"] [
      if model.loading
      then text "Loading ..."
      else div [] (List.map gistView model.gists)
    ]
  ]
-- TODO figure out how to get this into Gists.elm
gistView : Gists.Model -> Html Msg
gistView gist =
  div [] [
    div [] [text gist.name],
    div [] [
      pre [class "hljs"] [
        code [class (String.toLower gist.language)] [
          text gist.content
        ]
      ]
    ],
    hr [] []
  ]
