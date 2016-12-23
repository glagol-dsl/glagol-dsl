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

test bool shouldCompileBreakStatementWithoutLevel() = 
    toCode(phpBreak(phpNoExpr()), 0) == "break;";

test bool shouldCompileBreakStatementWithLevel() = 
    toCode(phpBreak(phpSomeExpr(phpScalar(phpInteger(1)))), 0) == "break 1;";

test bool shouldCompileContinueStatementWithoutLevel() = 
    toCode(phpContinue(phpNoExpr()), 0) == "continue;";

test bool shouldCompileContinueStatementWithLevel() = 
    toCode(phpContinue(phpSomeExpr(phpScalar(phpInteger(1)))), 0) == "continue 1;";

test bool shouldCompileConstantsDefinition() = 
    toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3))), phpConst("BLAH2", phpScalar(phpFloat(4.23)))]), 0) ==
    "const BLAH = 2.3,\n      BLAH2 = 4.23;";
    
test bool shouldCompileConstantsDefinition() = 
    toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3)))]), 0) ==
    "const BLAH = 2.3;";

test bool shouldCompileConstantsDefinitionAndIndentation() = 
    toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3))), phpConst("BLAH2", phpScalar(phpFloat(4.23)))]), 1) ==
    "    const BLAH = 2.3,\n          BLAH2 = 4.23;";

test bool shouldCompileDeclarationStrictTypes() =
    toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], []), 0) ==
    "declare(strict_types=1);";
    
test bool shouldCompileDeclarationStrictTypesAndTicks() =
    toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1))), phpDeclaration("ticks", phpScalar(phpInteger(2)))], []), 0) ==
    "declare(strict_types=1, ticks=2);";
    
test bool shouldCompileDeclarationStrictTypesWithBody() =
    toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], [
        phpExprstmt(phpScalar(phpBoolean(true)))
    ]), 0) ==
    "declare(strict_types=1) {\n    true;\n}";
