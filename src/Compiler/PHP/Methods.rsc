module Compiler::PHP::Methods

import Compiler::PHP::Indentation;
import Compiler::PHP::NewLine;
import Compiler::PHP::Modifiers;
import Compiler::PHP::Glue;
import Compiler::PHP::Params;
import Compiler::PHP::Statements;
import Syntax::Abstract::PHP;

public str toCode(m: phpMethod(
	str name, 
	set[PhpModifier] modifiers, 
	bool byRef, 
	list[PhpParam] params,
	list[PhpStmt] body,
	PhpOptionName rt), int i) = 
	nl() + "<s(i)><toCode(modifiers)>function <byRef ? "&" : ""><name>(" + 
		glue([toCode(p) | p <- params], ", ") +
	")<returnType(rt)>\n<s(i)>{\n<toCode(body, i + 1)><s(i)>}<nl()>";

public str returnType(phpNoName()) = "";
public str returnType(phpSomeName(phpName(str name))) = ": <name>";
