(* A simple unit-testing framework. *)

type test = description * implementation
	and description = string
	and implementation =
		| Case of (unit -> unit)
		| Suite of test list

(** Returns true if and only if the given function raises no exceptions. *)
let successful fn = try fn (); true with _ -> false

(** Asserts that the given values are logically equal. *)
let assert_equal x y = assert (x = y)

(** Asserts that the given value is true. *)
let assert_true x = assert x

(** Asserts that the given value is false. *)
let assert_false x = assert (not x)

(** Raised when a failure was expected, but not detected. *)
exception Failure_expected

(** A generic test failure. *)
exception Test_failure of string

(** Asserts that the given function raises an exception *)
(** that matches the given exception matching function. *)
let assert_raises_match exception_match fn =
	try
		fn ();
		raise Failure_expected
	with failure ->
		if not (exception_match failure)
			then raise failure
			else ()

(** Asserts that the given function raises the given exception. *)
let assert_raises expected =
	assert_raises_match (function exn -> exn = expected)

(** Asserts that the given function fails with any exception. *)
let assert_raises_any f =
	try
		f ();
		raise Failure_expected
	with failure ->
		()

(** Fails with the given message. *)
let fail message = raise (Test_failure ("failure: " ^ message))
