module Admin exposing (main)

import Array
import Html exposing (..)



type alias Model =
    { boardId : Maybe String
    , gameBoard : List String
    }


init : Model
init =
    { boardId = Just ""
    , gameBoard = []
    }


type Msg
    = CreateBoard (List String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        CreateBoard stringList ->
            let _ = Debug.log "Gots me a msg " msg
            in model

view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Rotation - Game Admin" ]
        , text (toString model)
        ]



main : Program Never Model Msg
main =
    beginnerProgram
        { model = init
        , view = view
        , update = update
        }
