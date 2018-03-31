module Test::Typechecker::Redeclare

import Syntax::Abstract::Glagol;
import Typechecker::Redeclare;
import Typechecker::Env;

test bool shouldNotGiveErrorWhenNoDuplicatesExist() =
	!hasErrors(checkRedeclare(entity("User", [])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], 
		setContext(\module(namespace("Test"), [], entity("Bla", [])), newEnv(|tmp:///Blag.g|))));

test bool shouldGiveErrorWhenDuplicatesExist() =
	hasError(|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>), "Test::User has duplicate(s)", 
		checkRedeclare(entity("User", [])[@src=|tmp:///BlahController.g|(0, 0, <20, 20>, <30, 30>)], 
			addToAST([
				file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))[@src=|tmp:///Test/UserRepository.g|(0, 0, <20, 20>, <30, 30>)]),
				file(|tmp:///sds|, \module(namespace("Test"), [], entity("User", []))[@src=|tmp:///Test2/UserRepository.g|(0, 0, <20, 20>, <30, 30>)])
			], setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///Blag.g|)))));
