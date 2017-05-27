module Test::Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

test bool testIsProperty() = 
    isProperty(property(integer(), "test", {}, integer(4))) &&
    isProperty(property(integer(), "test", {}, emptyExpr())) &&
    !isProperty(integer());

test bool testIsMethod() = 
    isMethod(method(\public(), voidValue(), "test", [], [], boolean(true))) &&
    isMethod(method(\public(), voidValue(), "test", [], [], emptyExpr())) &&
    !isMethod(property(integer(), "test", {}, emptyExpr()));

test bool testIsRelation() = 
    isRelation(relation(\one(), \one(), "Language", "lang", {})) && 
    !isRelation(property(integer(), "test", {}, emptyExpr()));

test bool testIsConstructor() = 
    isConstructor(constructor([], [], emptyExpr())) && 
    isConstructor(constructor([], [], boolean(true))) && 
    !isConstructor(property(integer(), "test", {}, emptyExpr()));

test bool testIsEntity() =
    isEntity(entity("User", [])) &&
    !isEntity(util("UserCreator", []));

test bool testHasConstructors() = 
    hasConstructors([property(integer(), "test", {}, emptyExpr()), property(integer(), "test2", {}, emptyExpr()), constructor([], [], emptyExpr())]) && 
    !hasConstructors([property(integer(), "test", {}, emptyExpr()), property(integer(), "test2", {}, emptyExpr())]);

test bool testGetConstructors() =
    getConstructors([property(integer(), "test", {}, emptyExpr()), property(integer(), "test2", {}, emptyExpr()), constructor([], [], emptyExpr())]) 
    	== [constructor([], [], emptyExpr())] &&
    getConstructors([property(integer(), "test", {}, emptyExpr()), property(integer(), "test2", {}, emptyExpr())]) == [];

test bool testCategorizeMethods() = 
    categorizeMethods([
        method(\public(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], emptyExpr()), 
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr())
    ]) == ("test": [
        method(\public(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], emptyExpr()), 
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr())
    ]);

test bool testGetRelations() = 
    getRelations([
    	relation(\one(), \one(), "Language", "lang2", {}), 
    	relation(\one(), \one(), "Language", "lang1", {}), 
    	property(integer(), "test", {}, emptyExpr())]
	) ==
        [relation(\one(), \one(), "Language", "lang2", {}), relation(\one(), \one(), "Language", "lang1", {})] &&
    getRelations([property(integer(), "test", {}, emptyExpr()), method(\public(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], emptyExpr())]) == [];

test bool testHasOverriding() = 
    hasOverriding([
        method(\public(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], emptyExpr()), 
        constructor([param(string(), "b", emptyExpr())], [], emptyExpr()), 
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr())
    ]) && 
    hasOverriding([
        constructor([param(integer(), "a", emptyExpr())], [], emptyExpr()), 
        constructor([param(string(), "b", emptyExpr())], [], emptyExpr()), 
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr())
    ]) && 
    !hasOverriding([
        constructor([param(integer(), "a", emptyExpr())], [], emptyExpr()),
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr())
    ]);

test bool testHasMapUsageShouldReturnFalseOnEmptyEntity() = 
    !hasMapUsage(entity("User", []));

test bool testHasMapUsageShouldReturnTrueOnPropertyOfMapType() = 
    hasMapUsage(entity("User", [
        property(\map(integer(), string()), "prop", {}, emptyExpr())
    ]));

test bool testHasMapUsageShouldReturnTrueWhenContainsAMap() = 
    hasMapUsage(entity("User", [
        constructor([], [
            expression(\map(()))
        ], emptyExpr())
    ]));

test bool testHasMapUsageShouldReturnTrueOnPropertyOfListType() = 
    hasListUsage(entity("User", [
        property(\list(integer()), "prop", {}, emptyExpr())
    ]));

test bool testHasMapUsageShouldReturnTrueWhenContainsAList() = 
    hasListUsage(entity("User", [
        constructor([], [
            expression(\list([]))
        ], emptyExpr())
    ]));

test bool testIsImportedReturnsTrue() = isImported("User", [\import("Customer", namespace("Test"), "Customer"), \import("Usr", namespace("Test"), "User")]);
test bool testIsImportedReturnsFalse() = !isImported("User", [\import("Customer", namespace("Test"), "Customer"), \import("User", namespace("Test"), "Userr")]);

test bool shouldCollectOnlyDIProperties() = getDIProperties([
        property(repository(unresolvedName("User")), "prop", {}, get(repository(unresolvedName("User")))),
        property(repository(unresolvedName("Customer")), "prop", {}, emptyExpr()),
        constructor([], [
            expression(\map(()))
        ], emptyExpr())
    ]) == [property(repository(unresolvedName("User")), "prop", {}, get(repository(unresolvedName("User"))))];
    
test bool shouldCollectOnlyDIProperties2() = getDIProperties([
        property(repository(unresolvedName("Customer")), "prop", {}, emptyExpr()),
        constructor([], [
            expression(\map(()))
        ], emptyExpr())
    ]) == [];
    
test bool testHasDependencies() = 
	!hasDependencies([
        property(repository(unresolvedName("Customer")), "prop", {}, emptyExpr()),
        constructor([], [
            expression(\map(()))
        ], emptyExpr())
    ]) && hasDependencies([
        property(repository(unresolvedName("Customer")), "prop", {}, get(repository(unresolvedName("Customer")))),
        constructor([], [
            expression(\map(()))
        ], emptyExpr())
    ]);

test bool testGetActions() = 
	getActions([
        property(repository(unresolvedName("Customer")), "prop", {}, emptyExpr()),
        action("index", [], [])
	]) == [action("index", [], [])];
    
test bool testHasAnnotation() =
    hasAnnotation(entity("User", [])[@annotations=[
        annotation("field", [])
    ]], "field");
    
test bool testHasAnnotationFalse() =
    !hasAnnotation(entity("User", [])[@annotations=[
        annotation("column", [])
    ]], "field");

test bool shouldMakeStringFromNamespaceChainUsingDelimiter() 
    = "Some::Example::Namespace" == namespaceToString(namespace("Some", namespace("Example", namespace("Namespace"))), "::");

test bool shouldMakeStringFromNamespaceChainUsingAltDelimiter() 
    = "Another\\Example\\Namespace" == namespaceToString(namespace("Another", namespace("Example", namespace("Namespace"))), "\\");
    
