(* === A simple unit-testing framework. === *)

(* === Types === *)

type test =
	| Case  of name * description * case
	| Suite of name * description * suite
	and name        = string
	and description = string
	and case        = unit -> unit
	and suite       = test list

exception Failure_expected

exception Failure of string

(* === Checks and assertions === *)

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

(* === Console styles === *)

type style = Reset | Bold | Dim | Red | Green | Blue | Yellow

let int_of_style = function
	| Reset  ->  0
	| Bold   ->  1
	| Dim    ->  2
	| Red    -> 31
	| Green  -> 32
	| Yellow -> 33
	| Blue   -> 34

let string_of_style value = string_of_int (int_of_style value)

let escape = String.make 1 (char_of_int 0x1b)

let style values =
	Printf.sprintf "%s[%sm" escape (String.concat ";" (List.map (string_of_style) values))

(* === Indices === *)

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
	| (key, Case  (_, description, _))
	| (key, Suite (_, description, _))
	-> (style [Bold]) ^ key ^ (style [Reset]) ^ "\n    " ^ description

let string_of_index index =
	"\n" ^ (String.concat "\n" (List.map string_of_index_entry index)) ^ "\n"

(* === Runners === *)

(** Runs the given test. *)
let run test =
	let rec run prefix = function
	| Case (name, description, fn) ->
		begin
			print_string ("testing: " ^ prefix ^ name ^ " ");
			try
				fn ();
				print_endline ("\t[" ^ (style [Bold; Green]) ^ "pass" ^ (style [Reset]) ^ "]");
				(1, 0)
			with failure ->
				print_endline ("\t[" ^ (style [Bold; Red]) ^ "fail" ^ (style [Reset]) ^ "]");
				print_endline "";
				print_endline ((style [Bold]) ^ (Printexc.to_string failure) ^ (style [Reset]));
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
	print_endline "";
	let passed, failed = run "" test in
	print_endline "";
	print_endline ("tested: [" ^ (style [Bold]) ^ (string_of_int (passed + failed)) ^ (style [Reset]) ^ "]");
	print_endline ("passed: [" ^ (style [Bold]) ^ (string_of_int (passed         )) ^ (style [Reset]) ^ "]");
	print_endline ("failed: [" ^ (style [Bold]) ^ (string_of_int (         failed)) ^ (style [Reset]) ^ "]");
	print_endline ""

(* === Command line interface === *)

(** Argument values. *)
let list = ref false
let name = ref None

(** Argument definitions. *)
let arguments =
[
	"-list",
		Arg.Set list,
		"lists the tests available in this module";
	"-name",
		Arg.String (fun name' -> name := Some name'),
		"runs the test with the given name";
]

(** For now, ignore anonymous arguments. *)
let process_anonymous_argument string = ()

(** For now, have a blank usage message. *)
let usage = ""

let make_command_line_interface test =
	Arg.parse arguments process_anonymous_argument usage;
	let index = build_index test in
	if !list
	then print_endline (string_of_index index)
	else match !name with
		| Some name -> run (List.assoc name index)
		| None -> run test
