module Test::Compiler::Laravel::Routes::Console

import Compiler::Laravel::Routes::Console;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;

test bool shouldCreateLaravelConsoleRoutes() =
    createRoutesConsole() ==
    toCode(phpScript([phpReturn(phpSomeExpr(
        phpArray([])
    ))]));

