module GameEngine exposing (init, view, update)

import Set
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)

type alias Model =
    { --boardId : Maybe String
    gameBoard : List (List String),
    fun: Dict.Dict String (List String) -- Test of dictionary
    }


init : Model
init =
    { --boardId = Just "1"
    gameBoard = normalTestBoard
    , fun = whatMatches
    }


type Msg
    = CreateBoard (List String)
    | SortBoard


update : Msg -> Model -> Model
update msg model =
    case msg of
        CreateBoard stringList ->
            let _ = Debug.log "Gots me a msg " msg
            in model

        SortBoard ->
            let
                _ = Debug.log "Commence rotation! " msg
                sortedBoard = rotatePipes model.gameBoard
            in
                { model | gameBoard = sortedBoard }

rotatePipes: List (List String) -> List (List String)
--rotatePipes original = List.map traverse original
rotatePipes original =
    let
        _ = Debug.log "Head; " List.head original
        tail = case (List.tail original) of
            Just something -> something
            _ -> []

    in
        tail



traverse: List String -> List String
traverse stringList = List.map mapper stringList

mapper asd = asd ++ "12"

view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Rotation - the game of revolving pipes and shit!" ]
        , boardView model
        , button [ type_ "button", onClick SortBoard ] [ text "Commence Rotation" ]
        , text ("Current model: " ++ (toString model))
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
            , tbody [] (List.map extractRows model.gameBoard)
            ]
        ]

extractRows : List String -> Html Msg
extractRows row = tr [] [ td []  [ text(  foldText row) ] ]

foldText: List String -> String
foldText stringlist = List.foldl foldTextRule "" stringlist

foldTextRule: String -> String -> String
foldTextRule val end = val ++ "\t" ++ end


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

whatMatches = Dict.fromList[
              ( "0", all )
            , ( "1", leftOpening )
            , ( "2", ["0"] ++ bottomOpening )
            , ( "3", leftOpening ++ bottomOpening )
            , ( "4", ["0"] ++ rightOpening )
            , ( "5", leftOpening ++ rightOpening)
            , ( "6", ["0"] ++ rightOpening ++ bottomOpening)
            , ( "7", rightOpening ++ bottomOpening ++ leftOpening)
            , ( "8", ["0"] ++ topOpening)
            , ( "9", leftOpening ++ topOpening)
            ]

--notIn: List String -> List String
--notIn remove = List.filter filterFunk remove

--filterFunk var = Set.remove "1" all

all = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
leftOpening = ["1", "3", "5", "7", "9", "B", "D", "F"]
topOpening = ["8", "9", "A", "B", "C", "D", "E", "F"]
rightOpening = ["4", "5", "6", "7", "C", "D", "E", "F"]
bottomOpening = ["2", "3", "6", "7", "A", "B", "E", "F"]