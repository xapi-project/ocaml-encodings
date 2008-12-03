type test =
	| Case  of name * (description * case)
	| Suite of name * (description * suite)
	and name        = string
	and description = string
	and case        = unit -> unit
	and suite       = test list

(** Raised when a failure was expected, but not detected. *)
exception Failure_expected

(** A generic test failure. *)
exception Failure of string

(** Returns true if and only if the given function raises no exceptions. *)
val successful : (unit -> 'a) -> bool

(** Asserts that the given values are logically equal. *)
val assert_equal : 'a -> 'a -> unit

(** Asserts that the given value is true. *)
val assert_true : bool -> unit

(** Asserts that the given value is false. *)
val assert_false : bool -> unit

(** Asserts that the given function raises an exception *)
(** that matches the given exception matching function. *)
val assert_raises_match : (exn -> bool) -> (unit -> 'a) -> unit

(** Asserts that the given function raises the given exception. *)
val assert_raises : exn -> (unit -> 'a) -> unit

(** Asserts that the given function fails with any exception. *)
val assert_raises_any : (unit -> 'a) -> unit

(** Fails with the given message. *)
val fail : string -> 'a
