module Test::Compiler::Lumen::Routes::Console

import Compiler::Lumen::Routes::Console;
import Compiler::PHP::Code;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

test bool shouldCreateLumenConsoleRoutes() =
    createRoutesConsole() ==
    implode(toCode(phpScript([phpReturn(phpSomeExpr(
        phpArray([])
    ))])));

