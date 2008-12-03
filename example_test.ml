open Test

module Numbers = struct

	let add = Case begin "add",
		"tests that adding one number to\
		 another gives the correct result.",
		fun () ->
			assert_equal (Example.Numbers.add 0 0) 0;
			assert_equal (Example.Numbers.add 1 0) 1;
			assert_equal (Example.Numbers.add 1 1) 2;
	end

	let sub = Case begin "sub",
		"tests that subtracting one number from\
		 another gives the correct result.",
		fun () ->
			assert_equal (Example.Numbers.sub 0 0) 0;
			assert_equal (Example.Numbers.sub 1 0) 1;
			assert_equal (Example.Numbers.sub 1 1) 0;
	end

	let tests = Suite begin "Numbers",
		"tests the Numbers module",
		[add; sub;]
	end

end

module Strings = struct

	let upper = Case begin "upper",
		"tests that strings convert to upper-case correctly.",
		fun () ->
			assert_equal (Example.Strings.upper "string") "STRING";
			assert_equal (Example.Strings.upper "String") "STRING";
			assert_equal (Example.Strings.upper "STRING") "STRING";
	end

	let lower = Case begin "lower",
		"tests that strings convert to lower-case correctly.",
		fun () ->
			assert_equal (Example.Strings.lower "string") "string";
			assert_equal (Example.Strings.lower "String") "string";
			assert_equal (Example.Strings.lower "STRING") "string";
	end

	let tests = Suite begin "Strings",
		"tests the Strings module",
		[upper; lower;]
	end

end

let tests = Suite begin "Example",
	"tests the Example module",
	[
		Numbers.tests;
		Strings.tests;
	]
end

let () = make_command_line_interface tests