module Update exposing (..)

import Model exposing (Cell, Model)
import Html exposing (Html)
import List exposing (concatMap)
import Set exposing (Set, map, filter, foldl, union, size, member, insert, remove, fromList, toList, empty)

type Msg
  = NextTick
  | AddCell Cell
  | RemoveCell Cell

isAlive : Set Cell -> Cell -> Bool
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

countLiveNeighbours : Set Cell -> Cell -> Int
countLiveNeighbours liveCells =
  size << filter (isAlive liveCells) << fromList << getNeighbours

getCellValues : Set Cell -> Cell -> { isAlive: Bool, liveNeighbours: Int}
getCellValues liveCells cell =
  { isAlive = isAlive liveCells cell
  , liveNeighbours = countLiveNeighbours liveCells cell
  }

shouldLivePredicate : { isAlive: Bool, liveNeighbours: Int} -> Bool
shouldLivePredicate { isAlive, liveNeighbours } =
  liveNeighbours == 3 || isAlive && liveNeighbours == 2

willLive : Set Cell -> Cell -> Bool
willLive liveCells =
  shouldLivePredicate << getCellValues liveCells

potentialLiveCells : Set Cell -> Set Cell
potentialLiveCells =
  fromList << concatMap getNeighbours << toList

getNextLiveCells : Set Cell -> Set Cell
getNextLiveCells liveCells =
  filter (willLive liveCells) <| potentialLiveCells liveCells

update : Msg -> Model -> Model
update msg model =
  case msg of
    NextTick ->
      { model | liveCells = getNextLiveCells model.liveCells }
    AddCell cell ->
      { model | liveCells = insert cell model.liveCells }
    RemoveCell cell ->
      { model | liveCells = remove cell model.liveCells }

