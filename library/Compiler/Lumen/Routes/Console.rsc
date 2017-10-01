module Compiler::Lumen::Routes::Console

import Compiler::PHP::Compiler;
import Compiler::PHP::Code;
import Syntax::Abstract::PHP;

public str createRoutesConsole() =
    implode(toCode(phpScript([phpReturn(phpSomeExpr(
        phpArray([])
    ))])));

