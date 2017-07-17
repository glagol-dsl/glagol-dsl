module Test::Typechecker::Method::Guard

import Typechecker::Method::Guard;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shouldNotGiveErrorWhenGuardIsBoolean() = checkGuard(boolean(true), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldGiveErrorWhenGuardIsNotBoolean() = 
	checkGuard(integer(1)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method guard should evaluate to boolean, resulted as integer",
		newEnv(|tmp:///|)
	);

test bool shouldGiveErrorWhenGuardResultsInUnknownType() = 
	checkGuard(product(integer(1), boolean(true))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method guard should evaluate to boolean, resulted as unknown_type",
		newEnv(|tmp:///|)
	);
	
