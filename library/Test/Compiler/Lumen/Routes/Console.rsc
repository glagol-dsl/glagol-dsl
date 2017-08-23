module Test::Compiler::Lumen::Routes::Console

import Compiler::Lumen::Routes::Console;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

test bool shouldCreateLumenConsoleRoutes() =
    createRoutesConsole() ==
    toCode(phpScript([phpReturn(phpSomeExpr(
        phpArray([])
    ))]));

