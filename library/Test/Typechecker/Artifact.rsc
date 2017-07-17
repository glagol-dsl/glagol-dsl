module Test::Typechecker::Artifact

import Typechecker::Artifact;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

test bool shouldGiveErrorsWhenEntityRedefiningImportedArtifact() = 
	checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	newEnv(|tmp:///User.g|)))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot redefine \"User\" in /User.g on line 20",
		addImported(\import("User", namespace("Test"), "User"),
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))
	);

test bool shouldNotGiveErrorsWhenEntityRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test2"), "UserEntity"),
    	addToAST(
    	file(|tmp:///UserEntity.g|, \module(namespace("Test2"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))) == 
	addImported(\import("User", namespace("Test2"), "UserEntity"),
    	addToAST(
    	file(|tmp:///UserEntity.g|, \module(namespace("Test2"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)));
    
test bool shouldGiveErrorsWhenUtilRedefiningImportedArtifact() = 
    checkArtifact(util("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	newEnv(|tmp:///User.g|)))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot redefine \"User\" in /User.g on line 20",
		addImported(\import("User", namespace("Test"), "User"),
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))
	);

test bool shouldNotGiveErrorsWhenUtilRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(util("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))) == addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)));
    
test bool shouldGiveErrorsWhenVORedefiningImportedArtifact() = 
	checkArtifact(valueObject("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	newEnv(|tmp:///User.g|)))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
        "Cannot redefine \"User\" in /User.g on line 20",
		addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    	addToAST(
    	file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)])),
    	newEnv(|tmp:///User.g|)))
	);

test bool shouldNotGiveErrorsWhenVORedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(valueObject("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)))) == addImported(\import("User", namespace("Test"), "UserEntity"),
    addToAST(
    	file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///User.g|)));

test bool shouldGiveErrorsWhenRepositoryPointsToNotImportedEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///UserRepository.g|)) == 
    addError(|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>), "Entity \"User\" not imported in /UserRepository.g on line 20", newEnv(|tmp:///UserRepository.g|));

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
    	addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)], addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Test/UserRepository.g|)))
    ) ==
    addError(|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>), "\"User\" is not an entity in /Test/UserRepository.g on line 20", 
	    addImported(\import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)], addToAST(file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Test/UserRepository.g|)))
    );

test bool shouldGiveErrorWhenControllerDoesNotFollowNamingConvention() = 
    checkArtifact(controller("Blah", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///Blah.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///Blah.g|)) == 
    addError(|tmp:///Blah.g|(0, 0, <20, 20>, <30, 30>), 
        "Controller does not follow the convetion \<Identifier\>Controller.g in /Blah.g on line 20", newEnv(|tmp:///Blah.g|));

test bool shouldNotGiveErrorWhenControllerFollowsNamingConvention() = 
    checkArtifact(controller("BlahController", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], 
    newEnv(|tmp:///Blag.g|)) == 
    newEnv(|tmp:///Blag.g|);
