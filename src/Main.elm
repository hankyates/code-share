import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task

main =
  Html.program { init = init, subscriptions = subscriptions, view = view, update = update }

init : (Model, Cmd Msg)
init =
  (Model "bde3f79df1574aef7d58" "" [""], Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- MODEL

type alias Model =
  { gist : String, username: String, gists: (List String)}


-- UPDATE

type Msg
    = Gist String
    | GetUsername
    | GetGists
    | UsernameSucceed String
    | GistsSucceed (List String)
    | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Gist gist ->
      ({ model | gist = gist }, Cmd.none)
    GetUsername ->
      (model, getGist model.gist)
    GetGists ->
      (model, getGists model.username)
    UsernameSucceed username ->
      ({ model | username = username }, Cmd.none)
    GistsSucceed gists ->
      ({ model | gists = gists }, Cmd.none)
    FetchFail _ ->
      (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    button [onClick GetUsername] [text "username"],
    button [onClick GetGists] [text "gists"],
    div [] [text model.username],
    div [] (model.gists |> List.map gistTemplate),
    text model.gist
  ]

gistTemplate : String -> Html Msg
gistTemplate gist =
  a [href "#"] [text gist]

getGist : String -> Cmd Msg
getGist gistId =
  let
    url =
      "https://api.github.com/gists/" ++ gistId
  in
    Task.perform FetchFail UsernameSucceed (Http.get decodeUsername url)

decodeUsername : Json.Decoder String
decodeUsername =
  Json.at ["owner", "login"] Json.string

getGists : String -> Cmd Msg
getGists username =
  let
    url =
      "https://api.github.com/users/"++ username ++ "/gists"
  in
    Task.perform FetchFail GistsSucceed (Http.get decodeGists url)

decodeGists : Json.Decoder (List String)
decodeGists =
  Json.list (Json.at ["id"] Json.string)

