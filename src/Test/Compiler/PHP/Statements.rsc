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

test bool shouldCompileDo() = 
	toCode(phpDo(phpScalar(phpInteger(1)), [phpExprstmt(phpScalar(phpBoolean(true)))]), 0) == "do {\n    true;\n} while (1);";

test bool shouldCompileDoWithIndentation() = 
	toCode(phpDo(phpScalar(phpInteger(1)), [phpExprstmt(phpScalar(phpBoolean(true)))]), 1) == "    do {\n        true;\n    } while (1);";

test bool shouldCompileEchoWithOneExpr() = toCode(phpEcho([phpScalar(phpString("Hello world!"))]), 0) == "echo \"Hello world!\";";

test bool shouldCompileEchoWithTwoExprs() = 
	toCode(phpEcho([phpScalar(phpString("Hello world!")), phpScalar(phpInteger(123))]), 0) == "echo \"Hello world!\", 123;";

test bool shouldCompileFor() = 
	toCode(phpFor(
		[phpAssign(phpVar(phpName(phpName("i"))), phpScalar(phpInteger(0)))], 
		[phpBinaryOperation(phpVar(phpName(phpName("i"))), phpScalar(phpInteger(10)), phpLt())], 
		[phpUnaryOperation(phpVar(phpName(phpName("i"))), phpPostInc())], 
		[phpEcho([phpVar(phpName(phpName("i"))), phpScalar(phpString("\\n"))])]), 0) ==
	"for ($i = 0; $i \< 10; $i++) {\n    echo $i, \"\\n\";\n}";

test bool shouldCompileForeachWithoutKeyVarNotByRef() =
	toCode(phpForeach(phpVar(phpName(phpName("list"))), phpNoExpr(), false, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0) == "foreach ($list as $val) {\n    echo $val, \"\\n\";\n}";

test bool shouldCompileForeachWithKeyVarNotByRef() =
	toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), false, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0) == "foreach ($list as $k =\> $val) {\n    echo $val, \"\\n\";\n}";

test bool shouldCompileForeachWithKeyVarWithByRef() =
	toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), true, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0) == "foreach ($list as $k =\> &$val) {\n    echo $val, \"\\n\";\n}";

test bool shouldCompileForeachIndented() =
	toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), true, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 1) == "    foreach ($list as $k =\> &$val) {\n        echo $val, \"\\n\";\n    }";

test bool shouldCompileFunctionNoParamsNoRefNoReturnType() = 
	toCode(phpFunction("test", false, [], [phpReturn(phpNoExpr())], phpNoName()), 0) == 
	"function test()\n{\n\n    return;\n}";

test bool shouldCompileFunctionWithParamsNoRefNoReturnType() = 
	toCode(phpFunction("test", false, [
		phpParam("var1", phpNoExpr(), phpNoName(), false, false),
		phpParam("var2", phpNoExpr(), phpNoName(), false, false)
	], [phpReturn(phpNoExpr())], phpNoName()), 0) == 
	"function test($var1, $var2)\n{\n\n    return;\n}";

test bool shouldCompileFunctionNoParamsWithRefNoReturnType() = 
	toCode(phpFunction("test", true, [], [phpReturn(phpNoExpr())], phpNoName()), 0) == 
	"function &test()\n{\n\n    return;\n}";

test bool shouldCompileFunctionNoParamsNoRefWithReturnType() = 
	toCode(phpFunction("test", false, [], [phpReturn(phpNoExpr())], phpSomeName(phpName("void"))), 0) == 
	"function test(): void\n{\n\n    return;\n}";
