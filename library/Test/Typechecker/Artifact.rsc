module Test::Typechecker::Artifact

import Typechecker::Artifact;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

test bool shouldGiveErrorsWhenEntityRedefiningImportedArtifact() = 
	checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
		"User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
	), [], []>) == <|tmp:///User.g|, (), (
		"User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
	), [], [
		<|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot redefine \"User\" in /User.g on line 20 " +
		"previously imported on line 10">
	]>;

test bool shouldNotGiveErrorsWhenEntityRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(entity("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>) == <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>;
    
test bool shouldGiveErrorsWhenUtilRedefiningImportedArtifact() = 
    checkArtifact(util("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>) == <|tmp:///User.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], [
        <|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
        "Cannot redefine \"User\" in /User.g on line 20 " +
        "previously imported on line 10">
    ]>;

test bool shouldNotGiveErrorsWhenUtilRedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(util("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>) == <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>;
    
test bool shouldGiveErrorsWhenVORedefiningImportedArtifact() = 
    checkArtifact(valueObject("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>) == <|tmp:///User.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], [
        <|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
        "Cannot redefine \"User\" in /User.g on line 20 " +
        "previously imported on line 10">
    ]>;

test bool shouldNotGiveErrorsWhenVORedefiningImportedArtifactButUsingAlias() = 
    checkArtifact(valueObject("User", [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>) == <|tmp:///User.g|, (), (
        "UserEntity": \import("User", namespace("Test"), "UserEntity")[@src=|tmp:///User.g|(0, 0, <10, 20>, <30, 30>)]
    ), [], []>;

test bool shouldGiveErrorsWhenRepositoryPointsToNotImportedEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///UserRepository.g|, (), (), [], []>) == 
    <|tmp:///UserRepository.g|, (), (), [], [
        <|tmp:///UserRepository.g|(0, 0, <20, 20>, <30, 30>), 
        "Entity \"User\" not imported in /UserRepository.g">
    ]>;

test bool shouldNotGiveErrorsWhenRepositoryPointsToImportedEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///Test/UserRepository.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)]
    ), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", [])))
    ], []>) == 
    <|tmp:///Test/UserRepository.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)]
    ), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", [])))
    ], []>;

test bool shouldGiveErrorsWhenRepositoryPointsToImportedNonEntity() = 
    checkArtifact(repository("User", [])[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///Test/UserRepository.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)]
    ), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", [])))
    ], []>) == 
    <|tmp:///Test/UserRepository.g|, (), (
        "User": \import("User", namespace("Test"), "User")[@src=|tmp:///Test/UserRepository.g|(0, 0, <10, 20>, <30, 30>)]
    ), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], util("User", [])))
    ], [
        <|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>), "\"User\" is not an entity in /Test/UserRepository.g on line 20">
    ]>;

test bool shouldGiveErrorWhenControllerDoesNotFollowNamingConvention() = 
    checkArtifact(controller("Blah", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///Blah.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///Blah.g|, (), (), [], []>) == 
    <|tmp:///Blah.g|, (), (), [], [
        <|tmp:///Blah.g|, 
        "Controller does not follow the convetion \<Identifier\>Controller.g in /Blah.g">
    ]>;

test bool shouldNotGiveErrorWhenControllerFollowsNamingConvention() = 
    checkArtifact(controller("BlahController", jsonApi(), route([routePart("/")]), [])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///BlahController.g|, (), (), [], []>) == 
    <|tmp:///BlahController.g|, (), (), [], []>;
