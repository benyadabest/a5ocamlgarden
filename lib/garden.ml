open Plant
open ANSITerminal

type t = {
  grid : Plant.t array array;
  rows : int;
  cols : int;
  generation : int ref;
}
(** AF: Garden module represents garden as 2D grid of cells containing Plant or empty: 
grid (Plant.t array array) is 2D array, rows and cols (ints) dimensions, generation (int ref) amount of steps in simulation done.
Garden.grid is rows x cols, contains Plant or empty denoted by Plant.empty_plant ().
RI: rows>0, cols>0, 0<=age<=20, cell contents satisfy Plant RI Plant.is_empty cell || Plant.RI(cell), !(garden.generation) >= 0.*)

let get_rows g = g.rows

let get_cols g = g.cols

let get_generation g = !(g.generation)

let get_grid g = g.grid

let initialize rows cols =
  let grid = Array.make_matrix rows cols (Plant.empty_plant ()) in
  for i = 0 to rows - 1 do
    for j = 0 to cols - 1 do
      if Random.float 1.0 < 0.1 then 
        grid.(i).(j) <- Plant.create ()
    done
  done;
  { grid; rows; cols; generation = ref 0 }

  let get_neighbors (rows, cols) (x, y) =
  let within_bounds (i, j) =
    i >= 0 && i < rows && j >= 0 && j < cols
  in
  List.filter within_bounds
    [(x-1, y); (x+1, y); (x, y-1); (x, y+1);
      (x-1, y-1); (x-1, y+1); (x+1, y-1); (x+1, y+1)]

let step garden =
  let new_plants = ref [] in
  for i = 0 to garden.rows - 1 do
    for j = 0 to garden.cols - 1 do
      let plant = garden.grid.(i).(j) in
      if not (Plant.is_empty plant) then (
        Plant.decrease_health plant;
        Plant.grow plant;
        Plant.increment_age plant;
        if Plant.should_reproduce plant then
          let neighbors = get_neighbors (garden.rows, garden.cols) (i, j) in
          let empty_neighbors = List.filter (fun (x, y) -> Plant.is_empty garden.grid.(x).(y)) neighbors in
          if empty_neighbors <> [] then
            let (x, y) = List.nth empty_neighbors (Random.int (List.length empty_neighbors)) in
            new_plants := (x, y) :: !new_plants;
        if Plant.is_dead plant then (
          garden.grid.(i).(j) <- Plant.empty_plant ();
          let neighbors = get_neighbors (garden.rows, garden.cols) (i, j) in
          let empty_neighbors = List.filter (fun (x, y) -> Plant.is_empty garden.grid.(x).(y)) neighbors in
          List.iter (fun (x, y) -> if List.length empty_neighbors > 1 then new_plants := (x, y) :: !new_plants) empty_neighbors
        )
      )
    done
  done;
  List.iter (fun (x, y) -> garden.grid.(x).(y) <- Plant.create ()) !new_plants;
  garden.generation := !(garden.generation) + 1

let all_plants_dead garden =
  Array.for_all (Array.for_all Plant.is_dead) garden.grid

let display garden =
  print_string [] "+";
  for _ = 0 to garden.cols - 1 do
    print_string [] "-"
  done;
  print_string [] "+\n";

  for i = 0 to garden.rows - 1 do
    print_string [] "|";
    for j = 0 to garden.cols - 1 do
      let plant = garden.grid.(i).(j) in
      if Plant.is_empty plant then
        print_string [] " "
      else
        let age = Plant.age plant in
        let (color, symbol) =
          match age with
          | a when a < 5 -> ([green], "*")
          | a when a < 10 -> ([yellow], "o")
          | _ -> ([red], "T")
        in
        print_string color symbol
    done;
    print_string [] "|\n"
  done;

  print_string [] "+";
  for _ = 0 to garden.cols - 1 do
    print_string [] "-"
  done;
  print_string [] "+\n"
  
  
