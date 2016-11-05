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
    

