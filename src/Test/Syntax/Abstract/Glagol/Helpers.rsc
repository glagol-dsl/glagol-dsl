module Test::Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

test bool testIsProperty() = 
    isProperty(property(integer(), "test", {}, integer(4))) &&
    isProperty(property(integer(), "test", {})) &&
    !isProperty(integer());

test bool testIsMethod() = 
    isMethod(method(\public(), voidValue(), "test", [], [], boolean(true))) &&
    isMethod(method(\public(), voidValue(), "test", [], [])) &&
    !isMethod(property(integer(), "test", {}));

test bool testIsRelation() = 
    isRelation(relation(\one(), \one(), "Language", "lang", {})) && 
    !isRelation(property(integer(), "test", {}));

test bool testIsConstructor() = 
    isConstructor(constructor([], [])) && 
    isConstructor(constructor([], [], boolean(true))) && 
    !isConstructor(property(integer(), "test", {}));

test bool testIsEntity() =
    isEntity(entity("User", [])) &&
    !isEntity(util("UserCreator", []));

test bool testHasConstructors() = 
    hasConstructors([property(integer(), "test", {}), property(integer(), "test2", {}), constructor([], [])]) && 
    !hasConstructors([property(integer(), "test", {}), property(integer(), "test2", {})]);

test bool testGetConstructors() =
    getConstructors([property(integer(), "test", {}), property(integer(), "test2", {}), constructor([], [])]) == [constructor([], [])] &&
    getConstructors([property(integer(), "test", {}), property(integer(), "test2", {})]) == [];

test bool testCategorizeMethods() = 
    categorizeMethods([
        method(\public(), voidValue(), "test", [param(integer(), "a")], []), 
        method(\public(), voidValue(), "test", [param(string(), "b")], [])
    ]) == ("test": [
        method(\public(), voidValue(), "test", [param(integer(), "a")], []), 
        method(\public(), voidValue(), "test", [param(string(), "b")], [])
    ]);

test bool testGetRelations() = 
    getRelations([
    	relation(\one(), \one(), "Language", "lang2", {}), 
    	relation(\one(), \one(), "Language", "lang1", {}), 
    	property(integer(), "test", {})]
	) ==
        [relation(\one(), \one(), "Language", "lang2", {}), relation(\one(), \one(), "Language", "lang1", {})] &&
    getRelations([property(integer(), "test", {}), method(\public(), voidValue(), "test", [param(integer(), "a")], [])]) == [];

test bool testHasOverriding() = 
    hasOverriding([
        method(\public(), voidValue(), "test", [param(integer(), "a")], []), 
        constructor([param(string(), "b")], []), 
        method(\public(), voidValue(), "test", [param(string(), "b")], [])
    ]) && 
    hasOverriding([
        constructor([param(integer(), "a")], []), 
        constructor([param(string(), "b")], []), 
        method(\public(), voidValue(), "test", [param(string(), "b")], [])
    ]) && 
    !hasOverriding([
        constructor([param(integer(), "a")], []),
        method(\public(), voidValue(), "test", [param(string(), "b")], [])
    ]);

test bool testHasMapUsageShouldReturnFalseOnEmptyEntity() = 
    !hasMapUsage(entity("User", []));

test bool testHasMapUsageShouldReturnTrueOnPropertyOfMapType() = 
    hasMapUsage(entity("User", [
        property(\map(integer(), string()), "prop", {})
    ]));

test bool testHasMapUsageShouldReturnTrueWhenContainsAMap() = 
    hasMapUsage(entity("User", [
        constructor([], [
            expression(\map(()))
        ])
    ]));

test bool testHasMapUsageShouldReturnTrueOnPropertyOfListType() = 
    hasListUsage(entity("User", [
        property(\list(integer()), "prop", {})
    ]));

test bool testHasMapUsageShouldReturnTrueWhenContainsAList() = 
    hasListUsage(entity("User", [
        constructor([], [
            expression(\list([]))
        ])
    ]));
