type t
(** Abstract type representing a plant.*)

val create : unit -> t
(** [create ()] creates a new plant with initial health, age, and size.*)

val decrease_health : t -> unit
(** [decrease_health p] decreases the health of the plant [p] by one.*)

val empty_plant : unit -> t
(** [empty_plant ()] returns a plant with no health, size, or age, representing an empty cell in the garden grid.*)

val is_empty : t -> bool
(** [is_empty p] returns true if the plant [p] is an empty cell, with no health, size, or age.*)

val grow : t -> unit
(** [grow p] attempts to increase the size of the plant [p] with a 20% probability, up to a maximum height.*)

val age : t -> int
(** [age p] returns the age of the plant [p].*)

val health : t -> int
(** [health p] returns the current health of the plant [p].*)

val increment_age : t -> unit
(** [increment_age p] increases the age of the plant [p] by one step.*)

val size : t -> int
(** [size p] returns the size of the plant [p].*)

val is_dead : t -> bool
(** [is_dead p] returns true if the plant [p] has zero health, has reached its maximum height, or has exceeded the maximum age threshold.*)

val should_reproduce : t -> bool
(** [should_reproduce p] returns true if the plant [p] has reached the size required for reproduction.*)

val set_health : t -> int -> unit
(** [set_health p h] sets the health of the plant [p] to [h].*)

val set_size : t -> int -> unit
(** [set_size p s] sets the size of the plant [p] to [s].*)

val set_age : t -> int -> unit
(** [set_age p a] sets the age of the plant [p] to [a].*)
