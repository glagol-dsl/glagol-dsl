module Test::Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Statements;

test bool shouldCompileToReturnStmt() =
    toCode(phpReturn(phpSomeExpr(phpVar(phpName(phpName("article"))))), 0) == "\nreturn $article;";

test bool shouldCompileToReturnEmptyStmt() =
    toCode(phpReturn(phpNoExpr()), 0) == "\nreturn;";

test bool shouldCompileListOfStatements() =
    toCode([phpExprstmt(phpScalar(phpBoolean(true))), phpExprstmt(phpScalar(phpBoolean(false)))], 0) ==
    "true;\nfalse;\n";

test bool shouldCompileExpressionStatement() =
    toCode(phpExprstmt(phpScalar(phpBoolean(true))), 1) == "    true;";


