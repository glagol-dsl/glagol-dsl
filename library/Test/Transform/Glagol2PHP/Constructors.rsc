module Test::Transform::Glagol2PHP::Constructors

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Constructors;
import Config::Config;
import Transform::Env;

test bool shouldTransformEmptyConstructorToEmptyPhpConstructor() =
    toPhpClassItem(constructor([], [], emptyExpr()), [], newTransformEnv()) == phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName());

test bool shouldTransformConstructorToPhpConstructorWithOneParamAndNoDefaultValue() =
    toPhpClassItem(constructor([param(integer(), "param1", emptyExpr())], [], emptyExpr()), [], newTransformEnv()) == phpMethod("__construct", {phpPublic()}, false, [
        phpParam("param1", phpNoExpr(), phpSomeName(phpName("int")), false, false)
    ], [], phpNoName());

test bool shouldTransformConstructorToPhpConstructorWithOneParamWithDefaultValue() =
    toPhpClassItem(constructor([param(integer(), "param1", integer(55))], [], emptyExpr()), [], newTransformEnv()) == phpMethod("__construct", {phpPublic()}, false, [
        phpParam("param1", phpSomeExpr(phpScalar(phpInteger(55))), phpSomeName(phpName("int")), false, false)
    ], [], phpNoName());

test bool shouldTransformConstructorToPhpConstructorWithOneParamWithWhen() =
    toPhpClassItem(constructor([param(integer(), "a", emptyExpr())], [], equals(variable("a"), integer(7))), [], newTransformEnv()) ==
    phpMethod("__construct", {phpPublic()}, false, [
        phpParam("a", phpNoExpr(), phpSomeName(phpName("int")), false, false)
    ], [
        phpIf(phpBinaryOperation(phpVar(phpName(phpName("a"))), phpScalar(phpInteger(7)), phpIdentical()), [], [], phpNoElse())
    ], phpNoName());


