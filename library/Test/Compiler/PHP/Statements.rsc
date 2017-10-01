module Test::Compiler::PHP::Statements

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::Statements;

test bool shouldCompileToReturnStmt() =
    implode(toCode(phpReturn(phpSomeExpr(phpVar(phpName(phpName("article"))))), 0)) == "return $article;";

test bool shouldCompileToReturnEmptyStmt() =
    implode(toCode(phpReturn(phpNoExpr()), 0)) == "return;";

test bool shouldCompileListOfStatements() =
    implode(toCode([phpExprstmt(phpScalar(phpBoolean(true))), phpExprstmt(phpScalar(phpBoolean(false)))], 0)) ==
    "true;\nfalse;\n";

test bool shouldCompileExpressionStatement() =
    implode(toCode(phpExprstmt(phpScalar(phpBoolean(true))), 1)) == "    true;";

test bool shouldCompileBreakStatementWithoutLevel() = 
    implode(toCode(phpBreak(phpNoExpr()), 0)) == "break;";

test bool shouldCompileBreakStatementWithLevel() = 
    implode(toCode(phpBreak(phpSomeExpr(phpScalar(phpInteger(1)))), 0)) == "break 1;";

test bool shouldCompileContinueStatementWithoutLevel() = 
    implode(toCode(phpContinue(phpNoExpr()), 0)) == "continue;";

test bool shouldCompileContinueStatementWithLevel() = 
    implode(toCode(phpContinue(phpSomeExpr(phpScalar(phpInteger(1)))), 0)) == "continue 1;";

test bool shouldCompileTwoConstantsDefinition() = 
    implode(toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3))), phpConst("BLAH2", phpScalar(phpFloat(4.23)))]), 0)) ==
    "const BLAH = 2.3,\n      BLAH2 = 4.23;";
    
test bool shouldCompileOneConstantsDefinition() = 
    implode(toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3)))]), 0)) ==
    "const BLAH = 2.3;";

test bool shouldCompileConstantsDefinitionAndIndentation() = 
    implode(toCode(phpConst([phpConst("BLAH", phpScalar(phpFloat(2.3))), phpConst("BLAH2", phpScalar(phpFloat(4.23)))]), 1)) ==
    "    const BLAH = 2.3,\n          BLAH2 = 4.23;";

test bool shouldCompileDeclarationStrictTypes() =
    implode(toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], []), 0)) ==
    "declare(strict_types=1);\n";
    
test bool shouldCompileDeclarationStrictTypesAndTicks() =
    implode(toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1))), phpDeclaration("ticks", phpScalar(phpInteger(2)))], []), 0)) ==
    "declare(strict_types=1, ticks=2);\n";
    
test bool shouldCompileDeclarationStrictTypesWithBody() =
    implode(toCode(phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], [
        phpExprstmt(phpScalar(phpBoolean(true)))
    ]), 0)) ==
    "declare(strict_types=1) {\n    true;\n}";

test bool shouldCompileDo() = 
	implode(toCode(phpDo(phpScalar(phpInteger(1)), [phpExprstmt(phpScalar(phpBoolean(true)))]), 0)) == "do {\n    true;\n} while (1);";

test bool shouldCompileDoWithIndentation() = 
	implode(toCode(phpDo(phpScalar(phpInteger(1)), [phpExprstmt(phpScalar(phpBoolean(true)))]), 1)) == "    do {\n        true;\n    } while (1);";

test bool shouldCompileEchoWithOneExpr() = implode(toCode(phpEcho([phpScalar(phpString("Hello world!"))]), 0)) == "echo \"Hello world!\";";

test bool shouldCompileEchoWithTwoExprs() = 
	implode(toCode(phpEcho([phpScalar(phpString("Hello world!")), phpScalar(phpInteger(123))]), 0)) == "echo (\"Hello world!\", 123);";

test bool shouldCompileFor() = 
	implode(toCode(phpFor(
		[phpAssign(phpVar(phpName(phpName("i"))), phpScalar(phpInteger(0)))], 
		[phpBinaryOperation(phpVar(phpName(phpName("i"))), phpScalar(phpInteger(10)), phpLt())], 
		[phpUnaryOperation(phpVar(phpName(phpName("i"))), phpPostInc())], 
		[phpEcho([phpVar(phpName(phpName("i"))), phpScalar(phpString("\\n"))])]), 0)) ==
	"for ($i = 0; $i \< 10; $i++) {\n    echo ($i, \"\\n\");\n}";

test bool shouldCompileForeachWithoutKeyVarNotByRef() =
	implode(toCode(phpForeach(phpVar(phpName(phpName("list"))), phpNoExpr(), false, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0)) == "foreach ($list as $val) {\n    echo ($val, \"\\n\");\n}";

test bool shouldCompileForeachWithKeyVarNotByRef() =
	implode(toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), false, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0)) == "foreach ($list as $k =\> $val) {\n    echo ($val, \"\\n\");\n}";

test bool shouldCompileForeachWithKeyVarWithByRef() =
	implode(toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), true, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 0)) == "foreach ($list as $k =\> &$val) {\n    echo ($val, \"\\n\");\n}";

test bool shouldCompileForeachIndented() =
	implode(toCode(phpForeach(phpVar(phpName(phpName("list"))), phpSomeExpr(phpVar(phpName(phpName("k")))), true, phpVar(phpName(phpName("val"))), [
		phpEcho([phpVar(phpName(phpName("val"))), phpScalar(phpString("\\n"))])
	]), 1)) == "    foreach ($list as $k =\> &$val) {\n        echo ($val, \"\\n\");\n    }";

test bool shouldCompileFunctionNoParamsNoRefNoReturnType() = 
	implode(toCode(phpFunction("test", false, [], [phpReturn(phpNoExpr())], phpNoName()), 0)) == 
	"function test()\n{\n    return;\n}";

test bool shouldCompileFunctionWithParamsNoRefNoReturnType() = 
	implode(toCode(phpFunction("test", false, [
		phpParam("var1", phpNoExpr(), phpNoName(), false, false),
		phpParam("var2", phpNoExpr(), phpNoName(), false, false)
	], [phpReturn(phpNoExpr())], phpNoName()), 0)) == 
	"function test($var1, $var2)\n{\n    return;\n}";

test bool shouldCompileFunctionNoParamsWithRefNoReturnType() = 
	implode(toCode(phpFunction("test", true, [], [phpReturn(phpNoExpr())], phpNoName()), 0)) == 
	"function &test()\n{\n    return;\n}";

test bool shouldCompileFunctionNoParamsNoRefWithReturnType() = 
	implode(toCode(phpFunction("test", false, [], [phpReturn(phpNoExpr())], phpSomeName(phpName("void"))), 0)) == 
	"function test(): void\n{\n    return;\n}";

test bool shouldCompileGlobal() = 
	implode(toCode(phpGlobal([phpVar(phpName(phpName("var1")))]), 0)) == "global $var1;";

test bool shouldCompileGoto() = implode(toCode(phpGoto("my_label"), 0)) == "goto my_label;";

test bool shouldCompileGotoLabel() = implode(toCode(phpLabel("my_label"), 0)) == "my_label:";

test bool shouldCompileHaltCompiler() =
	implode(toCode(phpHaltCompiler("\<?php\\nblah"), 0)) == "__halt_compiler();\<?php\\nblah";

test bool shouldCompileIfWithOnlyBody() = 
	implode(toCode(phpIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hello world!"))])], [], phpNoElse()), 0)) ==
	"if (true) {\n    echo \"Hello world!\";\n}";

test bool shouldCompileIfWithElseIf() = 
	implode(toCode(phpIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hello world!"))])], [
		phpElseIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hi"))])])
	], phpNoElse()), 0)) ==
	"if (true) {\n    echo \"Hello world!\";\n} elseif (true) {\n    echo \"Hi\";\n}";

test bool shouldCompileIfWithElseIfs() = 
	implode(toCode(phpIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hello world!"))])], [
		phpElseIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hi"))])]),
		phpElseIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hi2"))])])
	], phpNoElse()), 0)) ==
	"if (true) {\n    echo \"Hello world!\";\n} elseif (true) {\n    echo \"Hi\";\n} elseif (true) {\n    echo \"Hi2\";\n}";

test bool shouldCompileIfWithElse() = 
	implode(toCode(phpIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hello world!"))])], [], phpSomeElse(
		phpElse([phpEcho([phpScalar(phpString("Hi2"))])])
	)), 0)) ==
	"if (true) {\n    echo \"Hello world!\";\n} else {\n    echo \"Hi2\";\n}";

test bool shouldCompileIfWithElseIfsAndWlse() = 
	implode(toCode(phpIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hello world!"))])], [
		phpElseIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hi"))])]),
		phpElseIf(phpScalar(phpBoolean(true)), [phpEcho([phpScalar(phpString("Hi2"))])])
	], phpSomeElse(
		phpElse([phpEcho([phpScalar(phpString("Hi3"))])])
	)), 0)) ==
	"if (true) {\n    echo \"Hello world!\";\n} elseif (true) {\n    echo \"Hi\";\n} elseif (true) {\n    echo \"Hi2\";\n} " +
	"else {\n    echo \"Hi3\";\n}";

test bool shouldCompileInterfaceDef() = 
	implode(toCode(phpInterfaceDef(phpInterface("IUserCreator", [], [])), 0)) == "\ninterface IUserCreator\n{}";

test bool shouldCompileInterfaceDefWithExtending() = 
	implode(toCode(phpInterfaceDef(phpInterface("IUserCreator", [phpName("ICreator"), phpName("IService")], [])), 0)) == 
	"\ninterface IUserCreator extends ICreator, IService\n{}";

test bool shouldCompileInterfaceDefWithPublicMethods() = 
	implode(toCode(phpInterfaceDef(phpInterface("IUserCreator", [], [
		phpMethod("test", {phpPublic()}, false, [], [], phpNoName())
	])), 0)) == 
	"\ninterface IUserCreator\n{\n" + 
	"    public function test();\n" +
	"}";

test bool shouldCompileEmptyTrait() = 
	implode(toCode(phpTraitDef(phpTrait("Math", [])), 0)) == "\ntrait Math\n{}";

test bool shouldCompileWithMembers() = 
	implode(toCode(phpTraitDef(phpTrait("Math", [
		phpMethod("test", {phpPublic()}, false, [], [], phpNoName())
	])), 0)) == 
	"\ntrait Math\n{\n    public function test()\n    {\n    }\n}";

test bool shouldCompileStaticVars() =
	implode(toCode(phpStatic([phpStaticVar("var1", phpNoExpr()), phpStaticVar("var2", phpSomeExpr(phpScalar(phpInteger(2))))]), 0)) ==
	"static $var1,\n       $var2 = 2;";

test bool shouldCompileSwitch() =
	implode(toCode(phpSwitch(phpVar(phpName(phpName("var"))), [
		phpCase(phpSomeExpr(phpScalar(phpInteger(1))), [phpEcho([phpScalar(phpInteger(1))])]),
		phpCase(phpSomeExpr(phpScalar(phpInteger(2))), []),
		phpCase(phpNoExpr(), [phpEcho([phpScalar(phpInteger(3))])])
	]), 0)) ==
	"switch ($var) {\n    case 1:\n        echo 1;\n    case 2:\n    default:\n        echo 3;\n}";

test bool shouldCompileThrow() =
	implode(toCode(phpThrow(phpNew(phpName(phpName("Exception")), [])), 0)) == "throw new Exception();";

test bool shouldCompileTryCatch() =	
	implode(toCode(phpTryCatch([phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("blah")), []))], [
		phpCatch(phpName("Exception"), "e", [phpEcho([phpScalar(phpString("error"))])])
	]), 0)) ==
	"try {\n    $this-\>blah();\n} catch (Exception $e) {\n    echo \"error\";\n}";

test bool shouldCompileTryCatchFinally() =	
	implode(toCode(phpTryCatchFinally([phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("blah")), []))], [
		phpCatch(phpName("Exception"), "e", [phpEcho([phpScalar(phpString("error"))])])
	], [phpEcho([phpScalar(phpString("error2"))])]), 0)) ==
	"try {\n    $this-\>blah();\n} catch (Exception $e) {\n    echo \"error\";\n} finally {\n    echo \"error2\";\n}";

test bool shouldCompileUnsetVar() =
	implode(toCode(phpUnset([phpVar(phpName(phpName("var1")))]), 0)) ==
	"unset($var1);";
	
test bool shouldCompileUnsetVars() =
	implode(toCode(phpUnset([phpVar(phpName(phpName("var1"))), phpVar(phpName(phpName("var2")))]), 0)) ==
	"unset($var1, $var2);";

test bool shouldCompileWhile() =
	implode(toCode(phpWhile(phpScalar(phpBoolean(true)), [phpExprstmt(phpUnaryOperation(phpVar(phpName(phpName("i"))), phpPostInc()))]), 0)) ==
	"while (true) {\n    $i++;\n}";
	
test bool shouldCompileEmptyStmt() = implode(toCode(phpEmptyStmt(), 0)) == ";";

test bool shouldCompileBlock() = 
	implode(toCode(phpBlock([phpEcho([phpScalar(phpString("blah"))])]), 0)) == "{\n    echo \"blah\";\n}";

test bool shouldCompileBasicClass() =
	implode(toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [], [])), 0)) ==
	"\nclass Test \n{}";
	
test bool shouldCompileClassWithModifiers() =
	implode(toCode(phpClassDef(phpClass("Test", {phpAbstract()}, phpNoName(), [], [])), 0)) ==
	"\nabstract class Test \n{}";
	
test bool shouldCompileClassExtend() =
	implode(toCode(phpClassDef(phpClass("Luke", {}, phpSomeName(phpName("DarthVader")), [], [])), 0)) ==
	"\nclass Luke extends DarthVader \n{}";
	
test bool shouldCompileClassWithOneImplementation() =
	implode(toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [phpName("ArrayAccess")], [])), 0)) ==
	"\nclass Test implements ArrayAccess \n{}";
	
test bool shouldCompileClassWithTwoImplementation() =
	implode(toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [phpName("ArrayAccess"), phpName("Iterator")], [])), 0)) ==
	"\nclass Test implements ArrayAccess, Iterator \n{}";
	
test bool shouldCompileClassWithMembers() =
	implode(toCode(phpClassDef(phpClass("Test", {}, phpNoName(), [], [phpProperty({phpPrivate()}, [
		phpProperty("id", phpNoExpr())
	])[@phpAnnotations={phpAnnotation("var", phpAnnotationVal("integer"))}]])), 0)) ==
	"\nclass Test \n{\n    /**\n     * @var integer\n     */\n    private $id;\n}";

test bool shouldCompileNewLine() = implode(toCode(phpNewLine(), 0)) == "";

