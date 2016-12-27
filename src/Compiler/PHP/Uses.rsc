module Compiler::PHP::Uses

import Compiler::PHP::NewLine;
import Syntax::Abstract::PHP;

public str toCode(phpUse(set[PhpUse] uses), _) = ("" | it + toCode(use) | use <- uses);

public str toCode(phpUse(phpName(str name), phpSomeName(phpName(str as)))) = "<nl()>use <name> as <as>;";
	
public str toCode(phpUse(phpName(str name), phpNoName())) =  "<nl()>use <name>;";
