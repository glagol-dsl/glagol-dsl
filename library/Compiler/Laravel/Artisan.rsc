module Compiler::Laravel::Artisan

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createArtisan() =
    "#!/usr/bin/env php\n" +
    toCode(phpScript([
        phpExprstmt(phpInclude(phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/bootstrap/autoload.php")), phpConcat()), phpRequire())),
        phpExprstmt(phpAssign(phpVar("app"), phpInclude(
            phpBinaryOperation(phpScalar(phpDirConstant()), phpScalar(phpString("/bootstrap/app.php")), phpConcat()), 
            phpRequireOnce()))
        ),
        phpExprstmt(phpAssign(phpVar("kernel"), phpMethodCall(phpVar("app"), phpName(phpName("make")), [
                phpActualParameter(phpFetchClassConst(phpName(phpName("Illuminate\\Contracts\\Console\\Kernel")), "class"), false)
            ]))
        ),
        phpExprstmt(phpAssign(phpVar("status"), phpMethodCall(phpVar("kernel"), phpName(phpName("handle")), [
                phpActualParameter(phpAssign(phpVar("input"), 
                    phpNew("Symfony\\Component\\Console\\Input\\ArgvInput", [])
                ), false),
                phpActualParameter(phpNew("Symfony\\Component\\Console\\Output\\ConsoleOutput", []), false)
            ]))
        ),
        phpExprstmt(phpMethodCall(phpVar("kernel"), phpName(phpName("terminate")), [
            phpActualParameter(phpVar("input"), false),
            phpActualParameter(phpVar("status"), false)
        ])),
        phpExprstmt(phpExit(phpSomeExpr(phpVar("status"))))
    ]));
