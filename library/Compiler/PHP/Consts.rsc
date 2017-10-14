module Compiler::PHP::Consts

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::Annotations;
import Compiler::PHP::Modifiers;
import Utils::NewLine;
import Utils::Indentation;
import Compiler::PHP::Expressions;
import List;

public Code toCode(p: phpConstCI(list[PhpConst] consts), int i) = (code() | it + toCode(c, i) | c <- consts);
public Code toCode(p: phpConst(str name, PhpExpr constValue), int i) = 
	code(nl()) + 
	code(s(i)) +
	code("const <name> = ", p) + 
	toCode(constValue, i) + codeEnd(";", p) + 
	code(nl());

