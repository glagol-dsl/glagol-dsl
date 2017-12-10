module Test::Compiler::PHP::Traits

import Compiler::PHP::Code;
import Compiler::PHP::Traits;
import Syntax::Abstract::PHP;

test bool shouldCompileTraitUse() = 
    implode(toCode(phpTraitUse([phpName("Example")], []), 0)) == "\nuse Example;\n";
