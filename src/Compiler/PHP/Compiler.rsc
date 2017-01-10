module Compiler::PHP::Compiler

import Syntax::Abstract::PHP;
import Utils::Indentation;
import Utils::NewLine;
import Utils::Glue;
import Compiler::PHP::Uses;
import Compiler::PHP::Statements;
import List;
import Set;

public str toCode(phpScript(list[PhpStmt] body)) = 
	"\<?php" + nl() + glue([toCode(stmt, 0) | stmt <- body], nl()) + nl();

public str toCode(phpNamespace(phpSomeName(phpName(str name)), list[PhpStmt] body), int i) =
	"namespace <name>;" + nl() +
	("" | it + toCode(stmt, i) | stmt <- body)
	;
