module Model exposing (..)

type alias Cell = (Int, Int) -- denotes cell's location on board
type alias Model =
  { boardSize : Int
  , liveCells : List Cell
  }

model =
  { boardSize = 30
  , liveCells = -- live cells on start
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
