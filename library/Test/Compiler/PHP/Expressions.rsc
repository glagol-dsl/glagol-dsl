module Test::Compiler::PHP::Expressions

import Compiler::PHP::Code;
import Compiler::PHP::Expressions;
import Syntax::Abstract::PHP;

test bool shouldCompileScalarClassConstant() = implode(toCode(phpScalar(phpClassConstant()), 0)) == "__CLASS__";
test bool shouldCompileScalarDirConstant() = implode(toCode(phpScalar(phpDirConstant()), 0)) == "__DIR__";
test bool shouldCompileScalarFileConstant() = implode(toCode(phpScalar(phpFileConstant()), 0)) == "__FILE__";
test bool shouldCompileScalarFuncConstant() = implode(toCode(phpScalar(phpFuncConstant()), 0)) == "__FUNCTION__";
test bool shouldCompileScalarLineConstant() = implode(toCode(phpScalar(phpLineConstant()), 0)) == "__LINE__";
test bool shouldCompileScalarMethodConstant() = implode(toCode(phpScalar(phpMethodConstant()), 0)) == "__METHOD__";
test bool shouldCompileScalarNamespaceConstant() = implode(toCode(phpScalar(phpNamespaceConstant()), 0)) == "__NAMESPACE__";
test bool shouldCompileScalarTraitConstant() = implode(toCode(phpScalar(phpTraitConstant()), 0)) == "__TRAIT__";
test bool shouldCompileScalarNull() = implode(toCode(phpScalar(phpNull()), 0)) == "null";
test bool shouldCompileScalarFloat() = implode(toCode(phpScalar(phpFloat(1.88)), 0)) == "1.88";
test bool shouldCompileScalarInteger() = implode(toCode(phpScalar(phpInteger(323)), 0)) == "323";
test bool shouldCompileScalarString() = implode(toCode(phpScalar(phpString("haha")), 0)) == "\"haha\"";
test bool shouldCompileScalarBooleanTrue() = implode(toCode(phpScalar(phpBoolean(true)), 0)) == "true";
test bool shouldCompileScalarBooleanFalse() = implode(toCode(phpScalar(phpBoolean(false)), 0)) == "false";
test bool shouldCompileScalarEncapsedStringPart() = implode(toCode(phpScalar(phpEncapsedStringPart("blah")), 0)) == "blah";

test bool shouldCompileScalarEncapsed() = 
    implode(toCode(phpScalar(phpEncapsed([phpScalar(phpEncapsedStringPart("blah")), phpVar(phpName(phpName("var")))])), 0)) == "blah$var";
    
test bool shouldCompileNoExpr() = implode(toCode(phpNoExpr(), 0)) == "";
test bool shouldCompileVarExpr() = implode(toCode(phpVar(phpName(phpName("var"))), 0)) == "$var";
test bool shouldCompileVarVarExpr() = implode(toCode(phpVar(phpExpr(phpVar(phpName(phpName("var"))))), 0)) == "$$var";
test bool shouldCompileCastType() = implode(toCode(phpCast(phpInt(), phpVar(phpName(phpName("var")))), 0)) == "(int) $var";
test bool shouldCompileClone() = implode(toCode(phpClone(phpVar(phpName(phpName("var")))), 0)) == "clone $var";
test bool shouldCompileFetchConst() = implode(toCode(phpFetchConst(phpName("BLAH")), 0)) == "BLAH";
test bool shouldCompileEmpty() = implode(toCode(phpEmpty(phpVar(phpName(phpName("var")))), 0)) == "empty($var)";
test bool shouldCompileSuppress() = implode(toCode(phpSuppress(phpEmpty(phpVar(phpName(phpName("var"))))), 0)) == "@empty($var)";
test bool shouldCompileEval() = implode(toCode(phpEval(phpScalar(phpString("code"))), 0)) == "eval(\"code\")";
test bool shouldCompileExit() = implode(toCode(phpExit(phpNoExpr()), 0)) == "exit";
test bool shouldCompileExitWithParam() = implode(toCode(phpExit(phpSomeExpr(phpVar(phpName(phpName("var"))))), 0)) == "exit($var)";
test bool shouldCompileInclude() = implode(toCode(phpInclude(phpScalar(phpString("test.php")), phpInclude()), 0)) == "include \"test.php\"";
test bool shouldCompileBrackets() = implode(toCode(phpBracket(phpSomeExpr(phpScalar(phpBoolean(true)))), 0)) == "(true)";

test bool shouldCompileDestructorList() = 
    implode(toCode(phpListExpr([phpSomeExpr(phpVar(phpName(phpName("var1")))), phpSomeExpr(phpVar(phpName(phpName("var2"))))]), 0)) == "[$var1, $var2]"; 

test bool shouldCompileYieldWithValueOnly() = 
    implode(toCode(phpYield(phpNoExpr(), phpSomeExpr(phpScalar(phpInteger(1)))), 0)) == "yield 1";
    
test bool shouldCompileYieldWithKeyAndValue() = 
    implode(toCode(phpYield(phpSomeExpr(phpScalar(phpString("myKey"))), phpSomeExpr(phpScalar(phpInteger(1)))), 0)) == "yield \"myKey\" =\> 1";

test bool shouldCompileYieldWithoutValue() = 
    implode(toCode(phpYield(phpNoExpr(), phpNoExpr()), 0)) == "yield";

test bool shouldCompileStaticPropertyFetch() = 
    implode(toCode(phpStaticPropertyFetch(phpName(phpName("MyClass")), phpName(phpName("prop"))), 0)) == "MyClass::$prop";

test bool shouldCompileTernaryWithIfAndElseIf() = 
    implode(toCode(phpTernary(phpScalar(phpBoolean(true)), phpSomeExpr(phpScalar(phpInteger(1))), phpScalar(phpInteger(4))), 0)) ==
    "true ? 1 : 4";

test bool shouldCompileTernaryWithElseIfOnly() = 
    implode(toCode(phpTernary(phpScalar(phpBoolean(true)), phpNoExpr(), phpScalar(phpInteger(4))), 0)) ==
    "true ?: 4";

test bool shouldCompileInstanceOf() = 
    implode(toCode(phpInstanceOf(phpVar(phpName(phpName("object"))), phpName(phpName("MyClass"))), 0)) == "$object instanceof MyClass";

test bool shouldCompileIsset() =
    implode(toCode(phpIsSet([phpVar(phpName(phpName("var1"))), phpVar(phpName(phpName("var2")))]), 0)) == "isset($var1, $var2)";

test bool shouldCompilePrint() = implode(toCode(phpPrint(phpScalar(phpString("Hey"))), 0)) == "print \"Hey\"";

test bool shouldCompileShellExec() = 
    implode(toCode(phpShellExec([phpScalar(phpEncapsedStringPart("hello --")), phpVar(phpName(phpName("command")))]), 0)) == "`hello --$command`";

test bool shouldCompilePropertyFetch() = 
    implode(toCode(phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("field"))), 0)) == "$this-\>field";

test bool shouldCompileFuncCall() = implode(toCode(phpCall(phpName(phpName("test")), []), 0)) == "test()";

test bool shouldCompileFuncCallWithParams() = implode(toCode(phpCall(
	phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0)) == 
	"test(3)";

test bool shouldCompileMethodCall() = 
    implode(toCode(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("test")), []), 0)) == "$this-\>\n    test()";
    
test bool shouldCompileMethodCallWithParams() = 
    implode(toCode(phpMethodCall(phpVar(phpName(phpName("this"))),
        phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0)) == "$this-\>\n    test(3)";

test bool shouldCompileStaticCall() = 
    implode(toCode(phpStaticCall(phpName(phpName("This")), phpName(phpName("test")), []), 0)) == "This::test()";
    
test bool shouldCompileStaticCallWithParams() = 
    implode(toCode(phpStaticCall(phpExpr(phpVar(phpName(phpName("this")))),
        phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0)) == "$this::test(3)";

test bool shouldCompileToNewInstanceWithoutParameters() = 
	implode(toCode(phpNew(phpName(phpName("User")), []), 0)) == "new User()";

test bool shouldCompileToNewInstanceUsingVarWithoutParameters() = 
	implode(toCode(phpNew(phpExpr(phpVar(phpName(phpName("class")))), []), 0)) == "new $class()";

test bool shouldCompileToNewInstanceWithAParameter() = 
	implode(toCode(phpNew(phpName(phpName("User")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0)) == "new User(3)";
	
test bool shouldCompileToNewInstanceWithParameters() = 
	implode(toCode(phpNew(phpExpr(phpVar(phpName(phpName("class")))), [
		phpActualParameter(phpScalar(phpInteger(3)), false),
		phpActualParameter(phpScalar(phpInteger(4)), false),
		phpActualParameter(phpVar(phpName(phpName("var"))), true)
	]), 0)) == "new $class(3, 4, &$var)";

test bool shouldCompileUnaryOperationPreInc() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPreInc()), 0)) == "++$var";
	
test bool shouldCompileUnaryOperationPostInc() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPostInc()), 0)) == "$var++";
	
test bool shouldCompileUnaryOperationPreDec() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPreDec()), 0)) == "--$var";
	
test bool shouldCompileUnaryOperationPostDec() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPostDec()), 0)) == "$var--";
	
test bool shouldCompileUnaryOperationUnaryPlus() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpUnaryPlus()), 0)) == "+$var";
	
test bool shouldCompileUnaryOperationUnaryMinus() = 
	implode(toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpUnaryMinus()), 0)) == "-$var";

test bool shouldCompileBinaryOperation() = 
	implode(toCode(phpBinaryOperation(phpVar(phpName(phpName("var1"))), phpVar(phpName(phpName("var2"))), phpLt()), 0)) == 
	"$var1 \< $var2";

test bool shouldCompileListAssign() = implode(toCode(phpListAssign([
		phpSomeExpr(phpVar(phpName(phpName("var")))), phpNoExpr(), phpSomeExpr(phpVar(phpName(phpName("var2"))))
	], phpVar(phpName(phpName("info")))), 0)) == "list($var, , $var2) = $info";

test bool shouldCompileRefAssign() = 
	implode(toCode(phpRefAssign(phpVar(phpName(phpName("var"))), phpVar(phpName(phpName("info")))), 0)) == "$var =& $info";

test bool shouldCompileAssignToWOp() = 
	implode(toCode(phpAssignWOp(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(739)), phpPlus()), 0)) == "$var += 739";

test bool shouldCompileAssignToWOpMinus() = 
	implode(toCode(phpAssignWOp(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(739)), phpMinus()), 0)) == "$var -= 739";

test bool shouldCompileAssignTo() = 
	implode(toCode(phpAssign(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(239))), 0)) == "$var = 239";

test bool shouldCompileFetchClassConstStatically() = 
	implode(toCode(phpFetchClassConst(phpName(phpName("User")), "MY_CONST"), 0)) == "User::MY_CONST";

test bool shouldCompileFetchClassConstFromVariable() = 
	implode(toCode(phpFetchClassConst(phpExpr(phpVar(phpName(phpName("var")))), "MY_CONST"), 0)) == "$var::MY_CONST";

test bool shouldCompileFetchArrayDim() = 
	implode(toCode(phpFetchArrayDim(phpVar(phpName(phpName("var"))), phpSomeExpr(phpScalar(phpInteger(0)))), 0)) == "$var[0]";
	
test bool shouldCompileFetchArrayDimEmptyIndex() = 
	implode(toCode(phpFetchArrayDim(phpVar(phpName(phpName("var"))), phpNoExpr()), 0)) == "$var[]";

test bool shouldCompileArrayWithOneElement() = 
	implode(toCode(phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpString("a value")), false)]), 0)) ==
	"[\"key\" =\> \"a value\"]";
	
test bool shouldCompileArrayWithTwoElements() = 
	implode(toCode(phpArray([
		phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpString("a value")), false),
		phpArrayElement(phpSomeExpr(phpScalar(phpString("key2"))), phpScalar(phpString("a value2")), false)
	]), 0)) ==
	"[\"key\" =\> \"a value\", \"key2\" =\> \"a value2\"]";
	
test bool shouldCompileArrayElements() = 
	implode(toCode(phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpInteger(2)), true), 0)) ==
	"\"key\" =\> &2";

test bool shouldCompileStaticClosureWithUses() = 
	implode(toCode(phpClosure(
		[phpExprstmt(phpScalar(phpBoolean(true)))], 
		[phpParam("param", phpNoExpr(), phpNoName(), false, false)], 
		[phpClosureUse(phpVar(phpName(phpName("var"))), false)], 
		true, 
		true), 0)) == "static &function ($param) use ($var) {\n    true;\n}";
		
test bool shouldCompileClosure() = 
	implode(toCode(phpClosure(
		[phpExprstmt(phpScalar(phpBoolean(true)))], 
		[phpParam("param", phpNoExpr(), phpNoName(), false, false)], 
		[], 
		false, 
		false), 0)) == "function ($param) {\n    true;\n}";
