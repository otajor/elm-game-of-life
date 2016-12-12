module Model exposing (..)

import Set exposing (Set, fromList)

type alias Cell = (Int, Int) -- denotes cell's location on grid
type alias Model =
  { gridSize : Int
  , liveCells : Set Cell
  }

model =
  { gridSize = 30
  , liveCells =
      fromList
        [ (-2, -2)
        , (-2, -1)
        , (-2, 0)
        , (-2, 1)
        , (-2, 2)
        , (0, -2)
        , (0, 2)
        , (2, -2)
        , (2, -1)
        , (2, 0)
        , (2, 1)
        , (2, 2)
        ]
  }
