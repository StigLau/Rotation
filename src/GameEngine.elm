module GameEngine exposing (init, view, update)

import Set
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)

type alias Model =
    { --boardId : Maybe String
    --gameBoard : List (List String)
    gameBoard : List String
    -- , fun: Dict.Dict String (List String) -- Test of dictionary
    }


init : Model
init =
    { --boardId = Just "1"
    -- gameBoard = normalTestBoard
    gameBoard = testBoardAsList
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

rotatePipes: List String -> List String
rotatePipes original =
    let
        result = case original of
            [] -> [] -- Came to the end of the list
            _  ->
                let
                    tail = case (List.tail original) of
                            Just list -> list
                            _ -> []
                    origHead = extractMaybe (List.head original)
                    tailHead = extractMaybe (List.head tail)
                in
                    [ extractMaybe (findApplicabeRotations origHead tailHead) ] ++ rotatePipes tail
    in
        result

findApplicabeRotations: String -> String -> Maybe String
findApplicabeRotations thisHead nextHead =
    case Dict.get thisHead whatMatches of
            Nothing -> Nothing
            Just stringList -> List.head stringList

extractMaybe: Maybe String -> String
extractMaybe maybeString =
    case maybeString of
        Just string -> string
        _ -> ""

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
            , tbody [] (List.map extractRows [ model.gameBoard ])
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

testBoardAsList =
    ["0", "1", "A", "2", "B", "C", "A", "0", "D"]

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