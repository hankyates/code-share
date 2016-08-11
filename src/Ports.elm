port module Ports exposing (gistFetch)

port gistFetch : Maybe String -> Cmd msg
