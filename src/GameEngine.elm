module GameEngine exposing (init, view, update)

import Array
import Html exposing (..)
import Html.Attributes exposing (class, href, type_)


type alias Model =
    { --boardId : Maybe String
    gameBoard : List (List String)
    }


init : Model
init =
    { --boardId = Just "1"
    gameBoard = paddedTestBoard
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
        [ h1 [] [ text "Rotation - the game of revolving pipes and shit!" ]
        , text (toString model)
        , boardView model
        ]

boardView : Model -> Html Msg
boardView model =
    div [ class "listings" ]
        [ h1 [] [ text ("Current board") ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ] , th [] [] , th [] []
                    ]
                ]
            , tbody [] (List.map dvlRefRow model.gameBoard)
            ]
        ]

dvlRefRow : List String -> Html Msg
dvlRefRow row =
    tr []
          [ td []  [ text "row.id " ]
        ]


normalTestBoard =
    [ ["0", "1", "A"]
    , ["2", "B", "C"]
    , ["A", "0", "D"]
    ]

paddedTestBoard =
    [ ["0", "0", "0", "0", "0"]
    , ["0", "0", "1", "A", "0"]
    , ["0", "2", "B", "C", "0"]
    , ["0", "A", "0", "D", "0"]
    , ["0", "0", "0", "0", "0"]
    ]