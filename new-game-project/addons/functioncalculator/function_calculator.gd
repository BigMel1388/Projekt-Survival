@icon("res://addons/functioncalculator/function_calculator_logo.svg")
## A basic function "library". It is there for you to be able to calculate simple functions that you can use in your games or other software. Tutorial can be found on [i]GitHub[/i].
class_name FunctionCalc
extends Object

static func _is_letter(char): # Code specific function.
	match char:
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z":
			return true
		_:
			return false

## Calculates a given function formula, like
## [codeblock]2*x[/codeblock] ^ (linear function - 2x)
## [br][br]
## or
## [codeblock](x)**2[/codeblock] ^ (quadratic function - x²).
## You input it as a string (which gets parsed).
## [br][br]
## The argument variable, e.g. 'x', is there for the computer to know if the variable is valid or not. So a method usecase like this would be valid:
## [codeblock]calculate_function("2*x", "x", -5, 5)[/codeblock]
## [br]
## But this [b]isn't valid[/b], since 'a' isn't the function argument, but rather 'x' is:
## [codeblock]calculate_function("2*x", "a", -5, 5)[/codeblock]
## [br][br]
## X is not necessarily the function argument, it can also be 'n' (or any other character from the English alphabet):
## [codeblock]calculate_function("2*n", "n", -5, 5)[/codeblock]
## [br][br]
## For the min and max values, so in the examples above, the [code]-5[/code] and [code]5[/code], this is the inclusive (so if you specify, say, -2 and 2, those values, -2 and 2, also get calculated) variable value range that the computer replaces the function argument with.
## So if you had [code]calculate_function("2*x", "x", -2, 2)[/code], this is how the computer calculates the function values:
## [codeblock]
## 2*-2
## 2*-1
## 2*0
## 2*1
## 2*2
## [/codeblock]
## [br]
## I would also highly suggest you mess around with the method, especially with the function formula part, since that's a bit weird, because if you would want to have a proper quadratic equation like [i]f(x)=x²[/i], you would, contrary to most first ideas, have to put in the appropriate formula.
## You might have thought of [code]x**2[/code], but that would calculate negative values (which shouldn't happen in real life math), instead, the correct function formula'd be [code](x)**2[/code], since then, the negative values don't get calculated.
static func calculate_function(formula: String, argument: String, min: int, max: int) -> PackedFloat64Array:
	var values: PackedFloat64Array
	if len(values) != max - min: # If the y values haven't been calculated fully yet, then calculate them using the code block below:
		var calculated_y_values: PackedFloat64Array = []
		var expr = Expression.new()
		for char_idx: int in formula.length():
			if _is_letter(formula[char_idx]) and formula[char_idx] != argument: # If the character is a letter that isn't a known argument, then push an error.
				push_error("A letter (unknown letter: '%c') is in the function formula but not an argument. Please remove it or come up with a different formula!" % formula[char_idx])
			if _is_letter(formula[char_idx]) and formula[char_idx] == argument: # Checks if the character which is looped over is a letter (and is the argument).
				for iterator_arg_val: int in range(min, max + 1):
					var integrated_arg_function_formula: String = formula # Makes a new variable that will contain a calculation that turns a formula like [x*2+1] into [2*2+1] (which will of course calculate multiple versions, like [3*2+1], [4*2+1] and so on to make a graph.)
					integrated_arg_function_formula = integrated_arg_function_formula.erase(char_idx) # Erases the function argument (function variable).
					for arg_len: int in str(iterator_arg_val).length():
						integrated_arg_function_formula = integrated_arg_function_formula.insert(char_idx + arg_len, str(iterator_arg_val)[arg_len]) # Changes the argument in the formula to be the iterator value to calculate each position as best as possible.
						expr.parse(integrated_arg_function_formula)
					values.append(expr.execute()) # Appends the result to the function's y values.
	return values
