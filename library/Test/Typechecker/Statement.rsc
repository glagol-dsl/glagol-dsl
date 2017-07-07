module Test::Typechecker::Statement

import Typechecker::Statement;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

test bool shouldGiveErrorWhenReturnValueTypeDoesNotMatchMethodReturnType() = 
	checkStatement(
		\return(integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		string(), 
		method(\public(), string(), "test", [], [], emptyExpr()), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Returning integer, string expected in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenReturningValueTypeThatMatchesMethodReturnType() = 
	checkStatement(
		\return(integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		integer(), 
		method(\public(), integer(), "test", [], [], emptyExpr()), newEnv(|tmp:///|)) ==
	newEnv(|tmp:///|);

test bool shouldGiveErrorWhenVariableAsAssignableIsUndefined() = 
	checkAssignable(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenFieldAsAssignableIsUndefined() = 
	checkAssignable(fieldAccess("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenThisFieldAsAssignableIsUndefined() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenThisFieldAsAssignableIsDefined() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(property(integer(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(property(integer(), "a", emptyExpr()), newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenThisFieldAsAssignableIsTargettingNonField() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", 
		addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenArrayAccessAsAssignableIsUndefined() = 
	checkAssignable(arrayAccess(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot access unknown type as array in /User.g on line 20", 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenArrayAccessAsAssignableIsUndefined() = 
	checkAssignable(arrayAccess(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot access unknown type as array in /User.g on line 20", 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenAssigningValueToNonAssignableExpression() = 
	checkAssignable(string("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot assign value to expression in /User.g on line 20", newEnv(|tmp:///|));
	
	
