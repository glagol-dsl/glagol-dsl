module Test::Typechecker::Env

import Syntax::Abstract::Glagol;
import Typechecker::Env;

test bool shouldReturnTrueWhenVariableIsDefined() = 
	isDefined(variable("a"), addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldReturnFalseWhenVariableIsUndefined() = 
	!isDefined(variable("a"), newEnv(|tmp:///|));

test bool shouldReturnTrueWhenFieldIsDefined() = 
	isDefined(fieldAccess(symbol("a")), addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldReturnFalseWhenFieldIsUndefined() = 
	!isDefined(fieldAccess(symbol("a")), newEnv(|tmp:///|));

test bool shouldReturnTrueIfArtifactIsAlreadyImported() =
    isImported(\import("User", namespace("Test"), "User"), addImported(\import("User", namespace("Test"), "User"), newEnv(|tmp:///|)));
    
test bool shouldReturnTrueIfArtifactIsAlreadyImportedUsingAlias() =
    isImported(\import("User", namespace("Test"), "UserEntity"), 
    	addImported(\import("User", namespace("Test"), "UserEntity"), addToAST(
		file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), 
		newEnv(|tmp:///|))));

test bool shouldReturnFalseIfArtifactIsNotImported() =
    !isImported(\import("User", namespace("Test"), "User"), newEnv(|tmp:///|));

test bool shouldReturnTrueWhenArtifactIsInAST() = 
    isInAST(\import("User", namespace("Test"), "User"), 
		addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|)));

test bool shouldReturnFalseWhenArtifactIsNotInAST() = 
    !isInAST(\import("UserBla", namespace("Test"), "User"), 
    	addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|)));

test bool shouldReturnFalseWhenArtifactHasDifferentNSInAST() = 
    !isInAST(\import("User", namespace("Testing"), "User"), 
    addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|)));

test bool shouldGiveErrorWhenAddingAlreadyDefinedPropertyToDefinitions() = 
    addDefinition(property(integer(), "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], <|tmp:///User.g|, (
            "id": field(property(integer(), "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], [], emptyDecl(), 0, 0>) == 
    <|tmp:///User.g|,("id":field(property(
      integer(),
      "id",
      emptyExpr())[
      @src=|tmp:///User.g|(0,0,<20,20>,<30,30>)
    ])),(),[],[<|tmp:///User.g|(0,0,<20,20>,<30,30>),"Cannot redefine \"id\". Already defined">],emptyDecl(),0,0>;

test bool shouldGiveErrorWhenTryingToRedecleareParameter() = 
    addDefinition(declare(integer(), variable("id"), emptyStmt())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], <|tmp:///User.g|, (
            "id": param(param(integer(), "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], [], emptyDecl(), 0, 0>) == 
    <|tmp:///User.g|,("id":param(param(
      integer(),
      "id",
      emptyExpr())[
      @src=|tmp:///User.g|(0,0,<20,20>,<30,30>)
    ])),(),[],[<|tmp:///User.g|(0,0,<20,20>,<30,30>),"Cannot redecleare \"id\"">],emptyDecl(),0,0>;

test bool shouldAddErrorToEnv() = addError(|tmp:///User.g|, "this is an error message", <|tmp:///User.g|, (), (), [], [], emptyDecl(), 0, 0>) == <|tmp:///User.g|, (), (), [], [
    <|tmp:///User.g|, "this is an error message">
], emptyDecl(), 0, 0>;

test bool shouldNotGiveErrorWhenAddingNonDefinedPropertyToDefinitions() = 
    addDefinition(property(integer(), "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///User.g|)) == 
    <|tmp:///User.g|, (
        "id": field(property(integer(), "id", emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], [], emptyDecl(), 0, 0>;
	
test bool shouldFindArtifact() =
	findArtifact(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|))) 
	== [entity("User", [])];

test bool shouldNotFindArtifact() =
	findArtifact(\import("UserBa", namespace("Test"), "User"), 
		addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|))
	) == [];

test bool shouldReturnTrueWhenArtifactIsEntity() =
	isEntity(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|)));

test bool shouldReturnFalseWhenArtifactIsNotEntity() =
	!isEntity(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///|)));
	
