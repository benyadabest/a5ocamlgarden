open A5

let parse_args () =
  match Sys.argv with
  | [| _; rows; cols; fps |] ->
    (int_of_string rows, int_of_string cols, int_of_string fps)
  | _ ->
    Printf.printf "Usage: %s <rows> <cols> <fps>\n" Sys.argv.(0);
    exit 1

let rec simulation_loop garden fps =
  Garden.display garden;
  if Garden.all_plants_dead garden then
    print_endline "All plants are dead X."
  else (
    Garden.step garden;
    Unix.sleepf (1.0 /. float_of_int fps);
    simulation_loop garden fps
)

let () =
  let rows, cols, fps = parse_args () in
  let garden = Garden.initialize rows cols in
  try
    simulation_loop garden fps
  with Sys.Break ->
    print_endline "\nOops."
    
