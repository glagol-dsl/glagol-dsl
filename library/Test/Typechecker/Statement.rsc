module Test::Typechecker::Statement

import Typechecker::Statement;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

test bool shouldNotGiveErrorWhenReturnVoidAndMethodTypeIsVoid() = 
	checkStatement(
		\return(emptyExpr()), 
		voidValue(), 
		method(\public(), string(), "test", [], [], emptyExpr()), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldGiveErrorWhenReturnValueTypeDoesNotMatchMethodReturnType() = 
	checkStatement(
		\return(integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		string(), 
		method(\public(), string(), "test", [], [], emptyExpr()), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Returning integer, string expected", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenReturningValueTypeThatMatchesMethodReturnType() = 
	checkStatement(
		\return(integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		integer(), 
		method(\public(), integer(), "test", [], [], emptyExpr()), newEnv(|tmp:///|)) ==
	newEnv(|tmp:///|);

test bool shouldGiveErrorWhenVariableAsAssignableIsUndefined() = 
	checkAssignable(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenFieldAsAssignableIsUndefined() = 
	checkAssignable(fieldAccess("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenThisFieldAsAssignableIsUndefined() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined", newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenThisFieldAsAssignableIsDefined() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(property(integer(), "a", emptyExpr()), setContext(
		\module(namespace("Test"), [], entity("User", [
			property(integer(), "a", emptyExpr())
		])),
		newEnv(|tmp:///|)))) ==
	addDefinition(property(integer(), "a", emptyExpr()), setContext(
		\module(namespace("Test"), [], entity("User", [
			property(integer(), "a", emptyExpr())
		])),
		newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenThisFieldAsAssignableIsTargettingNonField() = 
	checkAssignable(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined",
		addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenArrayAccessAsAssignableIsUndefined() = 
	checkAssignable(arrayAccess(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot access unknown_type as array",
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined", newEnv(|tmp:///|)));
	
test bool shouldGiveErrorWhenAssigningValueToNonAssignableExpression() = 
	checkAssignable(string("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot assign value to expression", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenAssigningWrongTypeOfValue() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(string(), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot assign value of type integer to a variable of type string",
		addDefinition(param(string(), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|))));
		
test bool shouldNotGiveErrorWhenAssigningEmptyListOnTypedList() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(\list([])))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(\list(integer()), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)))) ==
	addDefinition(param(\list(integer()), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)));
		
test bool shouldNotGiveErrorWhenAssigningEmptyMapOnTypedMap() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(\map(())))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(\map(string(), integer()), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)))) ==
	addDefinition(param(\map(string(), integer()), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)));
		
test bool shouldNotGiveErrorWhenAssigningCorrectTypeOfValue() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		addDefinition(param(integer(), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)))) ==
	addDefinition(param(integer(), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|)));
		
test bool shouldGiveErrorWhenUsingWrongOperator() = 
	checkStatement(assign(variable("a"), productAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), 
		setContext(\module(namespace("Test"), [], emptyDecl()), addDefinition(param(string(), "a", emptyExpr()), newEnv(|tmp:///|)))) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Assignment operator not allowed",
		addDefinition(param(string(), "a", emptyExpr()), setContext(\module(namespace("Test"), [], emptyDecl()), newEnv(|tmp:///|))));

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
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Only entities can be persisted", addImported(\import("User", namespace("Test"), "User"), addToAST(
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
		"Only entities can be flushed", addImported(\import("User", namespace("Test"), "User"), addToAST(
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
		"Only entities can be removed", addImported(\import("User", namespace("Test"), "User"), addToAST(
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
		"Cannot assign string to variable a originally defined as integer", newEnv(|tmp:///|));
		
test bool shouldNotGiveErrorWhenDeclaringVariableWithCorrectDefaultValueType() = 
	checkStatement(declare(string(), variable("a"), expression(string("aaa")))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addDefinition(declare(string(), variable("a"), expression(string("aaa"))), newEnv(|tmp:///|));
	
test bool shouldGiveCannotTraverseErrorWhenUsingNonCollectionWithForeach() = 
	checkStatement(
		foreach(string("ha"), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], emptyStmt(), []), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot traverse string", newEnv(|tmp:///|));
	
test bool shouldGiveConditionShouldBeBooleanErrorWithForeach() = 
	checkStatement(
		foreach(\list([integer(1)]), emptyExpr(), variable("item")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			emptyStmt(), [string("ha")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]]), 
		voidValue(), emptyDecl(), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Condition does not evaluate to boolean",
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
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot use item as value in list traversing: already decleared and is not string",
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
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot use item as value in map traversing: already decleared and is not string",
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
		"Cannot use i as key in list traversing: already decleared and it is not an integer",
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
		"Cannot use i as key in map traversing: already decleared and it is not an integer",
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

test bool shouldGiveErrorWhenBreakingOutFromZeroLevel() = 
	checkStatement(\break(0)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot break out from structure using level 0", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenBreakingOutFromIllegalLevel() = 
	checkStatement(\break(1)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot break out from structure using level 1", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenBreakingOutFromExistingLevel() = 
	checkStatement(\break(1), voidValue(), emptyDecl(), incrementControlLevel(newEnv(|tmp:///|))) == 
	incrementControlLevel(newEnv(|tmp:///|));

test bool shouldGiveErrorWhenContinueOutFromZeroLevel() = 
	checkStatement(\continue(0)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot continue from structure using level 0", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenContinueOutFromIllegalLevel() = 
	checkStatement(\continue(1)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], voidValue(), emptyDecl(), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot continue from structure using level 1", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenContinueOutFromExistingLevel() = 
	checkStatement(\continue(1), voidValue(), emptyDecl(), incrementControlLevel(newEnv(|tmp:///|))) == 
	incrementControlLevel(newEnv(|tmp:///|));

test bool shouldGiveErrorWhenTryingToAssignValueOnAFieldOnNonConstructorInVO() = 
	checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		method(\private(), \any(), "aMethod", [], [], emptyExpr()), addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], valueObject("User", [])), newEnv()))) == 
	addError(|tmp:///User.g|(0,0,<20,20>,<30,30>), "Value objects are immutable. You can only assign property values from the constructor", 
		addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], valueObject("User", [])), newEnv())));
			
test bool shouldNotGiveErrorWhenTryingToAssignValueOnAFieldOnNonConstructorInNonVO() = 
	!hasErrors(checkStatement(assign(variable("a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		method(\private(), \any(), "aMethod", [], [], emptyExpr()), addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], entity("User", [])), newEnv()))));
			
test bool shouldGiveErrorWhenTryingToAssignValueOnThisFieldOnNonConstructorInVO() = 
	checkStatement(assign(fieldAccess(this(), "a"), defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		method(\public(), voidValue(), "setSomething", [], [], emptyExpr()), addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], valueObject("User", [property(integer(), "a", emptyExpr())])), newEnv()))) == 
	addError(|tmp:///User.g|(0,0,<20,20>,<30,30>), "Value objects are immutable. You can only assign property values from the constructor", 
		addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], valueObject("User", [property(integer(), "a", emptyExpr())])), newEnv())));

test bool shouldNotGiveErrorWhenTryingToAssignValueOnThisFieldOnNonConstructorInNonVO() = 
	!hasErrors(checkStatement(assign(fieldAccess(this(), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		method(\private(), \any(), "aMethod", [], [], emptyExpr()), addDefinition(property(integer(), "a", emptyExpr()), 
			setContext(\module(namespace("Test"), [], entity("User", [property(integer(), "a", emptyExpr())])), newEnv()))));

test bool shouldGiveErrorWhenAssigningValueThroughATemporaryVariableFromANonConstructorInVO() = 
	checkStatement(assign(fieldAccess(variable("m"), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		method(\public(), voidValue(), "aMethod", [], [], emptyExpr()), addToAST(
			\module(namespace("Test"), [], valueObject("Money", [])),
			addDefinition(property(integer(), "a", emptyExpr()), addDefinition(
				declare(artifact(external("Money", namespace("Test"), "Money")), variable("m"), emptyStmt()), 
				setContext(\module(namespace("Test"), [], valueObject("Money", [])), newEnv()))))) ==
	addError(|tmp:///User.g|(0,0,<20,20>,<30,30>),"Value objects are immutable. You can only assign property values from the constructor", 
		addToAST(
			\module(namespace("Test"), [], valueObject("Money", [])),
			addDefinition(property(integer(), "a", emptyExpr()), addDefinition(
				declare(artifact(external("Money", namespace("Test"), "Money")), variable("m"), emptyStmt()), 
				setContext(\module(namespace("Test"), [], valueObject("Money", [])), newEnv())))));

test bool shouldNotGiveErrorWhenAssigningValueThroughATemporaryVariableFromAConstructorInVO() = 
	!hasErrors(checkStatement(assign(fieldAccess(variable("m"), "a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], defaultAssign(), expression(integer(1)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], \any(), 
		constructor([], [], emptyExpr()), addToAST(
			\module(namespace("Test"), [], valueObject("Money", [
				property(integer(), "a", emptyExpr())
			])),
			addDefinition(property(integer(), "a", emptyExpr()), addDefinition(
				declare(artifact(external("Money", namespace("Test"), "Money")), variable("m"), emptyStmt()), 
				setContext(\module(namespace("Test"), [], valueObject("Money", [
					property(integer(), "a", emptyExpr())
				])), newEnv()))))));
			
test bool shouldGiveErrorWhenTryingToAssignRepositoryOnThisFieldOnNonConstructorInVO() {

	Statement assignment = assign(
		fieldAccess(this(), "users"), defaultAssign(), expression(variable("users")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
	)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)];

	Declaration parameter = param(repository(external("User", namespace("Test"), "User")), "users", emptyExpr());

	Declaration m = method(\public(), voidValue(), "setUsers", [parameter], [assignment], emptyExpr());
	
	Declaration prop = property(repository(external("User", namespace("Test"), "User")), "users", emptyExpr());
	
	TypeEnv env = setContext(\module(namespace("Test"), [], valueObject("User", [prop, m])), addToAST([
		file(|tmp:///User.g|, \module(namespace("Test"), [], repository("User", []))),
		file(|tmp:///User.g|, \module(namespace("Test"), [], valueObject("User", [prop, m])))
	], addDefinition(parameter, addDefinition(prop, newEnv()))));
	
	return checkStatement(assignment, \any(), m, env) == 
		addError(|tmp:///User.g|(0,0,<20,20>,<30,30>), "Value objects are immutable. You can only assign property values from the constructor", env);
}


