module Test::Compiler::Laravel::Config::Compile

import Compiler::Laravel::Config::Compile;
import Syntax::Abstract::PHP;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;

test bool shouldCreateLaravelCompileConfig() = 
    createCompileConfig() == toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "files": array([]),
        "providers": array([])
    )))))]));
