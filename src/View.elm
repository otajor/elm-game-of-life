module View exposing (..)
import Model exposing (Model, Cell)
import Update exposing (..)
import Html exposing (Html, div, button, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode exposing (succeed)
import List
import Debug exposing (..)

basicCellStyle : List (String, String)
basicCellStyle =
  [ ("height", "7px")
  , ("width", "7px")
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

cellToDiv : List Cell -> Cell -> Html Msg
cellToDiv liveCells cell =
  let
    alive : Bool
    alive = isAlive liveCells cell
  in
    div 
      [ style (getCellColor alive :: basicCellStyle)
      , onClick (getCellAction alive cell)
      ] []

toList : Int -> List Int
toList boardSize = List.range (negate boardSize) boardSize

generateRow : Model -> Int -> List (Html Msg)
generateRow { liveCells, boardSize } xCoord =
  List.map
    (\yCoord -> cellToDiv liveCells (yCoord, xCoord))
    (toList boardSize)

--generateBoard : Model -> List (List (Html Msg))
generateBoard : Model -> List (Html Msg)
generateBoard model =
  --List.map (generateRow model) (toList model.boardSize)
  List.concatMap (generateRow model) (toList model.boardSize)

drawRow : List (Html Msg) -> Html Msg
drawRow row =
  div
    [ style
      [ ("height", "7px") ]
    ] (row)


view : Model -> Html Msg
view model =
  div
    [ style
      [ ("width", "567px")
      , ("height", "100%")
      , ("font-size", "0")
      ]
    ]
    (List.append
      --(List.map drawRow (generateBoard model))
      (generateBoard model)
      [ button [ onClick NextTick ] [ text "Next" ] ]
    )