module Test::Compiler::PHP::Expressions

import Compiler::PHP::Expressions;
import Syntax::Abstract::PHP;

test bool shouldCompileScalarClassConstant() = toCode(phpScalar(phpClassConstant()), 0) == "__CLASS__";
test bool shouldCompileScalarDirConstant() = toCode(phpScalar(phpDirConstant()), 0) == "__DIR__";
test bool shouldCompileScalarFileConstant() = toCode(phpScalar(phpFileConstant()), 0) == "__FILE__";
test bool shouldCompileScalarFuncConstant() = toCode(phpScalar(phpFuncConstant()), 0) == "__FUNCTION__";
test bool shouldCompileScalarLineConstant() = toCode(phpScalar(phpLineConstant()), 0) == "__LINE__";
test bool shouldCompileScalarMethodConstant() = toCode(phpScalar(phpMethodConstant()), 0) == "__METHOD__";
test bool shouldCompileScalarNamespaceConstant() = toCode(phpScalar(phpNamespaceConstant()), 0) == "__NAMESPACE__";
test bool shouldCompileScalarTraitConstant() = toCode(phpScalar(phpTraitConstant()), 0) == "__TRAIT__";
test bool shouldCompileScalarNull() = toCode(phpScalar(phpNull()), 0) == "null";
test bool shouldCompileScalarFloat() = toCode(phpScalar(phpFloat(1.88)), 0) == "1.88";
test bool shouldCompileScalarInteger() = toCode(phpScalar(phpInteger(323)), 0) == "323";
test bool shouldCompileScalarString() = toCode(phpScalar(phpString("haha")), 0) == "\"haha\"";
test bool shouldCompileScalarBooleanTrue() = toCode(phpScalar(phpBoolean(true)), 0) == "true";
test bool shouldCompileScalarBooleanFalse() = toCode(phpScalar(phpBoolean(false)), 0) == "false";
test bool shouldCompileScalarEncapsedStringPart() = toCode(phpScalar(phpEncapsedStringPart("blah")), 0) == "blah";

test bool shouldCompileScalarEncapsed() = 
    toCode(phpScalar(phpEncapsed([phpScalar(phpEncapsedStringPart("blah")), phpVar(phpName(phpName("var")))])), 0) == "blah$var";
    
test bool shouldCompileNoExpr() = toCode(phpNoExpr(), 0) == "";
test bool shouldCompileVarExpr() = toCode(phpVar(phpName(phpName("var"))), 0) == "$var";
test bool shouldCompileVarVarExpr() = toCode(phpVar(phpExpr(phpVar(phpName(phpName("var"))))), 0) == "$$var";
test bool shouldCompileCastType() = toCode(phpCast(phpInt(), phpVar(phpName(phpName("var")))), 0) == "(int) $var";
test bool shouldCompileClone() = toCode(phpClone(phpVar(phpName(phpName("var")))), 0) == "clone $var";
test bool shouldCompileFetchConst() = toCode(phpFetchConst(phpName("BLAH")), 0) == "BLAH";
test bool shouldCompileEmpty() = toCode(phpEmpty(phpVar(phpName(phpName("var")))), 0) == "empty($var)";
test bool shouldCompileSuppress() = toCode(phpSuppress(phpEmpty(phpVar(phpName(phpName("var"))))), 0) == "@empty($var)";
test bool shouldCompileEmpty() = toCode(phpEmpty(phpVar(phpName(phpName("var")))), 0) == "empty($var)";
test bool shouldCompileEval() = toCode(phpEval(phpScalar(phpString("code"))), 0) == "eval(\"code\")";
test bool shouldCompileExit() = toCode(phpExit(phpNoExpr()), 0) == "exit";
test bool shouldCompileExitWithParam() = toCode(phpExit(phpSomeExpr(phpVar(phpName(phpName("var"))))), 0) == "exit($var)";
test bool shouldCompileInclude() = toCode(phpInclude(phpScalar(phpString("test.php")), phpInclude()), 0) == "include \"test.php\"";
test bool shouldCompileBrackets() = toCode(phpBracket(phpSomeExpr(phpScalar(phpBoolean(true)))), 0) == "(true)";

test bool shouldCompileDestructorList() = 
    toCode(phpListExpr([phpSomeExpr(phpVar(phpName(phpName("var1")))), phpSomeExpr(phpVar(phpName(phpName("var2"))))]), 0) == "[$var1, $var2]"; 

test bool shouldCompileYieldWithValueOnly() = 
    toCode(phpYield(phpNoExpr(), phpSomeExpr(phpScalar(phpInteger(1)))), 0) == "yield 1";
    
test bool shouldCompileYieldWithKeyAndValue() = 
    toCode(phpYield(phpSomeExpr(phpScalar(phpString("myKey"))), phpSomeExpr(phpScalar(phpInteger(1)))), 0) == "yield \"myKey\" =\> 1";

test bool shouldCompileYieldWithoutValue() = 
    toCode(phpYield(phpNoExpr(), phpNoExpr()), 0) == "yield";

test bool shouldCompileStaticPropertyFetch() = 
    toCode(phpStaticPropertyFetch(phpName(phpName("MyClass")), phpName(phpName("prop"))), 0) == "MyClass::$prop";

test bool shouldCompileTernaryWithIfAndElseIf() = 
    toCode(phpTernary(phpScalar(phpBoolean(true)), phpSomeExpr(phpScalar(phpInteger(1))), phpScalar(phpInteger(4))), 0) ==
    "true ? 1 : 4";

test bool shouldCompileTernaryWithElseIfOnly() = 
    toCode(phpTernary(phpScalar(phpBoolean(true)), phpNoExpr(), phpScalar(phpInteger(4))), 0) ==
    "true ?: 4";

test bool shouldCompileInstanceOf() = 
    toCode(phpInstanceOf(phpVar(phpName(phpName("object"))), phpName(phpName("MyClass"))), 0) == "$object instanceof MyClass";

test bool shouldCompileIsset() =
    toCode(phpIsSet([phpVar(phpName(phpName("var1"))), phpVar(phpName(phpName("var2")))]), 0) == "isset($var1, $var2)";

test bool shouldCompilePrint() = toCode(phpPrint(phpScalar(phpString("Hey"))), 0) == "print \"Hey\"";

test bool shouldCompileShellExec() = 
    toCode(phpShellExec([phpScalar(phpEncapsedStringPart("hello --")), phpVar(phpName(phpName("command")))]), 0) == "`hello --$command`";

test bool shouldCompilePropertyFetch() = 
    toCode(phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("field"))), 0) == "$this-\>field";

test bool shouldCompileFuncCall() = toCode(phpCall(phpName(phpName("test")), []), 0) == "test()";

test bool shouldCompileFuncCallWithParams() = toCode(phpCall(
	phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0) == 
	"test(3)";

test bool shouldCompileMethodCall() = 
    toCode(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("test")), []), 0) == "$this-\>test()";
    
test bool shouldCompileMethodCallWithParams() = 
    toCode(phpMethodCall(phpVar(phpName(phpName("this"))),
        phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0) == "$this-\>test(3)";

test bool shouldCompileStaticCall() = 
    toCode(phpStaticCall(phpName(phpName("This")), phpName(phpName("test")), []), 0) == "This::test()";
    
test bool shouldCompileStaticCallWithParams() = 
    toCode(phpStaticCall(phpExpr(phpVar(phpName(phpName("this")))),
        phpName(phpName("test")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0) == "$this::test(3)";

test bool shouldCompileToNewInstanceWithoutParameters() = 
	toCode(phpNew(phpName(phpName("User")), []), 0) == "new User()";

test bool shouldCompileToNewInstanceUsingVarWithoutParameters() = 
	toCode(phpNew(phpExpr(phpVar(phpName(phpName("class")))), []), 0) == "new $class()";

test bool shouldCompileToNewInstanceWithAParameter() = 
	toCode(phpNew(phpName(phpName("User")), [phpActualParameter(phpScalar(phpInteger(3)), false)]), 0) == "new User(3)";
	
test bool shouldCompileToNewInstanceWithParameters() = 
	toCode(phpNew(phpExpr(phpVar(phpName(phpName("class")))), [
		phpActualParameter(phpScalar(phpInteger(3)), false),
		phpActualParameter(phpScalar(phpInteger(4)), false),
		phpActualParameter(phpVar(phpName(phpName("var"))), true)
	]), 0) == "new $class(3, 4, &$var)";

test bool shouldCompileUnaryOperationPreInc() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPreInc()), 0) == "++$var";
	
test bool shouldCompileUnaryOperationPostInc() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPostInc()), 0) == "$var++";
	
test bool shouldCompileUnaryOperationPreDec() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPreDec()), 0) == "--$var";
	
test bool shouldCompileUnaryOperationPostDec() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpPostDec()), 0) == "$var--";
	
test bool shouldCompileUnaryOperationUnaryPlus() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpUnaryPlus()), 0) == "+$var";
	
test bool shouldCompileUnaryOperationUnaryMinus() = 
	toCode(phpUnaryOperation(phpVar(phpName(phpName("var"))), phpUnaryMinus()), 0) == "-$var";

test bool shouldCompileBinaryOperation() = 
	toCode(phpBinaryOperation(phpVar(phpName(phpName("var1"))), phpVar(phpName(phpName("var2"))), phpLt()), 0) == 
	"$var1 \< $var2";

test bool shouldCompileListAssign() = toCode(phpListAssign([
		phpSomeExpr(phpVar(phpName(phpName("var")))), phpNoExpr(), phpSomeExpr(phpVar(phpName(phpName("var2"))))
	], phpVar(phpName(phpName("info")))), 0) == "list($var, , $var2) = $info";

test bool shouldCompileRefAssign() = 
	toCode(phpRefAssign(phpVar(phpName(phpName("var"))), phpVar(phpName(phpName("info")))), 0) == "$var =& $info";

test bool shouldCompileAssignToWOp() = 
	toCode(phpAssignWOp(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(739)), phpPlus()), 0) == "$var += 739";

test bool shouldCompileAssignToWOp() = 
	toCode(phpAssignWOp(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(739)), phpMinus()), 0) == "$var -= 739";

test bool shouldCompileAssignTo() = 
	toCode(phpAssign(phpVar(phpName(phpName("var"))), phpScalar(phpInteger(239))), 0) == "$var = 239";

test bool shouldCompileFetchClassConst() = 
	toCode(phpFetchClassConst(phpName(phpName("User")), "MY_CONST"), 0) == "User::MY_CONST";

test bool shouldCompileFetchClassConst() = 
	toCode(phpFetchClassConst(phpExpr(phpVar(phpName(phpName("var")))), "MY_CONST"), 0) == "$var::MY_CONST";

test bool shouldCompileFetchArrayDim() = 
	toCode(phpFetchArrayDim(phpVar(phpName(phpName("var"))), phpSomeExpr(phpScalar(phpInteger(0)))), 0) == "$var[0]";
	
test bool shouldCompileFetchArrayDimEmptyIndex() = 
	toCode(phpFetchArrayDim(phpVar(phpName(phpName("var"))), phpNoExpr()), 0) == "$var[]";

test bool shouldCompileArrayWithOneElement() = 
	toCode(phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpString("a value")), false)]), 0) ==
	"[\"key\" =\> \"a value\"]";
	
test bool shouldCompileArrayWithTwoElements() = 
	toCode(phpArray([
		phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpString("a value")), false),
		phpArrayElement(phpSomeExpr(phpScalar(phpString("key2"))), phpScalar(phpString("a value2")), false)
	]), 0) ==
	"[\"key\" =\> \"a value\", \"key2\" =\> \"a value2\"]";
	
test bool shouldCompileArrayElements() = 
	toCode(phpArrayElement(phpSomeExpr(phpScalar(phpString("key"))), phpScalar(phpInteger(2)), true), 0) ==
	"\"key\" =\> &2";

test bool shouldCompileStaticClosureWithUses() = 
	toCode(phpClosure(
		[phpExprstmt(phpScalar(phpBoolean(true)))], 
		[phpParam("param", phpNoExpr(), phpNoName(), false, false)], 
		[phpClosureUse(phpVar(phpName(phpName("var"))), false)], 
		true, 
		true), 0) == "static &function ($param) use ($var) {\n    true;\n}";
		
test bool shouldCompileClosure() = 
	toCode(phpClosure(
		[phpExprstmt(phpScalar(phpBoolean(true)))], 
		[phpParam("param", phpNoExpr(), phpNoName(), false, false)], 
		[], 
		false, 
		false), 0) == "function ($param) {\n    true;\n}";
