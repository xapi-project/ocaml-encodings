(* A unit testing framework for OCaml.                        *)
(* Author: Jonathan Knowles                                   *)
(* Copyright: 2008 Citrix Systems Research & Development Ltd. *)

open Printf

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

(** Whether or not to disable pretty-printing. *)
let ugly = ref false

let style values =
	if !ugly then "" else
	sprintf "%s[%sm" escape (String.concat ";" (List.map (string_of_style) values))

(* === Indices === *)

let index_of_test =
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

let max x y = if x > y then x else y

let longest_key_of_index index =
	List.fold_left
		(fun longest_key (key, _) ->
			max longest_key (String.length key))
		0 index

(* === Runners === *)

type test_result = passed * failed
	and passed = int
	and failed = int

let add_result (passed, failed) (passed', failed') =
	(passed + passed', failed + failed')

(** Runs the given test. *)
let run test =

	let longest_key_width = longest_key_of_index (index_of_test test) in

	(** Runs the given test with the given name prefix. *)
	let rec run (test : test) (name_prefix : string) : test_result =
		match test with
			| Case (name, description, fn) ->
				run_case (name_prefix ^ name, description, fn)
			| Suite (name, description, tests) ->
				run_suite (name_prefix ^ name, description, tests)

	(** Runs the given test case. *)
	and run_case (name, description, fn) =
		printf "testing %s" name;
		flush stdout;
		let padding = String.make (longest_key_width - (String.length name)) ' ' in
		try
			fn ();
			printf "%s\t[%s%s%s]\n" padding (style [Bold; Green]) "pass" (style [Reset]);
			(1, 0)
		with failure ->
			printf "%s\t[%s%s%s]\n" padding (style [Bold; Red]) "fail" (style [Reset]);
			printf "\n%s%s\n%s%s\n"
				(style [Bold])
				(Printexc.to_string failure)
				(Printexc.get_backtrace ())
				(style [Reset]);
			(0, 1)

	(** Runs the given test suite. *)
	and run_suite (name, description, tests) =
		flush stdout;
		let result = List.fold_left (
			fun accumulating_result test ->
				add_result accumulating_result (run test (name ^ "."))
		) (0, 0) tests in
		result
	in

	Printexc.record_backtrace true;
	printf "\n";
	let passed, failed = run test "" in
	printf "\n";
	printf "tested [%s%i%s]\n" (style [Bold]) (passed + failed) (style [Reset]);
	printf "passed [%s%i%s]\n" (style [Bold]) (passed         ) (style [Reset]);
	printf "failed [%s%i%s]\n" (style [Bold]) (         failed) (style [Reset]);
	printf "\n";
	passed, failed

(* === Factories === *)

let make_test_case name description case =
	Case (name, description, case)

let make_test_suite name description suite =
	Suite (name, description, suite)

let make_module_test_suite name suite =
	Suite (name, sprintf "Tests the %s module." name, suite)

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
	"-ugly",
		Arg.Set ugly,
		"disables pretty-printing";
]

(** For now, ignore anonymous arguments. *)
let process_anonymous_argument string = ()

(** For now, present a blank usage message. *)
let usage = ""

let make_command_line_interface test =
	(* TODO: Use stderr in appropriate places when presented with failures. *)
	Arg.parse arguments process_anonymous_argument usage;
	let index = index_of_test test in
	if !list
	then
		begin
			print_endline (string_of_index index);
			flush stdout
		end
	else
		begin
			let passed, failed = run
				(match !name with
					| Some name -> (List.assoc name index)
					| None -> test)
			in
			flush stdout;
			exit (if failed = 0 then 0 else 1)
		end
