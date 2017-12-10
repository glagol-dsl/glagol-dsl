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
import List;

public Code toCode(m: phpMethod(_, _, _, _, _, _), int i) = toMethod(m, true, i);

public Code toMethod(m: phpMethod(
	str name, 
	set[PhpModifier] modifiers, 
	bool byRef, 
	list[PhpParam] params,
	list[PhpStmt] body,
	PhpOptionName rt), bool isInterface, int i) = 
	((m@phpAnnotations?) ? toCode(m@phpAnnotations, i) : code("")) +
	code(nl()) + 
	code(s(i)) +
	toCode(modifiers) +
	code("function <byRef ? "&" : "">", m) + codeEnd(name, rt) + code("(", m) + 
	glue([toCode(p) | p <- params], code(", ")) + 
	code(")") + returnType(rt) + 
	(!isInterface ? codeEnd(";", m) :
		(size(body) > 0 ?
		(code(nl()) + code(s(i)) + code("{") + code(nl()) + toCode(body, i + 1) + code(s(i)) + codeEnd("}", m)) :
		code(" {}"))
	) +
	code(nl());

public Code returnType(phpNoName()) = code("");
public Code returnType(p: phpSomeName(phpName(str name))) = code(":", p) + code(" ") + code("<name>", p);
