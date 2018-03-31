module Test::Typechecker::Artifact

import Typechecker::Artifact;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

test bool shouldGiveErrorsWhenEntityRedefiningImportedArtifact() = 
	checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot redefine \"User\"",
		addImported(\import("User", namespace("Test"), "User"),
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))))
	);

test bool shouldNotGiveErrorsWhenEntityRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test2"), "UserEntity"),
    	addToAST(
    	file(|tmp:///UserEntity.g|, \module(namespace("Test2"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))) == 
	addImported(\import("User", namespace("Test2"), "UserEntity"),
	addImported(\import("Bla", namespace("Test"), "Bla"),
    	addToAST(
    	file(|tmp:///UserEntity.g|, \module(namespace("Test2"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|)))));
    
test bool shouldGiveErrorsWhenUtilRedefiningImportedArtifact() = 
    checkArtifact(util("User", [], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot redefine \"User\"",
		addImported(\import("User", namespace("Test"), "User"),
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))
	);

test bool shouldNotGiveErrorsWhenUtilRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(util("User", [], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))) == 
	addImported(\import("User", namespace("Test"), "UserEntity"),
    addImported(\import("Bla", namespace("Test"), "Bla"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|)))));
    
test bool shouldGiveErrorsWhenVORedefiningImportedArtifact() = 
	checkArtifact(valueObject("User", [
    	constructor([param(string(), "test", emptyExpr())], [], emptyExpr()),
    	method(\public(), string(), "toDatabaseValue", [], [\return(string(""))], emptyExpr())
	], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
        "Cannot redefine \"User\"",
		addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))))
	);

test bool shouldNotGiveErrorsWhenVORedefiningImportedArtifactButUsingAlias() = 
    !hasErrors(checkArtifact(valueObject("User", [], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))));
    	
test bool shouldGiveErrorWhenToDatabaseValueMethodReturnsVoid() = 
    checkArtifact(valueObject("User", [
    	method(\public(), voidValue(), "toDatabaseValue", [], [\return(emptyExpr())], emptyExpr())
	], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
    	"toDatabaseValue() cannot return void", 
    	addImported(\import("User", namespace("Test"), "UserEntity"),
    	addImported(\import("Bla", namespace("Test"), "Bla"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))));
    	
test bool shouldGiveErrorWhenHasToDatabaseValueMethodButNoMatchingConstructor() = 
    checkArtifact(valueObject("User", [
    	constructor([param(integer(), "test", emptyExpr())], [], emptyExpr()),
    	method(\public(), string(), "toDatabaseValue", [], [\return(string(""))], emptyExpr())
	], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
    	"Value object should implement a constructor matching User(string)", 
    	addImported(\import("User", namespace("Test"), "UserEntity"), 
    	addImported(\import("Bla", namespace("Test"), "Bla"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))));
    	
test bool shouldNotGiveErrorWhenHasToDatabaseValueMethodWithMatchingConstructor() = 
    !hasErrors(checkArtifact(valueObject("User", [
    	constructor([param(string(), "test", emptyExpr())], [], emptyExpr()),
    	method(\public(), string(), "toDatabaseValue", [], [\return(string(""))], emptyExpr())
	], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))))));
    	
test bool shouldNotGiveErrorWhenHasToDatabaseValueMethodWithMatchingConstructorHavingDefaultParams() = 
    !hasErrors(checkArtifact(valueObject("User", [
    	constructor([param(string(), "test", emptyExpr())], [], emptyExpr()),
    	method(\public(), string(), "toDatabaseValue", [], [\return(string(""))], emptyExpr())
	], notProxy())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))))));

test bool shouldGiveErrorsWhenRepositoryPointsToNotImportedEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///UserRepository.g|)) == 
    addError(|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>), "Entity \"User\" not imported", newEnv(|tmp:///UserRepository.g|));

test bool shouldNotGiveErrorsWhenRepositoryPointsToImportedEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))) == 
	
	addImported(\import("User", namespace("Test"), "User"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)));

test bool shouldGiveErrorsWhenRepositoryPointsToImportedNonEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)], 
    	addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)], addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", [], notProxy()))), newEnv(|tmp:///Test/UserRepository.g|)))
    ) ==
    addError(|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>), "\"User\" is not an entity", 
	    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)], addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", [], notProxy()))), newEnv(|tmp:///Test/UserRepository.g|)))
    );

test bool shouldGiveErrorWhenControllerDoesNotFollowNamingConvention() = 
    checkArtifact(controller("Blah", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///Blah.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///Blah.g|)) == 
    addError(|tmp:///Blah.g|(0, 0, <20, 20>, <30, 30>), 
        "Controller does not follow the convetion \<Identifier\>Controller.g", newEnv(|tmp:///Blah.g|));

test bool shouldNotGiveErrorWhenControllerFollowsNamingConvention() = 
    checkArtifact(controller("BlahController", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], 
    newEnv(|tmp:///Blag.g|)) == 
    newEnv(|tmp:///Blag.g|);

test bool shouldNotGiveErrorWhenTypecheckingReturnAdaptableOnProxy() = 
	!hasErrors(checkArtifact(valueObject("DateTime", [
    	constructor([param(string(), "now", emptyExpr())], [\return(adaptable())], emptyExpr()),
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")), setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///User.g|))));

test bool shouldGiveErrorWhenTypecheckingMultipleRepositoriesForOneEntity() =
	checkForDuplicatedRepositories(addToAST([
		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)]),
		file(|tmp:///|, \module(namespace("TestR"), [\import("User", namespace("Test"), "U")], repository("U", []))),
		file(|tmp:///|, \module(namespace("TestF"), [\import("User", namespace("Test"), "User")], repository("User", [])))
	], newEnv(|tmp:///|))) == addError(|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>), 
		"More than one repository declared for entity Test::User", addToAST([
		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)]),
		file(|tmp:///|, \module(namespace("TestR"), [\import("User", namespace("Test"), "U")], repository("U", []))),
		file(|tmp:///|, \module(namespace("TestF"), [\import("User", namespace("Test"), "User")], repository("User", [])))
	], newEnv(|tmp:///|)));
	
test bool shouldNotGiveErrorWhenTypecheckingSingleRepositoriesForOneEntity() =
	!hasErrors(checkForDuplicatedRepositories(addToAST([
		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)]),
		file(|tmp:///|, \module(namespace("TestR"), [\import("User", namespace("Test"), "U")], repository("U", [])))
	], newEnv(|tmp:///|))));

