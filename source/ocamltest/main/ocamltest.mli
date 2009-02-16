(* A unit testing framework for OCaml.                        *)
(* Author: Jonathan Knowles                                   *)
(* Copyright: 2008 Citrix Systems Research & Development Ltd. *)

type test
type name        = string
type description = string
type case        = unit -> unit
type suite       = test list

(** Raised when a failure was expected, but not detected. *)
exception Failure_expected

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

(** Indicates that the current test has failed, with the given message. *)
val fail : string -> unit

(** Indicates that the current test should be skipped, with the given message. *)
val skip : string -> unit

(** Prints a debugging message, followed by a newline character. *)
val print_endline : string -> unit

(** Prints a debugging message. *)
val print_string : string -> unit

(** Makes a test case. *)
val make_test_case : name -> description -> case -> test

(** Makes a test suite. *)
val make_test_suite : name -> description -> suite -> test

(** Makes a module test suite with a default description. *)
val make_module_test_suite : name -> suite -> test

(** Makes the given test accessible from the command-line. *)
val make_command_line_interface : test -> unit