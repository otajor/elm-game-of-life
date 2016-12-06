module Model exposing (..)

type alias Cell = (Int, Int) -- denotes cell's location on board
type alias Model =
  { boardSize : Int
  , cellSize : Int
  , liveCells : List Cell
  }

model =
  { boardSize = 30
  , cellSize = 10
  , liveCells = -- live cells on start
    [ (0,0)
    , (0,1)
    , (0,2)
    , (0,3)
    , (0,4)
    , (2,0)
    , (2,4)
    , (4,0)
    , (4,1)
    , (4,2)
    , (4,3)
    , (4,4)
    ]
  }
