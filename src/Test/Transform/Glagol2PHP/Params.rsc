module Test::Transform::Glagol2PHP::Params

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Params;

test bool shouldTransformParamWithoutDefaultValueWithScalarType()
    = toPhpParam(param(integer(), "param1")) == phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false);
    
test bool shouldTransformParamWithDefaultIntValueAndScalarType()
    = toPhpParam(param(integer(), "param1", intLiteral(53))) == phpParam("param1", phpSomeExpr(phpScalar(phpInteger(53))), phpSomeName(phpName("int")), false);
    
test bool shouldTransformParamWithDefaultFloatValueAndScalarType()
    = toPhpParam(param(integer(), "param1", floatLiteral(53.36))) == 
        phpParam("param1", phpSomeExpr(phpScalar(phpFloat(53.36))), phpSomeName(phpName("int")), false);
    
