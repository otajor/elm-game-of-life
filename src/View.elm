module View exposing (..)

import Model exposing (Model, Cell)
import Update exposing (..)
import Html exposing (Html, div, button, text, p)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import List exposing (concat, concatMap, map, range)
import Set exposing (Set)

basicCellStyle : List (String, String)
basicCellStyle =
  [ ("height", "10px")
  , ("width", "10px")
  , ("display", "inline-block")
  ]

getCellColor : Bool -> (String, String)
getCellColor alive =
  if alive then
    ("background-color", "white")
  else
    ("background-color", "black")

getCellAction : Bool -> Cell -> Msg
getCellAction alive =
  if alive then
    RemoveCell
  else
    AddCell

cellToDiv : Set Cell -> Cell -> Html Msg
cellToDiv liveCells cell =
  let
    alive : Bool
    alive = isAlive liveCells cell
  in
    div 
      [ style (getCellColor alive :: basicCellStyle)
      , onClick (getCellAction alive cell)
      ] []

makeList : Int -> List Int
makeList gridSize = range (negate gridSize) gridSize

generateRow : Model -> Int -> List (Html Msg)
generateRow { liveCells, gridSize } xCoord =
  map
    (\yCoord -> cellToDiv liveCells (yCoord, xCoord))
    (makeList gridSize)

generateGrid : Model -> List (Html Msg)
generateGrid model =
  concatMap (generateRow model) (makeList model.gridSize)

view : Model -> Html Msg
view model =
  div
    [ style
      [ ("width", "610px")
      , ("height", "100%")
      , ("margin", "0 auto")
      , ("font-size", "0")
      ]
    ]
    (concat
      [ (generateGrid model)
      , [ p 
          [ style
            [ ("font-size", "16px")
            , ("font-family", "Times New Roman")
            , ("display", "inline-block")
            , ("margin", "5px 10px")
            ] 
          ] [ text "Click on a cell to animate or kill it. Click 'Next' to progress to the next generation."] ]
      , [ button 
          [ onClick NextTick ]
          [ text "Next" ]
        ]
      ]
    )
