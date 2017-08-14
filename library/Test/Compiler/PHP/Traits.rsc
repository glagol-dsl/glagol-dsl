module Test::Compiler::PHP::Traits

import Compiler::PHP::Traits;
import Syntax::Abstract::PHP;

test bool shouldCompileTraitUse() = 
    toCode(phpTraitUse([phpName("Example")], []), 0) == "\nuse Example;\n";
