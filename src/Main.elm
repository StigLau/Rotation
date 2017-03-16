module Main exposing (..)

import Html exposing (beginnerProgram)
import GameEngine


--main : Program Never
main =
    beginnerProgram
        { model = GameEngine.init
        , view = GameEngine.view
        , update = GameEngine.update
        }
