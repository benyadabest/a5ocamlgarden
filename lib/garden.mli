type t
(** Abstract type representing a garden.*)

val initialize : int -> int -> t
(** [initialize rows cols] creates a garden of size [rows] x [cols] with randomly placed plants.*)

val step : t -> unit
(** [step g] advances the garden [g] by one generation, applying plant growth, health reduction, reproduction, aging, and death rules to each plant.*)

val display : t -> unit
(** [display g] prints a visual representation of the garden [g] to the terminal, with plant symbols and colors applied using ANSITerminal for visualization.*)

val get_rows : t -> int
(** [get_rows g] returns the number of rows in the garden [g].*)

val get_cols : t -> int
(** [get_cols g] returns the number of columns in the garden [g].*)

val get_generation : t -> int
(** [get_generation g] returns the current generation count of the garden [g], representing the number of time steps that have elapsed.*)

val get_grid : t -> Plant.t array array
(** [get_grid g] returns the 2D array grid representing the plants and empty cells in the garden [g].*)

val all_plants_dead : t -> bool
(** [all_plants_dead g] returns true if all plants in the garden [g] are dead, indicating the end of the simulation.*)
