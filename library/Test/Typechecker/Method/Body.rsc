module Test::Typechecker::Method::Body

import Typechecker::Method::Body;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

test bool shouldAddErrorWhenReturnIsNotAvailableOnSubroutineUsingCheckBody() = 
	checkBody([
		ifThenElse(boolean(true), \return(integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], block([
			ifThenElse(boolean(true), block([]), \return(integer(2))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
		]))
	], integer(), method(\public(), integer(), "test", [], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
	entity("User", []), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Return statement with value expected in /User.g for method \'test\' defined on line 20", 
		newEnv(|tmp:///|));

test bool shouldAddErrorWhenReturnIsNotAvailableOnSubroutine() = 
	checkReturnStmtAvailability([
		ifThenElse(boolean(true), \return(variable("a")), block([
			ifThenElse(boolean(true), block([]), \return(variable("a")))
		]))
	], method(\public(), integer(), "test", [], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Return statement with value expected in /User.g for method \'test\' defined on line 20", 
		newEnv(|tmp:///|));
		
test bool shouldNotAddErrorWhenReturnIsAvailableOnSubroutine() = 
	checkReturnStmtAvailability([
		ifThenElse(boolean(true), \return(variable("a")), block([
			ifThenElse(boolean(true), block([\return(variable("a"))]), \return(variable("a")))
		]))
	], method(\public(), integer(), "test", [], [], emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	newEnv(|tmp:///|);

test bool shouldReturnTrueWithDirectReturnStmtAndBranch() = hasReturn([
	ifThenElse(boolean(true), block([]), block([])),
		\return(variable("a"))
	]);
test bool shouldReturnTrueWhenBranchesHaveReturns() = hasReturn([
		ifThenElse(boolean(true), block([\return(variable("a"))]), block([\return(variable("a"))]))
	]);
test bool shouldReturnTrueWhenBranchesHaveDirectReturns() = hasReturn([
		ifThenElse(boolean(true), \return(variable("a")), block([\return(variable("a"))]))
	]);
test bool shouldReturnFalseWhenABranchMissesAReturn() = !hasReturn([
		ifThenElse(boolean(true), block([]), block([\return(variable("a"))]))
	]);
test bool shouldReturnFalseWhenABranchHasVoidReturn() = !hasReturn([
		ifThenElse(boolean(true), \return(emptyExpr()), block([\return(variable("a"))]))
	]);
test bool shouldReturnTrueWithDirectReturnStmt() = hasReturn([\return(variable("a"))]);
test bool shouldReturnFlaseWhenReturnIsEmptyStmt() = !hasReturn([\return(emptyExpr())]);

test bool shouldReturnTrueNestedBranchesAllHaveReturns() = hasReturn([
		ifThenElse(boolean(true), \return(variable("a")), block([
			ifThenElse(boolean(true), \return(variable("a")), \return(variable("a")))
		]))
	]);
