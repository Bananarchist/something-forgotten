module Main exposing (main)

import Browser
import Html as H exposing (Html)
import Html.Attributes as Hats
import Html.Events as Emits


type alias Model =
  { x : Int
  , y : Int
  , facing : Direction
  }

type Direction
  = North
  | East
  | South
  | West

type Msg 
  = MoveForward
  | TurnRight
  | TurnLeft


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : () -> (Model, Cmd Msg)
init _ =
  (Model 0 0 East, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoveForward ->
      (move (moveDirection model.facing) model, Cmd.none)

    TurnRight ->
      ({ model | facing = turnRight model.facing }, Cmd.none)

    TurnLeft ->
      ({ model | facing = turnLeft model.facing }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions = always Sub.none

move : (Int, Int) -> Model -> Model
move (dx, dy) model =
  clamp 0 4 (model.x + dx) |> \x ->
    clamp 0 4 (model.y + dy) |> \y ->
      { model | x = x, y = y }

moveDirection : Direction -> (Int, Int)
moveDirection dir =
  case dir of
    North -> (0, -1)
    East -> (1, 0)
    South -> (0, 1)
    West -> (-1, 0)

turnRight : Direction -> Direction
turnRight dir =
  case dir of
    North -> East
    East -> South
    South -> West
    West -> North

turnLeft : Direction -> Direction
turnLeft dir =
  case dir of
    North -> West
    West -> South
    South -> East
    East -> North

viewControls : Model -> List (Html Msg)
viewControls model =
  [ H.nav []
    [ H.button [ Emits.onClick TurnLeft ] [ H.text "Left" ]
    , H.button [ Emits.onClick MoveForward ] [ H.text "Forward" ]
    , H.button [ Emits.onClick TurnRight ] [ H.text "Right" ]
    ]
  ]


directionAttribute : Model -> List (H.Attribute Msg)
directionAttribute {facing} =
  case facing of
    North -> [ Hats.style "transform" "rotate(180deg)" ]
    East -> [ Hats.style "transform" "rotate(270deg)" ]
    West -> [ Hats.style "transform" "rotate(90deg)" ]
    _ -> []

viewField : Model -> List (Html Msg)
viewField model =
  List.range 0 24
  |> List.map
    (\idx ->
      let 
          (robotAttrs, robotContent) = 
            if idx == model.y * 5 + model.x then 
              (Hats.id "robot" :: directionAttribute model, [ H.text "\u{1f916}" ])
            else
              ([], [])
      in
      H.div (robotAttrs ++ [Hats.class "grid-space"]) robotContent
    )
  |> H.section []
  |> List.singleton

view : Model -> Html Msg
view model =
  viewField model
  ++ viewControls model
  |> H.main_ []
