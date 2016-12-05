module Model exposing (..)
import List

-- MODEL
type alias Cell = (Int, Int) -- denotes cell's location on board
type alias Model =
  { boardSize : Int
  , cellSize : Int
  , liveCells : List Cell
  }

model =
  { boardSize = 40
  , cellSize = 7
  , liveCells =
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
