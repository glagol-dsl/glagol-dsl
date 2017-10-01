module Compiler::PHP::Properties

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::Annotations;
import Compiler::PHP::Modifiers;
import Utils::NewLine;
import Utils::Indentation;
import Compiler::PHP::Expressions;
import List;

public Code toCode(p: phpProperty(set[PhpModifier] modifiers, list[PhpProperty] prop), int i) = 
	((p@phpAnnotations?) ? toCode(p@phpAnnotations, i) : code("")) + 
	code(nl()) + 
	code(s(i)) +
	toCode(modifiers) +
	toCode(prop[0]) + 
	code(";", p) +
	code(nl())
	when size(prop) == 1;

public Code toCode(p: phpProperty(str propertyName, phpNoExpr())) = code("$<propertyName>", p);
public Code toCode(p: phpProperty(str propertyName, phpSomeExpr(PhpExpr expr))) = code("$<propertyName>", p) + code(" = ", p) + toCode(expr, 0);
