module Test::Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Statements;

test bool shouldCompileToReturnStmt() =
    toCode(phpReturn(phpSomeExpr(phpVar(phpName(phpName("article"))))), 0) == "\nreturn $article;";

test bool shouldCompileToReturnEmptyStmt() =
    toCode(phpReturn(phpSomeExpr(phpVar(phpName(phpName("article"))))), 0) == "\nreturn $article;";

test bool shouldCompileToReturnEmptyStmt() =
    toCode(phpReturn(phpSomeExpr(phpVar(phpName(phpName("article"))))), 0) == "\nreturn $article;";
