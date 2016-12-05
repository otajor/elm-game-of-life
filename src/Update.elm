module Update exposing (..)
import Model exposing (..)
import Html exposing (Html)
import Set exposing (Set, fromList, toList)
import List exposing (concatMap, map, append, filter, length, member)
import Debug

type Msg
  = NextTick
  | AddCell Cell
  | RemoveCell Cell

isAlive : List Cell -> Cell -> Bool
isAlive = flip member

getNeighbours : Cell -> List Cell
getNeighbours (x, y) =
  [ (x - 1, y - 1)
  , (x - 1, y)
  , (x - 1, y + 1)
  , (x, y - 1)
  , (x, y + 1)
  , (x + 1, y - 1)
  , (x + 1, y)
  , (x + 1, y + 1)
  ]

countLiveNeighbours : List Cell -> Cell -> Int
countLiveNeighbours liveCells =
  length << filter (isAlive liveCells) << getNeighbours

getCellValues : List Cell -> Cell -> { isAlive: Bool, liveNeighbours: Int}
getCellValues liveCells cell =
  { isAlive = isAlive liveCells cell
  , liveNeighbours = countLiveNeighbours liveCells cell
  }

shouldLivePredicate : { isAlive: Bool, liveNeighbours: Int} -> Bool
shouldLivePredicate { isAlive, liveNeighbours } =
  liveNeighbours == 3 || isAlive && liveNeighbours == 2

willLive : List Cell -> Cell -> Bool
willLive liveCells =
  shouldLivePredicate << getCellValues liveCells

-- convert to set and back to remove duplicates
potentialLiveCells : List Cell -> List Cell
potentialLiveCells =
  toList << fromList << concatMap getNeighbours

getNextLiveCells : List Cell -> List Cell
getNextLiveCells liveCells =
  filter (willLive liveCells) <| potentialLiveCells liveCells

update : Msg -> Model -> Model
update msg model =
  case msg of
    NextTick ->
      { model | liveCells = getNextLiveCells model.liveCells }
    AddCell cell ->
      { model | liveCells = cell :: model.liveCells }
    RemoveCell cell ->
      { model | liveCells = filter ((/=) cell) model.liveCells }

