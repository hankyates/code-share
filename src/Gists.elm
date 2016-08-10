module Gists exposing (Model, init, getGist, GistModel)

import Task
import Http
import Json.Decode as Json

init : Model
init =
  [
    {
      name="",
      content="",
      description=""
    }
  ]

type alias GistModel = {
  name : String,
  content : String,
  description : String
}

type alias Model = (List GistModel)

getGist : Task.Task Http.Error Model
getGist =
  let
    url =
      "https://api.github.com/gists/bde3f79df1574aef7d58"
  in
    Http.get decodeGists url


decodeGists : Json.Decoder Model
decodeGists =
  Json.list (
    Json.object3 GistModel
      (Json.at ["files", "curry.js", "filename"] Json.string)
      (Json.at ["files", "curry.js", "content"] Json.string)
      (Json.at ["description"] Json.string)
  )

