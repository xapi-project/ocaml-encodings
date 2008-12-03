(* A simple unit-testing framework. *)

type test =
	| Case  of name * description * case
	| Suite of name * description * suite
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

let build_index =
	let rec build prefix = function
		| Case (name, description, case) ->
			[(prefix ^ name, Case (name, description, case))]
		| Suite (name, description, tests) ->
			(prefix ^ name, Suite (name, description, tests)) ::
			(List.flatten (List.map (build (prefix ^ name ^ ".")) tests))
	in
	build ""

let string_of_index_entry = function
	| (key, Case  (_, description, _)) -> key ^ "\n    " ^ description
	| (key, Suite (_, description, _)) -> key ^ "\n    " ^ description

let string_of_index index = (String.concat "\n" (List.map string_of_index_entry index))

(** Runs the given test. *)
let run test =
	let rec run prefix = function
	| Case (name, description, fn) ->
		begin
			print_string ("testing: " ^ prefix ^ name ^ " ");
			try
				fn ();
				print_endline "\t[pass]";
				(1, 0)
			with failure ->
				print_endline "\t[fail]";
				print_endline "";
				print_endline (Printexc.to_string failure);
				print_endline "";
				(0, 1)
		end
	| Suite (name, description, tests) ->
		begin
			print_string ("opening: " ^ prefix ^ name ^ "\n");
			let passed = ref 0 in
			let failed = ref 0 in
			List.iter
				(fun test ->
					let (passed', failed') = run (prefix ^ name ^ ".") test in
					passed := !passed + passed';
					failed := !failed + failed')
				tests;
			(!passed, !failed)
		end
	in
	run "" test

let anon_function string = ()
let usage = ""

let list = ref false
let name = ref ""

let arguments =
[
	"-list", Arg.Set list, "lists the tests available in this module.";
	"-name", Arg.Set_string name, "runs the test with the given name.";
]

let make_command_line_interface test =
	Arg.parse arguments anon_function usage;
	let index = build_index test in	
	if !list then
		begin
			print_endline "";
			print_endline (string_of_index index);
			print_endline "";
			flush stdout
		end
	else
		begin
			let test = if (!name = "") then
				test
			else
				List.assoc !name index
			in
			print_endline "";
			let passed, failed = run test in
			print_endline "";
			print_endline ("tested: " ^ (string_of_int (passed + failed)));
			print_endline ("passed: " ^ (string_of_int passed));
			print_endline ("failed: " ^ (string_of_int failed));
			print_endline "";
		end
