module Test::Typechecker::Method

import Typechecker::Method;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

test bool shouldGiveDuplicatedSignatureErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\private(), integer(), "test", [], [\return(integer(5))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\private(), integer(), "test", [], [], emptyExpr()),
			method(\private(), integer(), "test", [], [], emptyExpr())
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test has been defined more than once with a duplicating signature",
		newEnv(|tmp:///|)
	);

test bool shouldGiveConflictingAccessErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\private(), integer(), "test", [], [\return(integer(3))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\private(), integer(), "test", [], [], emptyExpr()),
			method(\public(), integer(), "test", [], [], integer(2))
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test is defined more than once with different access modifiers",
		newEnv(|tmp:///|)
	);

test bool shouldGiveConflictingReturnTypeErrorWhenMethodsDuplicate() =
	checkMethod(
		method(\public(), integer(), "test", [], [\return(integer(3))], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		entity("User", [
			method(\public(), integer(), "test", [], [], integer(3)),
			method(\public(), string(), "test", [], [], integer(2))
		]), newEnv(|tmp:///|)) ==
	addError(
		|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Method test is defined more than once with different return types",
		newEnv(|tmp:///|)
	);
