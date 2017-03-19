module Main exposing (..)

import Html exposing (..)
import Listings as Listing
import GameEngine as GameEngine


type alias Model = {
     listing : Listing.Model
    , gameEngine: GameEngine.Model
    }

type Msg
    = ListingMsg Listing.Msg
    | GameEngineMsg GameEngine.Msg

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListingMsg msg ->
            let
                (listingModel, cmd, outmsg) = Listing.update msg model.listing
            in
                ({model | listing = listingModel }, Cmd.map ListingMsg cmd)

        GameEngineMsg msg ->
                    let
                        (gameEngineModel, cmd) = GameEngine.update msg model.gameEngine
                    in
                        ({model | gameEngine = gameEngineModel}, Cmd.map GameEngineMsg cmd)


init : ( Model, Cmd Msg )
init =
    let
        ( listing, listingCmd )         = Listing.init
        ( gameEngine, gameEngineCmd )   = GameEngine.init
    in
        ( Model listing gameEngine
        , Cmd.batch [
            Cmd.map ListingMsg      listingCmd
            , Cmd.map GameEngineMsg   gameEngineCmd
            ] )

view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Rotation - the game of revolving pipes" ]
        , Html.map ListingMsg (Listing.view model.listing)
        , Html.map GameEngineMsg (GameEngine.view model.gameEngine)
        ]

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }