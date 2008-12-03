(* A simple unit-testing framework. *)

type test =
	| Case  of name * (description * case)
	| Suite of name * (description * suite)
	and name        = string
	and description = string
	and case        = unit -> unit
	and suite       = test list

exception Failure_expected

exception Failure of string

let successful fn = try fn (); true with _ -> false

let assert_equal x y = assert (x = y)

let assert_true x = assert x

let assert_false x = assert (not x)

let assert_raises_match exception_match fn =
	try
		fn ();
		raise Failure_expected
	with failure ->
		if not (exception_match failure)
			then raise failure
			else ()

let assert_raises expected =
	assert_raises_match (function exn -> exn = expected)

let assert_raises_any f =
	try
		f ();
		raise Failure_expected
	with failure ->
		()

let fail message = raise (Failure ("failure: " ^ message))
