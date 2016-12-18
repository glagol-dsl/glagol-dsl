module Compiler::PHP::Compiler

import Syntax::Abstract::PHP;
import Compiler::PHP::Indentation;
import Compiler::PHP::NewLine;
import Compiler::PHP::Uses;
import Compiler::PHP::Classes;
import List;
import Set;

public str toCode(phpScript(list[PhpStmt] body)) = 
	"\<?php" + nl() + ("" | it + toCode(stmt, 0) | stmt <- body) + nl();

public str toCode(phpNamespace(phpSomeName(phpName(str name)), list[PhpStmt] body), int i) =
	"namespace <name>;" + nl() +
	("" | it + toCode(stmt, i) | stmt <- body)
	;
