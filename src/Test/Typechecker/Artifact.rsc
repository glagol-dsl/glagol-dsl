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
