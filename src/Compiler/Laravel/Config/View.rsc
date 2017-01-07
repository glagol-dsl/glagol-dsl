module Compiler::Laravel::Config::View

import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Compiler::PHP::Compiler;

public str createViewConfig() = 
    toCode(phpScript([phpReturn(phpSomeExpr(phpArray([
        phpArrayElement(phpSomeExpr(phpScalar(phpString("paths"))), phpArray([
            phpArrayElement(phpNoExpr(), phpCall("realpath", [
                phpActualParameter(phpCall("base_path", [
                    phpActualParameter(phpScalar(phpString("resources/views")), false)
                ]), false)
            ]), false)
        ]), false),
        phpArrayElement(phpSomeExpr(phpScalar(phpString("compiled"))), phpArray([
            phpArrayElement(phpNoExpr(), phpCall("realpath", [
                phpActualParameter(phpCall("storage_path", [
                    phpActualParameter(phpScalar(phpString("framework/views")), false)
                ]), false)
            ]), false)
        ]), false)
    ])))]));
