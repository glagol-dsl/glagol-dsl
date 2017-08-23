module Test::Compiler::Lumen::Server

import Compiler::Lumen::Server;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;

test bool shouldCreateLumenServerFile() =
    createServerFile() == toCode(phpScript([
        phpExprstmt(phpAssign(phpVar("uri"), phpCall(
            "urldecode", [
                phpActualParameter(phpCall("parse_url", [
                    phpActualParameter(phpFetchArrayDim(phpVar("_SERVER"), phpSomeExpr(phpScalar(phpString("REQUEST_URI")))), false),
                    phpActualParameter(phpFetchConst(phpName("PHP_URL_PATH")), false)
                ]), false)
            ]
        ))),
        phpIf(phpBinaryOperation(
            phpBinaryOperation(phpVar("uri"), phpScalar(phpString("/")), phpNotIdentical()),
            phpCall("file_exists", [phpActualParameter(phpBinaryOperation(
                phpScalar(phpDirConstant()),
                phpBinaryOperation(phpScalar(phpString("/public")), phpVar("uri"), phpConcat()),
                phpConcat()
            ), false)]),
            phpLogicalAnd()
        ), [], [], phpNoElse()),
        phpExprstmt(phpInclude(phpBinaryOperation(
            phpScalar(phpDirConstant()), 
            phpScalar(phpString("/public/index.php")), 
            phpConcat()), phpRequireOnce()
        ))
    ]));
