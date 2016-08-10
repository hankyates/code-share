module Gists exposing (Model, init, getGist)

import Task
import Http
import Html.App as Html
import Json.Decode exposing (..)
import Html exposing (..)

init : List Model
init = [{
    name="",
    content=""
  }]

type alias Model = {
  name : String,
  content : String
}

getGist : Task.Task Http.Error (List Model)
getGist =
  let
    url =
      "https://api.github.com/gists/c045ab27e626fa80a19bef9cbeff8576"
  in
    Http.get decodeGists url

decodeGists : Decoder (List Model)
decodeGists =
  "files" := fileDecoder |> map (\t -> List.map (\(filename, model) -> model) t)

fileDecoder : Decoder (List (String, Model))
fileDecoder =
  gistDecoder
  |> keyValuePairs

gistDecoder : Decoder Model
gistDecoder =
  object2 Model
    ("filename" := string)
    ("content" := string)

