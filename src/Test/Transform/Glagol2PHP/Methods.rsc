module Test::Transform::Glagol2PHP::Methods

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Methods;

test bool shouldTransformSimpleMethod() =
    toPhpClassItem(method(\public(), voidValue(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpNoName());

test bool shouldTransformMethodWithIntegerReturnValue() =
    toPhpClassItem(method(\public(), integer(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("int")));

test bool shouldTransformMethodWithStringReturnValue() =
    toPhpClassItem(method(\public(), string(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("string")));

test bool shouldTransformMethodWithBooleanReturnValue() =
    toPhpClassItem(method(\public(), boolean(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("boolean")));

test bool shouldTransformMethodWithFloatReturnValue() =
    toPhpClassItem(method(\public(), float(), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("float")));

test bool shouldTransformMethodWithIntegerListReturnValue() =
    toPhpClassItem(method(\public(), typedList(integer()), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Vector")));

test bool shouldTransformMethodWithStringListReturnValue() =
    toPhpClassItem(method(\public(), typedList(string()), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Vector")));

test bool shouldTransformMethodWithMapReturnValue() =
    toPhpClassItem(method(\public(), typedMap(string(), float()), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("Map")));

test bool shouldTransformMethodWithArtifactReturnValue() =
    toPhpClassItem(method(\public(), artifactType("User"), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("User")));

test bool shouldTransformMethodWithArtifactReturnValue() =
    toPhpClassItem(method(\public(), repositoryType("User"), "test", [], [])) == 
    phpMethod("test", {phpPublic()}, false, [], [], phpSomeName(phpName("UserRepository")));

