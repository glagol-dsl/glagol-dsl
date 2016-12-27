module Test::Compiler::PHP::Compiler

import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

test bool shouldCompileEmptyScript() = toCode(phpScript([])) == "\<?php\n\n";

test bool shouldCompileNamespace() = 
	toCode(phpNamespace(phpSomeName(phpName("Example")), []), 0) == 
	"namespace Example;\n";
