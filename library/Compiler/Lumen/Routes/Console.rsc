module Compiler::Lumen::Routes::Console

import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

public str createRoutesConsole() =
    toCode(phpScript([phpReturn(phpSomeExpr(
        phpArray([])
    ))]));

