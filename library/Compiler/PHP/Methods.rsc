module Compiler::PHP::Methods

import Compiler::PHP::Code;
import Compiler::PHP::Annotations;
import Utils::Indentation;
import Utils::NewLine;
import Compiler::PHP::Modifiers;
import Utils::Glue;
import Compiler::PHP::Params;
import Compiler::PHP::Statements;
import Syntax::Abstract::PHP;

public Code toCode(m: phpMethod(_, _, _, _, _, _), int i) = toMethod(m, true, i);

public Code toMethod(m: phpMethod(
	str name, 
	set[PhpModifier] modifiers, 
	bool byRef, 
	list[PhpParam] params,
	list[PhpStmt] body,
	PhpOptionName rt), bool hasBody, int i) = 
	((m@phpAnnotations?) ? toCode(m@phpAnnotations, i) : code("")) +
	code(nl(), m) + 
	code(s(i)) +
	toCode(modifiers) +
	code("function <byRef ? "&" : ""><name>(", m) + 
	glue([toCode(p) | p <- params], code(", ", m)) + 
	code(")", m) + returnType(rt) + 
	(!hasBody ? code(";", m) :
		(code(nl()) + code("<s(i)>{") + code(nl()) + toCode(body, i + 1) + code("<s(i)>}"))) +
	code(nl());

public Code returnType(phpNoName()) = code("");
public Code returnType(p: phpSomeName(phpName(str name))) = code(": <name>", p);
