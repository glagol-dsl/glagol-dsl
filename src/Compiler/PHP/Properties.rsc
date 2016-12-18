module Compiler::PHP::Properties

import Syntax::Abstract::PHP;
import Compiler::PHP::Annotations;
import Compiler::PHP::Modifiers;
import Compiler::PHP::NewLine;
import Compiler::PHP::Indentation;
import Compiler::PHP::Expressions;
import List;

public str toCode(p: phpProperty(set[PhpModifier] modifiers, list[PhpProperty] prop), int i) = 
	"<(p@phpAnnotations?) ? toCode(p@phpAnnotations, i) : ""><nl()>" +
	"<s(i)><toCode(modifiers)><toCode(prop[0])>;<nl()>"
	when size(prop) == 1;

public str toCode(phpProperty(str propertyName, phpNoExpr())) = "$<propertyName>";
public str toCode(phpProperty(str propertyName, phpSomeExpr(PhpExpr expr))) = "$<propertyName> = <toCode(expr)>";
