module Test::Typechecker::Param

import Typechecker::Param;
import Typechecker::Env;
import Syntax::Abstract::Glagol;
import Typechecker::Errors;

test bool shouldNotGiveErrorsOnEmptyParamsList() = checkParams([], newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldGiveDeclareErrorWhenDuplicatingParamsExist() = 
	checkParams([
		param(integer(), "test1", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], 
		param(string(), "test1", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
	], newEnv(|tmp:///|)) == 
	addDefinition(
		param(integer(), "test1", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)],
		addError(|tmp:///User.g|(0, 0, <25, 25>, <30, 30>), "Cannot redefine \"test1\". Already defined in /User.g on line 25", newEnv(|tmp:///|))
	);

test bool shouldGiveDeclareErrorWhenDuplicatingParamsExistUsingDefaultValues() = 
	checkParams([
		param(integer(), "test1", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], 
		param(string(), "test1", string("blah"))[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
	], newEnv(|tmp:///|)) == 
	addDefinition(
		param(integer(), "test1", emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)],
		addError(|tmp:///User.g|(0, 0, <25, 25>, <30, 30>), "Cannot redefine \"test1\". Already defined in /User.g on line 25", newEnv(|tmp:///|))
	);

test bool shouldGiveTypeMismatchErrorWhenMismatchingTypesOnParams() = 
	checkParams([
		param(integer()[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], "test1", boolean(true))[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)]
	], newEnv(|tmp:///|)) == 
	addDefinition(
		param(integer()[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], "test1", boolean(true))[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)],
		addError(|tmp:///User.g|(0, 0, <25, 25>, <30, 30>), typeMismatch(
			integer()[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)],
			boolean()), newEnv(|tmp:///|)
		)
	);

test bool shouldNotGiveTypeMismatchErrorWhenUsingVoidList() = 
	checkParams([
		param(\list(integer()), "test1", \list([]))
	], newEnv(|tmp:///|)) == 
	addDefinition(param(\list(integer()), "test1", \list([])), newEnv(|tmp:///|));
