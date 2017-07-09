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
	
test bool shouldGiveErrorWhenAssigningValueToNonAssignableExpression() = 
	checkAssignable(string("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot assign value to expression in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenAssigningWrongTypeOfValue() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(string(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot assign value of type integer to a variable of type string in /User.g on line 20", 
		addDefinition(param(string(), "a", emptyExpr()), newEnv(|tmp:///|)));
test bool shouldNotGiveErrorWhenAssigningEmptyListOnTypedList() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(\list([])))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(\list(integer()), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(\list(integer()), "a", emptyExpr()), newEnv(|tmp:///|));
		
test bool shouldNotGiveErrorWhenAssigningEmptyMapOnTypedMap() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(\map(())))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(\map(string(), integer()), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(\map(string(), integer()), "a", emptyExpr()), newEnv(|tmp:///|));
		
test bool shouldNotGiveErrorWhenAssigningCorrectTypeOfValue() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|));
		
test bool shouldGiveErrorWhenUsingWrongOperator() = 
	checkStatement(assign(variable("a"), productAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(string(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Assignment operator not allowed in /User.g on line 20", 
		addDefinition(param(string(), "a", emptyExpr()), newEnv(|tmp:///|)));

test bool shouldGiveErrorWhenConditionIsNotBoolean() = 
	checkCondition(string("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Condition does not evaluate to boolean in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenConditionIsBoolean() = 
	checkCondition(boolean(true)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldNotGiveErrorWhenTryingToPersistAnEntity() = 
	checkStatement(persist(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	);
	
test bool shouldGiveErrorWhenTryingToPersistANonEntity() = 
	checkStatement(persist(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Only entities can be persisted in /User.g on line 20", addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	));

test bool shouldNotGiveErrorWhenTryingToFlushAnEntity() = 
	checkStatement(flush(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	);
	
test bool shouldGiveErrorWhenTryingToFlushANonEntity() = 
	checkStatement(flush(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Only entities can be flushed in /User.g on line 20", addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	));

test bool shouldNotGiveErrorWhenTryingToRemoveAnEntity() = 
	checkStatement(remove(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	);
	
test bool shouldGiveErrorWhenTryingToRemoveANonEntity() = 
	checkStatement(remove(new(local("User"), []))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addImported(\import("User", namespace("Test"), "User"), addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
			setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Only entities can be removed in /User.g on line 20", addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), 
		setContext(\module(namespace("Test"), [], repository("User", [])), newEnv(|tmp:///|)))
	));

test bool shouldNotGiveErrorWhenDeclaringVariableOfTypeListWithVoidListAsDefaultValue() = 
	checkStatement(declare(\list(integer()), variable("a"), expression(\list([]))), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addDefinition(declare(\list(integer()), variable("a"), expression(\list([]))), newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenDeclaringVariableOfTypeListWithVoidMapAsDefaultValue() = 
	checkStatement(declare(\map(string(), integer()), variable("a"), expression(\map(()))), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addDefinition(declare(\map(string(), integer()), variable("a"), expression(\map(()))), newEnv(|tmp:///|));

test bool shouldGiveErrorWhenDeclaringVariableWithWrongDefaultValueType() = 
	checkStatement(declare(integer(), variable("a"), expression(string("aaa")))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot assign string to variable a originally defined as integer in /User.g on line 20", newEnv(|tmp:///|));
		
test bool shouldNotGiveErrorWhenDeclaringVariableWithCorrectDefaultValueType() = 
	checkStatement(declare(string(), variable("a"), expression(string("aaa")))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addDefinition(declare(string(), variable("a"), expression(string("aaa"))), newEnv(|tmp:///|));
	
test bool shouldGiveCannotTraverseErrorWhenUsingNonCollectionWithForeach() = 
	checkStatement(
		foreach(string("ha"), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot traverse string in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveConditionShouldBeBooleanErrorWithForeach() = 
	checkStatement(
		foreach(\list([integer(1)]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			emptyStmt(), [string("ha")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Condition does not evaluate to boolean in /User.g on line 20", 
		addDefinition(declare(integer(), variable("item"), emptyStmt()), newEnv(|tmp:///|)));
		
test bool shouldNotGiveConditionShouldBeBooleanErrorWithForeach() = 
	checkStatement(
		foreach(\list([integer(1)]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			emptyStmt(), [boolean(false)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(integer(), variable("item"), emptyStmt()), newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenUsingValueForTraversingWhichIsAlreadyDefinedWithDifferentType() = 
	checkStatement(
		foreach(\list([string("s")]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(integer(), "item", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot use item as value in list traversing: already decleared and is not string in /User.g on line 20", 
		addDefinition(param(integer(), "item", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldNotGiveErrorWhenUsingValueForTraversingWhichIsAlreadyDefinedWithSameType() = 
	checkStatement(
		foreach(\list([string("s")]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(string(), "item", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(string(), "item", emptyExpr()), newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenUsingValueForTraversingWhichIsNotDefinedYet() = 
	checkStatement(
		foreach(\list([string("s")]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenUsingValueForTraversingWhichIsAlreadyDefinedWithDifferentTypeOnMap() = 
	checkStatement(
		foreach(\map((string("s"): string("b"))), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(integer(), "item", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot use item as value in map traversing: already decleared and is not string in /User.g on line 20", 
		addDefinition(param(integer(), "item", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldNotGiveErrorWhenUsingValueForTraversingWhichIsAlreadyDefinedWithSameTypeOnMap() = 
	checkStatement(
		foreach(\map((string("s"): string("dass"))), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(string(), "item", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(string(), "item", emptyExpr()), newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenUsingValueForTraversingWhichIsNotDefinedYetOnMap() = 
	checkStatement(
		foreach(\map((string("s"): string("dassaddas"))), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenUsingNoKeyOnListTraversing() = 
	checkStatement(
		foreach(\list([string("das")]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), newEnv(|tmp:///|));

test bool shouldGiveErrorWhenUsingAlreadyDefinedKeyOnListTraversingAndItIsNotInteger() = 
	checkStatement(
		foreach(\list([string("das")]), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(string(), "i", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot use i as key in list traversing: already decleared and it is not an integer in /User.g on line 20", 
		addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(param(string(), "i", emptyExpr()), newEnv(|tmp:///|))));

test bool shouldNotGiveErrorWhenUsingAlreadyDefinedKeyOnListTraversingAndItIsInteger() = 
	checkStatement(
		foreach(\list([string("das")]), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(integer(), "i", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(param(integer(), "i", emptyExpr()), newEnv(|tmp:///|)));

test bool shouldNotGiveErrorWhenUsingNotDefinedKeyOnListTraversing() = 
	checkStatement(
		foreach(\list([string("das")]), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(declare(integer(), variable("i"), emptyStmt()), newEnv(|tmp:///|)));
		
test bool shouldGiveErrorWhenUsingAlreadyDefinedKeyOnMapTraversingAndItIsNotMapDefinedKeyType() = 
	checkStatement(
		foreach(\map((integer(3): string("das"))), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(string(), "i", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot use i as key in map traversing: already decleared and it is not an integer in /User.g on line 20", 
		addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(param(string(), "i", emptyExpr()), newEnv(|tmp:///|))));

test bool shouldNotGiveErrorWhenUsingAlreadyDefinedKeyOnMapTraversingAndItIsMapDefinedKeyType() = 
	checkStatement(
		foreach(\map((integer(3): string("das"))), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), addDefinition(param(integer(), "i", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(param(integer(), "i", emptyExpr()), newEnv(|tmp:///|)));

test bool shouldNotGiveErrorWhenUsingNotDefinedKeyOnMapTraversing() = 
	checkStatement(
		foreach(\map((integer(3): string("das"))), 
			variable("i")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addDefinition(declare(string(), variable("item"), emptyStmt()), 
		addDefinition(declare(integer(), variable("i"), emptyStmt()), newEnv(|tmp:///|)));

	
