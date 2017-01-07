module Compiler::Laravel::Config::Compile

import Syntax::Abstract::PHP;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;

public str createCompileConfig() = 
    toCode(phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "files": array([]),
        "providers": array([])
    )))))]));
