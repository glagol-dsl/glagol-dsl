module Test::Transform::Glagol2PHP::Constructors

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Constructors;

test bool shouldTransformEmptyConstructorToEmptyPhpConstructor() =
    toPhpClassItem(constructor([], [])) == phpMethod("__construct", {phpPublic()}, false, [], []);

test bool shouldTransformConstructorToPhpConstructorWithOneParamAndNoDefaultValue() =
    toPhpClassItem(constructor([param(integer(), "param1")], [])) == phpMethod("__construct", {phpPublic()}, false, [
        phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false)
    ], []);

