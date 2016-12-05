module Main exposing (..)
import Html exposing (Html, div)
import Model exposing (model)
import Update exposing (update)
import View exposing (view)

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }