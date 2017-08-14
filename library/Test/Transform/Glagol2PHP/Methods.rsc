module Test::Transform::Glagol2PHP::Methods

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Methods;
import Config::Config;

test bool shouldTransformSimpleMethod() =
    toPhpClassItem(method(\public(), voidValue(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpNoName());

test bool shouldTransformMethodWithIntegerReturnValue() =
    toPhpClassItem(method(\public(), integer(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("int")));

test bool shouldTransformMethodWithStringReturnValue() =
    toPhpClassItem(method(\public(), string(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("string")));

test bool shouldTransformMethodWithBooleanReturnValue() =
    toPhpClassItem(method(\public(), boolean(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("bool")));

test bool shouldTransformMethodWithFloatReturnValue() =
    toPhpClassItem(method(\public(), float(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("float")));

test bool shouldTransformMethodWithIntegerListReturnValue() =
    toPhpClassItem(method(\public(), \list(integer()), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Vector")));

test bool shouldTransformMethodWithStringListReturnValue() =
    toPhpClassItem(method(\public(), \list(string()), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Vector")));

test bool shouldTransformMethodWithMapReturnValue() =
    toPhpClassItem(method(\public(), \map(string(), float()), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Map")));

test bool shouldTransformMethodWithArtifactReturnValue() =
    toPhpClassItem(method(\public(), artifact(local("User")), "test", [], [], emptyExpr()), <zend(), doctrine()>) ==
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("User")));

test bool shouldTransformMethodWithRepositoryReturnValue() =
    toPhpClassItem(method(\public(), repository(local("User")), "test", [], [], emptyExpr()), <zend(), doctrine()>) ==
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("UserRepository")));

test bool shouldTransformMethodWithPrivateModifier() =
    toPhpClassItem(method(\private(), voidValue(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPrivate()}, false, [], [], phpNoName());

test bool shouldTransformMethodWithPublicModifier() =
    toPhpClassItem(method(\public(), voidValue(), "test", [], [], emptyExpr()), <zend(), doctrine()>) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpNoName());

// TODO add tests using when expressions
test bool shouldTransformMethodUsingWhenExpression() = 
    toPhpClassItem(method(\private(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], equals(variable("a"), integer(7))), <zend(), doctrine()>) == 
    phpMethod("test", {phpPrivate()}, false, [
        phpParam("a", phpNoExpr(), phpSomeName(phpName("int")), false, false)
    ], [
        phpIf(phpBinaryOperation(phpVar(phpName(phpName("a"))), phpScalar(phpInteger(7)), phpIdentical()), [], [], phpNoElse())
    ], phpNoName());


