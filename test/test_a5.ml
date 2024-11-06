open OUnit2
open QCheck
open A5

let test_create _ =
  let plant = Plant.create () in
  assert_equal 10 (Plant.health plant);
  assert_equal 1 (Plant.size plant);
  assert_equal 0 (Plant.age plant)

let test_empty_plant _ =
  let empty = Plant.empty_plant () in
  assert_equal 0 (Plant.health empty);
  assert_equal 0 (Plant.size empty);
  assert_equal 0 (Plant.age empty);
  assert_bool "is_empty true for empty plant" (Plant.is_empty empty)

let test_decrease_health _ =
  let plant = Plant.create () in
  Plant.decrease_health plant;
  assert_equal 9 (Plant.health plant)

let test_grow _ =
  let plant = Plant.create () in
  let original_size = Plant.size plant in
  Plant.grow plant;
  assert_bool "size increases or stays the same" (Plant.size plant >= original_size)

let test_age_and_increment_age _ =
  let plant = Plant.create () in
  assert_equal 0 (Plant.age plant);
  Plant.increment_age plant;
  assert_equal 1 (Plant.age plant)

let test_is_dead _ =
  let plant = Plant.create () in
  Plant.set_health plant 0;
  assert_bool "plant dies when health is 0" (Plant.is_dead plant);
  Plant.set_health plant 10;
  Plant.set_size plant 6;
  assert_bool "plant dies when size reaches 6" (Plant.is_dead plant);
  Plant.set_size plant 1;
  Plant.set_age plant 20;
  assert_bool "plant dies when age reaches 20" (Plant.is_dead plant)

let test_should_reproduce _ =
  let plant = Plant.create () in
  Plant.set_size plant 5;
  assert_bool "reproduces when size is 5" (Plant.should_reproduce plant)

let test_initialize _ =
  let garden = Garden.initialize 5 5 in
  assert_equal 5 (Garden.get_rows garden);
  assert_equal 5 (Garden.get_cols garden);
  assert_equal 0 (Garden.get_generation garden)

let test_step _ =
  let garden = Garden.initialize 5 5 in
  let initial_generation = Garden.get_generation garden in
  Garden.step garden;
  assert_equal (initial_generation + 1) (Garden.get_generation garden)

let grow_size_non_decreasing =
  Test.make ~name:"Plant.grow should not decrease size"
    QCheck.unit
    (fun () ->
       let plant = Plant.create () in
       let initial_size = Plant.size plant in
       Plant.grow plant;
       Plant.size plant >= initial_size)

let decrease_health_non_negative =
  Test.make ~name:"Plant.decrease_health doesn't make health negative"
    QCheck.unit
    (fun () ->
       let plant = Plant.create () in
       Plant.decrease_health plant;
       Plant.health plant >= 0)

let garden_initialization_cells =
  Test.make ~name:"Garden.initialize cells empty or plants with positive size"
    (QCheck.pair (QCheck.int_bound 10) (QCheck.int_bound 10))
    (fun (rows, cols) ->
       let garden = Garden.initialize rows cols in
       Array.for_all (Array.for_all (fun cell ->
           Plant.is_empty cell || Plant.size cell > 0)) (Garden.get_grid garden))

let qcheck_tests = [
  QCheck_runner.to_ounit2_test grow_size_non_decreasing;
  QCheck_runner.to_ounit2_test decrease_health_non_negative;
  QCheck_runner.to_ounit2_test garden_initialization_cells;
]

let suite =
  "Test Suite for A5" >::: [
    "test_create" >:: test_create;
    "test_empty_plant" >:: test_empty_plant;
    "test_decrease_health" >:: test_decrease_health;
    "test_grow" >:: test_grow;
    "test_age_and_increment_age" >:: test_age_and_increment_age;
    "test_is_dead" >:: test_is_dead;
    "test_should_reproduce" >:: test_should_reproduce;
    "test_initialize" >:: test_initialize;
    "test_step" >:: test_step;
  ] @ qcheck_tests

let () =
  run_test_tt_main suite
