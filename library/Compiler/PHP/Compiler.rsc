module Compiler::PHP::Compiler

import Syntax::Abstract::PHP;
import Utils::Indentation;
import Utils::NewLine;
import Utils::Glue;
import Compiler::PHP::Uses;
import Compiler::PHP::Statements;
import Compiler::PHP::Code;
import List;
import Set;

public Code toCode(p: phpScript(list[PhpStmt] body)) = 
	code("\<?php", p) + code(nl()) + glue([toCode(stmt, 0) | stmt <- body], code(nl())) + code(nl());
// TODO add source map comment at the end

public Code toCode(p: phpNamespace(phpSomeName(phpName(str name)), list[PhpStmt] body), int i) =
	code("namespace <name>;", p) + code(nl()) + (code() | it + toCode(stmt, i) | stmt <- body);
