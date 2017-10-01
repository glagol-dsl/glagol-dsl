module Test::Compiler::PHP::Compiler

import Compiler::PHP::Code;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

test bool shouldCompileEmptyScript() = implode(toCode(phpScript([]))) == "\<?php\n\n";

test bool shouldCompileNamespace() = 
	implode(toCode(phpNamespace(phpSomeName(phpName("Example")), []), 0)) == 
	"namespace Example;\n";
