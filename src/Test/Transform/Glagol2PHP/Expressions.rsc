module Test::Transform::Glagol2PHP::Expressions

import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

test bool shouldTransformToScalarIntegerPhpExpr()
    = toPhpExpr(intLiteral(5)) == phpScalar(phpInteger(5))
    && toPhpExpr(intLiteral(7)) == phpScalar(phpInteger(7))
    && toPhpExpr(intLiteral(2)) != phpScalar(phpInteger(1));
    
test bool shouldTransformToScalarFloatPhpExpr()
    = toPhpExpr(floatLiteral(6.43)) == phpScalar(phpFloat(6.43))
    && toPhpExpr(floatLiteral(6.343)) == phpScalar(phpFloat(6.343))
    && toPhpExpr(floatLiteral(2.0)) != phpScalar(phpFloat(3.45));
    
test bool shouldTransformToScalarStringPhpExpr()
    = toPhpExpr(strLiteral("some string")) == phpScalar(phpString("some string"))
    && toPhpExpr(strLiteral("some string2")) == phpScalar(phpString("some string2"));

test bool shouldTransformToScalarBooleanPhpExpr()
    = toPhpExpr(boolLiteral(true)) == phpScalar(phpBoolean(true))
    && toPhpExpr(boolLiteral(false)) == phpScalar(phpBoolean(false))
    && toPhpExpr(boolLiteral(false)) != phpScalar(phpBoolean(true))
    && toPhpExpr(boolLiteral(true)) != phpScalar(phpBoolean(false));
    
test bool shouldTransformToScalarListPhpExpr()
    = toPhpExpr(\list([strLiteral("first"), strLiteral("second")])) 
    == phpNew(phpName(phpName("Vector")), [phpActualParameter(phpArray([
            phpArrayElement(phpNoExpr(), phpScalar(phpString("first")), false), 
            phpArrayElement(phpNoExpr(), phpScalar(phpString("second")), false)
        ]), false)]) &&
    toPhpExpr(\list([intLiteral(1), intLiteral(2)]))
    == phpNew(phpName(phpName("Vector")), [phpActualParameter(phpArray([
            phpArrayElement(phpNoExpr(), phpScalar(phpInteger(1)), false), 
            phpArrayElement(phpNoExpr(), phpScalar(phpInteger(2)), false)
        ]), false)]);

test bool shouldTransformToFetchLocalPropPhpExpr()
    = toPhpExpr(get(artifactType("SomeUtil"))) == phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("someUtil")));
    
test bool shouldTransformToFetchArrayDim() = toPhpExpr(arrayAccess(variable("test"), intLiteral(0))) == phpFetchArrayDim(phpVar(phpName(phpName("test"))), phpSomeExpr(phpScalar(phpInteger(0))));
test bool shouldTransformToFetchArrayDim2() = toPhpExpr(arrayAccess(variable("test"), strLiteral("dasdasasd"))) == phpFetchArrayDim(phpVar(phpName(phpName("test"))), phpSomeExpr(phpScalar(phpString("dasdasasd"))));

test bool shouldTransformToMap() = toPhpExpr(\map((intLiteral(1): strLiteral("first")))) == phpStaticCall(phpName(phpName("MapFactory")), phpName(phpName("createFromPairs")), [
    phpActualParameter(phpNew(phpName(phpName("Pair")), [phpActualParameter(phpScalar(phpInteger(1)), false), phpActualParameter(phpScalar(phpString("first")), false)]), false)
]);

@todo="Type check: check that pairs are from the same type further in the sequence"
test bool shouldTransformToMap2() = toPhpExpr(\map((strLiteral("key1"): strLiteral("val1"), strLiteral("key2"): strLiteral("val2")))) == phpStaticCall(phpName(phpName("MapFactory")), phpName(phpName("createFromPairs")), [
    phpActualParameter(phpNew(phpName(phpName("Pair")), [phpActualParameter(phpScalar(phpString("key1")), false), phpActualParameter(phpScalar(phpString("val1")), false)]), false),
    phpActualParameter(phpNew(phpName(phpName("Pair")), [phpActualParameter(phpScalar(phpString("key2")), false), phpActualParameter(phpScalar(phpString("val2")), false)]), false)
]);

test bool shouldTransformToVar() = toPhpExpr(variable("myVar")) == phpVar(phpName(phpName("myVar")));

test bool shouldTransformToBracket() = toPhpExpr(\bracket(variable("test"))) == phpBracket(phpSomeExpr(phpVar(phpName(phpName("test")))));

test bool shouldTransformToBinaryProductOp() = toPhpExpr(product(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpMul());
test bool shouldTransformToBinaryModOp() = toPhpExpr(remainder(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpMod());
test bool shouldTransformToBinaryDivOp() = toPhpExpr(division(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpDiv());
test bool shouldTransformToBinaryPlusOp() = toPhpExpr(addition(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpPlus());
test bool shouldTransformToBinaryMinusOp() = toPhpExpr(subtraction(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpMinus());
test bool shouldTransformToBinaryGeqOp() = toPhpExpr(greaterThanOrEq(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpGeq());
test bool shouldTransformToBinaryLeqOp() = toPhpExpr(lessThanOrEq(intLiteral(3), floatLiteral(4.5))) == phpBinaryOperation(phpScalar(phpInteger(3)), phpScalar(phpFloat(4.5)), phpLeq());

