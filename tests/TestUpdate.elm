module TestUpdate exposing (..)

import Test exposing (..)
import Model exposing (..)
import Set exposing (Set, fromList)
import Update exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String

all : Test
all =
  describe "Game of Life"
    [ describe "isAlive"
      [ test "Returns true if cell is in liveCells" <|
        \() ->
          Expect.equal (isAlive [(1,0), (2,1), (2,2), (1,2), (0,2)] (1,0)) True
      , test "Returns false if cell is not in liveCells" <|
        \() ->
          Expect.equal (isAlive [(1,0), (2,1), (2,2), (1,2), (0,2)] (4,0)) False
      ]
    , describe "getNeighbours"
      [ test "Returns all neighbours of a given cell" <|
        \() ->
          Expect.equal (getNeighbours (1,1))
            [ (0,0)
            , (0,1)
            , (0,2)
            , (1,0)
            , (1,2)
            , (2,0)
            , (2,1)
            , (2,2)
            ]
      , test "Returns all neighbours of a given cell (including negatives)" <|
        \() ->
          Expect.equal (getNeighbours (0,0))
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            ]
      ]
    , describe "shouldLivePredicate"
      [ test "returns true for live cell with 3 neighbours" <|
        \() ->
          Expect.equal (shouldLivePredicate { isAlive = True, liveNeighbours = 3 }) True
      , test "returns true for live cell with 2 neighbours" <|
        \() ->
          Expect.equal (shouldLivePredicate { isAlive = True, liveNeighbours = 2 }) True
      , test "returns true for dead cell with 3 neighbours" <|
        \() ->
          Expect.equal (shouldLivePredicate { isAlive = False, liveNeighbours = 3 }) True
      , test "returns false for live cell with 0 neighbours" <|
        \() ->
          Expect.equal (shouldLivePredicate { isAlive = True, liveNeighbours = 0 }) False
      , test "returns false for dead cell with 6 neighbours" <|
        \() ->
          Expect.equal (shouldLivePredicate { isAlive = False, liveNeighbours = 6 }) False
      ]
    , describe "liveCellNeighbours"
      [ test "returns set of neighbours with no duplicates" <|
        \() ->
          Expect.equal (liveCellNeighbours [(0,0), (1,1)])
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,0)
            , (0,1)
            , (0,2)
            , (1,-1)
            , (1,0)
            , (1,1)
            , (1,2)
            , (2,0)
            , (2,1)
            , (2,2)
            ]
      , test "returns set of neighbours with no duplicates" <|
        \() ->
          Expect.equal (liveCellNeighbours [(0,0), (4,4)])
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            , (3,3)
            , (3,4)
            , (3,5)
            , (4,3)
            , (4,5)
            , (5,3)
            , (5,4)
            , (5,5)
            ]
      ] 
    , describe "countLiveNeighbours"
      [ test "returns number of live neighbours a cell has (1)" <|
        \() ->
          Expect.equal (countLiveNeighbours [(0,0), (1,1)] (1,0)) 2
      , test "returns number of live neighbours a cell has (2)" <|
        \() ->
          Expect.equal (countLiveNeighbours [(1,1)] (1,0)) 1
      , test "returns number of live neighbours a cell has (3)" <|
        \() ->
          Expect.equal (countLiveNeighbours
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            ] (0,0)) 8
      ]
    , describe "getCellValues"
      [ test "returns correct record for dead cell, 2 neighbours" <|
        \() ->
          Expect.equal (getCellValues [(0,0), (1,1)] (1,0))
            { isAlive = False
            , liveNeighbours = 2
            }
      , test "returns correct record for live cell, 1 neighbour" <|
        \() ->
          Expect.equal (getCellValues [(0,0), (1,0)] (1,0))
            { isAlive = True
            , liveNeighbours = 1
            }
      , test "returns correct record for live cell, 8 neighbours" <|
        \() ->
          Expect.equal (getCellValues
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,0)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            ] (0,0))
            { isAlive = True
            , liveNeighbours = 8
            }
      ]
    , describe "willLive"
      [ test "returns True for dead cell, 3 neighbours" <|
        \() ->
          Expect.equal (willLive [(0,0), (0,1), (1,1)] (1,0)) True
      , test "returns True for live cell, 3 neighbours" <|
        \() ->
          Expect.equal (willLive [(1,0), (0,0), (0,1), (1,1)] (1,0)) True
      , test "returns True for live cell, 2 neighbours" <|
        \() ->
          Expect.equal (willLive [(1,0), (0,0), (0,1)] (1,0)) True
      , test "returns False for live cell, 1 neighbour" <|
        \() ->
          Expect.equal (willLive [(0,0), (1,0)] (1,0)) False
      , test "returns False for live cell, 8 neighbours" <|
        \() ->
          Expect.equal (willLive
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,0)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            ] (0,0))
            False
      ]
    , describe "getNextLiveCells"
      [ test "returns correct next cells for given set of current live cells" <|
        \() ->
          Expect.equal (getNextLiveCells
            [ (-1,-1)
            , (-1,0)
            , (-1,1)
            , (0,-1)
            , (0,0)
            , (0,1)
            , (1,-1)
            , (1,0)
            , (1,1)
            ])
            [ (-2,0)
            , (-1,-1)
            , (-1,1)
            , (0,-2)
            , (0,2)
            , (1,-1)
            , (1,1)
            , (2,0)
            ]
      ]
    ]
