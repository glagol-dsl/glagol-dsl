module Compiler::PHP::Consts

import Syntax::Abstract::PHP;
import Compiler::PHP::Annotations;
import Compiler::PHP::Modifiers;
import Utils::NewLine;
import Utils::Indentation;
import Compiler::PHP::Expressions;
import List;

public str toCode(phpConstCI(list[PhpConst] consts), int i) = ("" | it + toCode(c, i) | c <- consts);
public str toCode(phpConst(str name, PhpExpr constValue), int i) = "<nl()><s(i)>const <name> = <toCode(constValue, i)>;<nl()>";

