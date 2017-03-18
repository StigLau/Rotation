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
    case original of
        [] -> [] -- Came to the end of the list
        _  ->
            let
                tail = case (List.tail original) of
                        Just list -> list
                        _ -> []
                origHead = extractMaybe (List.head original)
                tailHead = extractMaybe (List.head tail)

                applicable = findApplicableRotations tailHead
                _ = Debug.log (tailHead ++ " <- Applicable rotations->" ) ( applicable )


                rotation1 = extractMaybe (List.head applicable)

                rotation = extractMaybe (findApplicabeRotations origHead tailHead)
            in
                [ rotation1 ] ++ rotatePipes tail


findApplicabeRotations: String -> String -> Maybe String
findApplicabeRotations thisHead nextHead =
    case Dict.get thisHead leftMatchDict of
            Nothing -> Just thisHead
            Just stringList -> List.head (Set.toList stringList)

extractMaybe: Maybe String -> String
extractMaybe maybeString =
    case maybeString of
        Just string -> string
        _ -> ""

findApplicableRotations: String -> List String
findApplicableRotations input =
    let
        rezz =
            if List.member input nully then
                nully
            else if List.member input stop then
                stop
            else if List.member input vinkel then
                vinkel
            else if List.member input fork then
                fork
            else if List.member input straight then
                straight
            else if List.member input cross then
                cross
            else
                []
        redacted = Set.diff (Set.fromList rezz) (Set.fromList [input])
    in
        Set.toList redacted

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

leftMatchDict = Dict.fromList[
              ( "0", allButLeftOpening )
            , ( "1", leftOpening )
            , ( "2", allButLeftOpening )
            , ( "3", leftOpening )
            , ( "4", allButLeftOpening )
            , ( "5", leftOpening )
            , ( "6", allButLeftOpening )
            , ( "7", leftOpening )
            , ( "8", allButLeftOpening )
            , ( "9", leftOpening )
            ]
allButLeftOpening = Set.diff all leftOpening


category = Dict.fromList[
              ( "0", ["0"])
            , ( "stop", ["1", "2", "4", "8"])
            , ( "vinkel", ["3", "6", "9", "C"] )
            , ( "fork", ["7", "B", "D", "E"] )
            , ( "straight", ["5", "A"] )
            , ( "cross", ["5", "A"] )
            ]

nully = ["0"]
stop = ["1", "2", "4", "8"]
vinkel = ["3", "6", "9", "C"]
fork = ["7", "B", "D", "E"]
straight = ["5", "A"]
cross = ["5", "A"]

--notIn: List String -> List String
--notIn remove = List.filter filterFunk remove

--filterFunk var = Set.remove "1" all

all = Set.fromList ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
leftOpening = Set.fromList ["1", "3", "5", "7", "9", "B", "D", "F"]
topOpening = Set.fromList ["8", "9", "A", "B", "C", "D", "E", "F"]
rightOpening = Set.fromList ["4", "5", "6", "7", "C", "D", "E", "F"]
bottomOpening = Set.fromList ["2", "3", "6", "7", "A", "B", "E", "F"]