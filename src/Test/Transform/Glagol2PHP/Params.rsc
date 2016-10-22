module Test::Transform::Glagol2PHP::Params

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Params;

test bool shouldTransformParamWithoutDefaultValueWithScalarType()
    = toPhpParam(param(integer(), "param1")) == phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false);
