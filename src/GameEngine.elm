module GameEngine exposing (init, view, update, Model, Msg)

import Set
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (..)
import Http
import Json.Decode as JsonD
import Json.Encode as JsonE

type alias Model =
    { gameBoard : GameBoard
    }

type alias GameBoard =
    { boardId : String
    , values: List String
    }

initModel =
    { gameBoard = GameBoard "123" testBoardAsList
    }

init : ( Model, Cmd Msg )
init = ( initModel, (getBoard initModel.gameBoard.boardId FetchBoardResponseHandler) )

type Msg
    = FetchBoard String
    | FetchBoardResponseHandler (Result Http.Error GameBoard)
    | StoreBoard
    | SortBoard
    | SetBoardId String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchBoard id ->
            ( model, getBoard id FetchBoardResponseHandler )

        StoreBoard ->
            ( model, updateKompo model.gameBoard FetchBoardResponseHandler )

        SortBoard ->
            let
                _ = Debug.log "Commence rotation! " msg
                gBoard = model.gameBoard
                gBoard2 = { gBoard | values = rotatePipes model.gameBoard.values }
            in
                ({ model | gameBoard = gBoard2 }, Cmd.none)

        FetchBoardResponseHandler res -> case res of
            Result.Ok gameBoard ->
                ({ model | gameBoard = gameBoard }, Cmd.none)

            Result.Err err ->
                let _ = Debug.log "Error retrieving gameBoard" err
                in (model, Cmd.none)

        SetBoardId boardId ->
            let
                bord = model.gameBoard
                bord2 = {bord | boardId = boardId }
            in
                ( { model | gameBoard = bord2 }, Cmd.none )


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
        [ h1 [] [ text ("Game board: " ++ model.gameBoard.boardId) ]
        , boardView model
        , button [ type_ "button", onClick SortBoard ] [ text "Commence Rotation" ]
        , div [] [input
            [ type_ "text"
                --, placeholder "Dvl Reference"
                , onInput SetBoardId
                , Html.Attributes.value model.gameBoard.boardId
            ] []
        ,  button [ type_ "button", onClick (FetchBoard model.gameBoard.boardId) ] [ text "Get Dvl" ] ]
        , div [] [text ("Current model: " ++ (toString model))]

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
            , tbody [] (List.map extractRows [ model.gameBoard.values ])
            ]
        ]

extractRows : List String -> Html Msg
extractRows row = tr [] [ td []  [ text(  foldText row) ] ]

foldText: List String -> String
foldText stringlist = List.foldl foldTextRule "" stringlist

foldTextRule: String -> String -> String
foldTextRule val end = val ++ "\t" ++ end


{--API calls against backend store--}
storeUrl : String
storeUrl = "http://rotation.makeshitapp.com/"

getBoard : String -> (Result Http.Error GameBoard -> msg) -> Cmd msg
getBoard id msg = Http.get (storeUrl ++ id) boardDecoder |> Http.send msg

updateKompo: GameBoard -> (Result Http.Error GameBoard -> msg) -> Cmd msg
updateKompo gameBoard msg =
    Http.request
        { method = "PUT"
        , headers = []
        , url = storeUrl ++ gameBoard.boardId --?" ++ toString gameBoard.name
        , body = Http.stringBody "application/json" <| encodeBoard gameBoard
        , expect = Http.expectJson boardDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send msg


boardDecoder : JsonD.Decoder GameBoard
boardDecoder =
            JsonD.map2 GameBoard
                           (JsonD.field "_id" JsonD.string)
                           (JsonD.field "board" <| (JsonD.list JsonD.string) )

encodeBoard : GameBoard -> String
encodeBoard board =
    JsonE.encode 0 <|
        JsonE.object
            [ ( "_id", JsonE.string board.boardId )
            --, ( "board", JsonE.list <| List.map encodeSegment board.values )
            , ( "board", JsonE.list <| List.map JsonE.string board.values )
            ]

{-- Test- and Setup-Data --}

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


all = Set.fromList ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
leftOpening = Set.fromList ["1", "3", "5", "7", "9", "B", "D", "F"]
topOpening = Set.fromList ["8", "9", "A", "B", "C", "D", "E", "F"]
rightOpening = Set.fromList ["4", "5", "6", "7", "C", "D", "E", "F"]
bottomOpening = Set.fromList ["2", "3", "6", "7", "A", "B", "E", "F"]