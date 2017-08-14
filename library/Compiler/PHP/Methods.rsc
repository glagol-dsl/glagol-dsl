module Compiler::PHP::Methods

import Compiler::PHP::Annotations;
import Utils::Indentation;
import Utils::NewLine;
import Compiler::PHP::Modifiers;
import Utils::Glue;
import Compiler::PHP::Params;
import Compiler::PHP::Statements;
import Syntax::Abstract::PHP;

public str toCode(m: phpMethod(_, _, _, _, _, _), int i) = toMethod(m, true, i);

public str toMethod(m: phpMethod(
	str name, 
	set[PhpModifier] modifiers, 
	bool byRef, 
	list[PhpParam] params,
	list[PhpStmt] body,
	PhpOptionName rt), bool hasBody, int i) = 
	"<(m@phpAnnotations?) ? toCode(m@phpAnnotations, i) : ""><nl()>" + 
	"<s(i)><toCode(modifiers)>function <byRef ? "&" : ""><name>(" + 
		glue([toCode(p) | p <- params], ", ") +
	")<returnType(rt)>" + 
	(!hasBody ? ";" :
		"<nl()><s(i)>{<nl()><toCode(body, i + 1)><s(i)>}") +
	nl();

public str returnType(phpNoName()) = "";
public str returnType(phpSomeName(phpName(str name))) = ": <name>";
