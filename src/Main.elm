module Main exposing (..)

import Html exposing (program)
import GameEngine


main : Program Never GameEngine.Model GameEngine.Msg
main =
    program
        { init = GameEngine.init
        , view = GameEngine.view
        , update = GameEngine.update
        , subscriptions = subscriptions
        }

subscriptions : GameEngine.Model -> Sub GameEngine.Msg
subscriptions model = Sub.none