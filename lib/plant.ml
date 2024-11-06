type t = {
  mutable health : int;
  mutable size : int;
  mutable age : int;
}
(** AF: Plant module represents individual plant with three main attributes: 
t.health (int) where 0 means death, t.size (int) height level that's max of 7 
and influences reproduction, t.age (int) increments at time step with max of 20.
RI: health >= 0, 0<= size <= 7, 0<=age<=20.*)


let create () =
  { health = 10; size = 1; age = 0 }

let empty_plant () =
  { health = 0; size = 0; age = 0 }

let is_empty p =
  p.health <= 0

let decrease_health p =
  p.health <- p.health - 1

let grow p =
  if Random.float 1.0 < 0.2 then
    p.size <- p.size + 1

let age p = p.age

let health p = p.health

let increment_age p =
  p.age <- p.age + 1

let size p = p.size

let is_dead p =
  p.health <= 0 || p.size >= 6 || p.age >= 20

let should_reproduce p =
  p.size = 5

let set_health p h = p.health <- h

let set_size p s = p.size <- s

let set_age p a = p.age <- a