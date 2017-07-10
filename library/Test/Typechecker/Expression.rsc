module Test::Typechecker::Expression

import Typechecker::Expression;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

// new artifact instances
test bool shouldGiveErrorWhenLocalArtifactIsUsedButNotImported() =
	checkExpression(new(local("User"), [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Artifact User used but not imported in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenCreatingNewUtil() = 
	checkExpression(
		new(local("User"), [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			addImported(\import("User", namespace("Example"), "User"), setContext(
				\module(namespace("Example"), [], util("User", [])),
				addToAST(file(|tmp:///|, \module(namespace("Example"), [], util("User", []))), newEnv(|tmp:///|))
			)
	)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot instantiate artifact Example::User: only entities and value objects can be instantiated in /User.g on line 20", 
		addImported(\import("User", namespace("Example"), "User"), setContext(
			\module(namespace("Example"), [], util("User", [])),
			addToAST(file(|tmp:///|, \module(namespace("Example"), [], util("User", []))), newEnv(|tmp:///|)))
		)
	);
	
test bool shouldNotGiveErrorWhenCreatingNewEntity() = 
	checkExpression(
		new(local("User"), [])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
			addImported(\import("User", namespace("Example"), "User"), setContext(
				\module(namespace("Example"), [], entity("User", [])),
				addToAST(file(|tmp:///|, \module(namespace("Example"), [], entity("User", []))), newEnv(|tmp:///|))
			)
	)) == 
	addImported(\import("User", namespace("Example"), "User"), setContext(
		\module(namespace("Example"), [], entity("User", [])),
		addToAST(file(|tmp:///|, \module(namespace("Example"), [], entity("User", []))), newEnv(|tmp:///|)))
	);

test bool shouldGiveErrorWhenTernaryConditionIsNotBoolean() = 
	checkExpression(ifThenElse(string("dassad")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], integer(1), integer(2)), newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Condition does not evaluate to boolean in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenTernaryConditionIsBoolean() = 
	checkExpression(ifThenElse(boolean(true), integer(1), integer(2)), newEnv(|tmp:///|)) == 
	newEnv(|tmp:///|);
	
test bool shouldGiveErrorWhenTernarySidesAreDifferentTypes() = 
	checkExpression(ifThenElse(boolean(true), float(1.2), integer(2))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Ternary cannot return different types in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenTernarySidesAreEmptyListAndTypedList() = 
	checkExpression(ifThenElse(boolean(true), \list([integer(1)]), \list([])), newEnv(|tmp:///|)) == 
	newEnv(|tmp:///|);
	
test bool shouldNotGiveErrorWhenTernarySidesAreEmptyMapAndTypedMap() = 
	checkExpression(ifThenElse(boolean(true), \map((integer(1): integer(1))), \map(())), newEnv(|tmp:///|)) == 
	newEnv(|tmp:///|);
	
test bool shouldGiveErrorWhenTernarySidesAreDifferentlyTypedMaps() = 
	checkExpression(
		ifThenElse(boolean(true), \map((integer(1): integer(1))), \map((integer(1): float(1.2))))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Ternary cannot return different types in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenConditionIsNotBoolean() = 
	checkCondition(string("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Condition does not evaluate to boolean in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenConditionIsBoolean() = 
	checkCondition(boolean(true)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		newEnv(|tmp:///|)) == newEnv(|tmp:///|);

// Check binary math operations
test bool shouldGiveErrorWhenApplyingProductOnUnknownType() = 
	checkExpression(product(emptyExpr(), emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot apply multiplication on unknown type in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenApplyingProductOnWrongTypes() = 
	checkExpression(product(string("dsadsadsa"), boolean(true))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot apply multiplication on string and bool in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenComparingIntegers() = 
	checkExpression(greaterThanOrEq(integer(3), integer(5)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
	
test bool shouldGiveErrorWhenComparingIntegerAndString() = 
	checkExpression(greaterThanOrEq(integer(3), string("asd"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot compare integer and string in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenComparingStringAndString() = 
	checkExpression(greaterThanOrEq(string("dd"), string("asd"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot compare string and string in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenComparingStringAndString() = 
	checkExpression(equals(string("dd"), string("asd"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	newEnv(|tmp:///|);
	
test bool shouldNotGiveErrorWhenApplyingLogicalAndOnBooleans() = checkExpression(and(boolean(true), boolean(false)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);	
test bool shouldGiveErrorWhenApplyingLogicalAndOnBooleanAndInteger() = 
	checkExpression(and(boolean(true), integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot apply logical operation on bool and integer in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenApplyingLogicalOrOnBooleans() = checkExpression(or(boolean(true), boolean(false)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);	
test bool shouldGiveErrorWhenApplyingLogicalOrOnBooleanAndInteger() = 
	checkExpression(or(boolean(true), integer(1))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Cannot apply logical operation on bool and integer in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenApplyingNegativeOnInteger() = checkExpression(negative(integer(2))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorWhenApplyingNegativeOnFloat() = checkExpression(negative(float(2.4)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorWhenApplyingPositiveOnInteger() = checkExpression(positive(integer(2)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorWhenApplyingPositiveOnFloat() = checkExpression(positive(float(2.4)), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldGiveErrorWhenApplyingNegativeOnString() = 
	checkExpression(negative(string("2.4"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot apply minus on string in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenApplyingPositiveOnString() = 
	checkExpression(positive(string("2.4"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot apply plus on string in /User.g on line 20", newEnv(|tmp:///|));

// Check lists
test bool shouldNotGiveErrorWhenCheckingEmptyList() = 
	checkExpression(\list([]), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
	
test bool shouldGiveErrorOnListOfUnknownType() = 
	checkExpression(\list([integer(1), string("a")])[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot unveil list type in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldNotGiveErrorWhenCheckingCorrectlyTypedList() = 
	checkExpression(\list([integer(1), integer(2)]), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

// Check maps
test bool shouldNotGiveErrorWhenCheckingEmptyMap() = checkExpression(\map(()), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
	
test bool shouldGiveErrorOnMapOfUnknownTypeAsKey() = 
	checkExpression(\map((integer(1): string("a"), string("d"): string("a")))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot unveil map key type in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorOnMapOfUnknownTypeAsValue() = 
	checkExpression(\map((integer(1): string("a"), integer(2): integer(5)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot unveil map value type in /User.g on line 20", newEnv(|tmp:///|));
	
test bool shouldGiveErrorOnMapOfUnknownTypeAsValueAndKey() = 
	checkExpression(\map((boolean(true): string("a"), integer(2): integer(5)))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot unveil map key and value types in /User.g on line 20", newEnv(|tmp:///|));

// check scalars
test bool shouldNotGiveErrorOnIntegers() = checkExpression(integer(1), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorOnFloats() = checkExpression(float(1.2), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorOnStrings() = checkExpression(string("dsadsa"), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
test bool shouldNotGiveErrorOnBooleans() = checkExpression(boolean(true), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

// Check array access
test bool shouldGiveErrorWhenUnknownTypeIsUsedAsKeyForArrayAccess() = 
	checkIndexKey(unknownType(), emptyExpr()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Type of array index key used cannot be determined in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldGiveErrorWhenVoidTypeIsUsedAsKeyForArrayAccess() = 
	checkIndexKey(voidValue(), emptyExpr()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Void cannot be used as array index key in /User.g on line 20", newEnv(|tmp:///|));

test bool shouldNotGiveErrorWhenNormalTypeIsUsedAsKeyForArrayAccess() = 
	checkIndexKey(integer(), emptyExpr()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldGiveErrorWhenTryingToAccessListUsingNonInteger() = 
	checkExpression(arrayAccess(variable("a"), string("key"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(\list(string()), "a", emptyExpr()), newEnv(|tmp:///|))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"List cannot be accessed using string, only integers allowed in /User.g on line 20", 
		addDefinition(param(\list(string()), "a", emptyExpr()), newEnv(|tmp:///|)));
		
test bool shouldNotGiveErrorWhenTryingToAccessListUsingInteger() = 
	checkExpression(arrayAccess(variable("a"), integer(4))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(\list(string()), "a", emptyExpr()), newEnv(|tmp:///|))) ==  
	addDefinition(param(\list(string()), "a", emptyExpr()), newEnv(|tmp:///|));
		
test bool shouldGiveErrorWhenTryingToAccessMapUsingWrongType() = 
	checkExpression(arrayAccess(variable("a"), string("key"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(\map(float(), integer()), "a", emptyExpr()), newEnv(|tmp:///|))) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		"Map key type is float, cannot access using string in /User.g on line 20", 
		addDefinition(param(\map(float(), integer()), "a", emptyExpr()), newEnv(|tmp:///|)));

test bool shouldNotGiveErrorWhenTryingToAccessMapUsingCorrectType() = 
	checkExpression(arrayAccess(variable("a"), string("key"))[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		addDefinition(param(\map(string(), integer()), "a", emptyExpr()), newEnv(|tmp:///|))) == 
	addDefinition(param(\map(string(), integer()), "a", emptyExpr()), newEnv(|tmp:///|));

// Check variable definition
test bool shouldNotGiveErrorWhenCheckAlreadyDefinedVariable() = 
	checkIsVariableDefined(variable("a"), addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|))) ==
	addDefinition(param(integer(), "a", emptyExpr()), newEnv(|tmp:///|));
	
test bool shouldGiveErrorWhenCheckUndefinedVariable() = 
	checkIsVariableDefined(variable("a")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "\'a\' is undefined in /User.g on line 20", newEnv(|tmp:///|));

// Lookup literal types
test bool shouldReturnIntegerWhenLookingUpTypeForIntegerLiteral() = integer() == lookupType(integer(5), newEnv(|tmp:///|));
test bool shouldReturnFloatWhenLookingUpTypeForFloatLiteral() = float() == lookupType(float(5.3), newEnv(|tmp:///|));
test bool shouldReturnStringWhenLookingUpTypeForStringLiteral() = string() == lookupType(string("dasads"), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenLookingUpTypeForBooleanTrueLiteral() = boolean() == lookupType(boolean(true), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenLookingUpTypeForBooleanFalseLiteral() = boolean() == lookupType(boolean(true), newEnv(|tmp:///|));

// Lookup list types
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForLists() = 
    \list(integer()) == lookupType(\list([integer(5)]), newEnv(|tmp:///|));
    
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForTwoMemberLists() = 
    \list(integer()) == lookupType(\list([integer(5), integer(6)]), newEnv(|tmp:///|));

test bool shouldReturnUnknownTypeWhenLookingUpTypeForListWithDifferentValueTypes() = 
    \list(unknownType()) == lookupType(\list([integer(5), string("dassd")]), newEnv(|tmp:///|));
    
test bool shouldReturnUnTypeWhenLookingUpTypeForListWithDifferentValueTypes2() = 
    \list(unknownType()) == lookupType(\list([string("dasdsa"), float(445.23)]), newEnv(|tmp:///|));
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForListNoElements() = 
    \list(voidValue()) == lookupType(\list([]), newEnv(|tmp:///|));
    
// Lookup map types
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForMaps() = 
    \map(string(), integer()) == lookupType(\map((string("key1"): integer(5))), newEnv(|tmp:///|));
    
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForTwoMemberMaps() = 
    \map(string(), integer()) == lookupType(\map((string("key1"): integer(5), string("key2"): integer(6))), newEnv(|tmp:///|));

test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes() = 
    \map(string(), unknownType()) == lookupType(\map((string("key1"): integer(5), string("key2"): string("dassd"))), newEnv(|tmp:///|));
    
test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes2() = 
    \map(string(), unknownType()) == lookupType(\map((string("key1"): string("dasdsa"), string("key2"): float(445.23))), newEnv(|tmp:///|));
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForMapNoElements() = 
    \map(voidValue(), voidValue()) == lookupType(\map(()), newEnv(|tmp:///|));

// Lookup array access 
test bool shouldReturnIntegerTypeFromAListUsingIndexToAccessIt() = 
    integer() == lookupType(arrayAccess(\list([integer(5), integer(4)]), integer(0)), newEnv(|tmp:///|));
    
test bool shouldReturnListStrTypeFromAListUsingIndexToAccessIt() = 
    \list(string()) == lookupType(arrayAccess(\list([\list([string("blah"), string("blah2")]), \list([string("blah3")])]), integer(0)), newEnv(|tmp:///|));

test bool shouldReturnUnknownTypeWhenTryingToAccessNonArray() = 
    unknownType() == lookupType(arrayAccess(integer(5), integer(0)), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeFromAMapUsingIndexToAccessIt() = 
    integer() == lookupType(arrayAccess(\map((string("first"): integer(5), string("second"): integer(4))), string("second")), newEnv(|tmp:///|));

// Variables
test bool shouldReturnUnknownTypeForVariableThatIsNotInEnv() =
    unknownType() == lookupType(variable("myVar"), newEnv(|tmp:///|));

test bool shouldReturnStringTypeForLocalVariableThatIsInEnv() =
    string() == lookupType(variable("myVar"), addDefinition(declare(string(), variable("myVar"), emptyStmt()), newEnv(|tmp:///|)));
    
test bool shouldReturnStringTypeForFieldPropertyThatIsInEnv() =
    integer() == lookupType(variable("myVar"), addDefinition(property(integer(), "myVar", emptyExpr()), newEnv(|tmp:///|)));
    
test bool shouldReturnStringTypeForParamThatIsInEnv() =
    float() == lookupType(variable("myVar"), addDefinition(param(float(), "myVar", emptyExpr()), newEnv(|tmp:///|)));

test bool shouldReturnIntegerTypeForIntegerInBrackets() = integer() == lookupType(\bracket(integer(12)), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeForProductOfIntegers() = integer() == lookupType(product(integer(23), integer(33)), newEnv(|tmp:///|));
test bool shouldReturnFloatTypeForProductOfFloats() = float() == lookupType(product(float(23.22), float(33.33)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeForProductOfStrings() = unknownType() == lookupType(product(string("adsdassda"), string("adsadsads")), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeForRemainderOfIntegers() = integer() == lookupType(remainder(integer(23), integer(33)), newEnv(|tmp:///|));
test bool shouldReturnFloatTypeForRemainderOfFloats() = float() == lookupType(remainder(float(23.22), float(33.33)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeForRemainderOfStrings() = unknownType() == lookupType(remainder(string("adsdassda"), string("adsadsads")), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeForDivOfIntegers() = integer() == lookupType(division(integer(23), integer(33)), newEnv(|tmp:///|));
test bool shouldReturnFloatTypeForDivOfFloats() = float() == lookupType(division(float(23.22), float(33.33)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeForDivOfStrings() = unknownType() == lookupType(division(string("adsdassda"), string("adsadsads")), newEnv(|tmp:///|));

test bool shoudReturnStringTypeForAddOfStrings() = string() == lookupType(addition(string("test"), string("test")), newEnv(|tmp:///|));
test bool shoudReturnIntegerTypeForAddOfIntegers() = integer() == lookupType(addition(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shoudReturnFloatTypeForAddOfFloats() = float() == lookupType(addition(float(1.2), float(2.2)), newEnv(|tmp:///|));

test bool shoudReturnUnknownTypeForAddOfFloatAndInt() = float() == lookupType(addition(float(1.2), integer(2)), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeForSubOfIntegers() = integer() == lookupType(subtraction(integer(23), integer(33)), newEnv(|tmp:///|));
test bool shouldReturnFloatTypeForSubOfFloats() = float() == lookupType(subtraction(float(23.22), float(33.33)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeForSubOfStrings() = unknownType() == lookupType(subtraction(string("adsdassda"), string("adsadsads")), newEnv(|tmp:///|));

test bool shouldReturnBoolWhenComparingGTEOfIntegers() = boolean() == lookupType(greaterThanOrEq(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTEOfIntegerAndFloat() = boolean() == lookupType(greaterThanOrEq(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTEOfFloats() = boolean() == lookupType(greaterThanOrEq(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTEOfFloatAndInteger() = boolean() == lookupType(greaterThanOrEq(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTEOfFloatAndBoolean() = unknownType() == lookupType(greaterThanOrEq(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTEOfFloatAndString() = unknownType() == lookupType(greaterThanOrEq(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndFloat() = unknownType() == lookupType(greaterThanOrEq(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndString() = unknownType() == lookupType(greaterThanOrEq(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndInteger() = unknownType() == lookupType(greaterThanOrEq(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBoolWhenComparingLTEOfIntegers() = boolean() == lookupType(lessThanOrEq(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTEOfIntegerAndFloat() = boolean() == lookupType(lessThanOrEq(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTEOfFloats() = boolean() == lookupType(lessThanOrEq(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTEOfFloatAndInteger() = boolean() == lookupType(lessThanOrEq(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTEOfFloatAndBoolean() = unknownType() == lookupType(lessThanOrEq(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTEOfFloatAndString() = unknownType() == lookupType(lessThanOrEq(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndFloat() = unknownType() == lookupType(lessThanOrEq(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndString() = unknownType() == lookupType(lessThanOrEq(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndInteger() = unknownType() == lookupType(lessThanOrEq(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBoolWhenComparingLTOfIntegers() = boolean() == lookupType(lessThan(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTOfIntegerAndFloat() = boolean() == lookupType(lessThan(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTOfFloats() = boolean() == lookupType(lessThan(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingLTOfFloatAndInteger() = boolean() == lookupType(lessThan(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTOfFloatAndBoolean() = unknownType() == lookupType(lessThan(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTOfFloatAndString() = unknownType() == lookupType(lessThan(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndFloat() = unknownType() == lookupType(lessThan(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndString() = unknownType() == lookupType(lessThan(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndInteger() = unknownType() == lookupType(lessThan(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBoolWhenComparingGTOfIntegers() = boolean() == lookupType(greaterThan(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTOfIntegerAndFloat() = boolean() == lookupType(greaterThan(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTOfFloats() = boolean() == lookupType(greaterThan(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingGTOfFloatAndInteger() = boolean() == lookupType(greaterThan(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTOfFloatAndBoolean() = unknownType() == lookupType(greaterThan(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTOfFloatAndString() = unknownType() == lookupType(greaterThan(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndFloat() = unknownType() == lookupType(greaterThan(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndString() = unknownType() == lookupType(greaterThan(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndInteger() = unknownType() == lookupType(greaterThan(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBooleanWhenComparingEQOfStrings() = boolean() == lookupType(equals(string("dasda"), string("dads")), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenComparingEQOfIntegers() = boolean() == lookupType(equals(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenComparingEQOfIntegerAndFloat() = boolean() == lookupType(equals(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenComparingEQOfFloats() = boolean() == lookupType(equals(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBooleanWhenComparingEQOfFloatAndInteger() = boolean() == lookupType(equals(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeWhenComparingEQOfFloatAndBoolean() = unknownType() == lookupType(equals(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeWhenComparingEQOfFloatAndString() = unknownType() == lookupType(equals(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndFloat() = unknownType() == lookupType(equals(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndString() = unknownType() == lookupType(equals(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndInteger() = unknownType() == lookupType(equals(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBoolWhenComparingNonEQOfStrings() = boolean() == lookupType(nonEquals(string("dasda"), string("dads")), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingNonEQOfIntegers() = boolean() == lookupType(nonEquals(integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingNonEQOfIntegerAndFloat() = boolean() == lookupType(nonEquals(integer(1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingNonEQOfFloats() = boolean() == lookupType(nonEquals(float(1.2), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBoolWhenComparingNonEQOfFloatAndInteger() = boolean() == lookupType(nonEquals(float(1.2), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingNonEQOfFloatAndBoolean() = unknownType() == lookupType(nonEquals(float(1.2), boolean(true)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingNonEQOfFloatAndString() = unknownType() == lookupType(nonEquals(float(1.2), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndFloat() = unknownType() == lookupType(nonEquals(boolean(true), float(1.2)), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndString() = unknownType() == lookupType(nonEquals(boolean(false), string("s")), newEnv(|tmp:///|));
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndInteger() = unknownType() == lookupType(nonEquals(boolean(false), integer(3)), newEnv(|tmp:///|));

test bool shouldReturnBooleanTypeOnConjunctionOfBooleans() = boolean() == lookupType(and(boolean(true), boolean(false)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnConjunctionOfNonBooleans() = unknownType() == lookupType(and(boolean(true), integer(1)), newEnv(|tmp:///|));

test bool shouldReturnBooleanTypeOnDisjunctionOfBooleans() = boolean() == lookupType(or(boolean(true), boolean(false)), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnDisjunctionOfNonBooleans() = unknownType() == lookupType(or(boolean(true), integer(1)), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeOnPositiveInteger() = integer() == lookupType(positive(integer(2)), newEnv(|tmp:///|));
test bool shouldReturnIntegerTypeOnPositiveFloat() = float() == lookupType(positive(float(2.2)), newEnv(|tmp:///|));

test bool shouldReturnIntegerTypeOnNegativeInteger() = integer() == lookupType(negative(integer(2)), newEnv(|tmp:///|));
test bool shouldReturnIntegerTypeOnNegativeFloat() = float() == lookupType(negative(float(2.2)), newEnv(|tmp:///|));

test bool shouldReturnIntegerOnTernaryOfIntegers() = integer() == lookupType(ifThenElse(boolean(true), integer(1), integer(2)), newEnv(|tmp:///|));
test bool shouldReturnFloatOnTernaryOfFloats() = float() == lookupType(ifThenElse(boolean(true), float(1.1), float(2.2)), newEnv(|tmp:///|));
test bool shouldReturnBooleanOnTernaryOfBooleans() = boolean() == lookupType(ifThenElse(boolean(true), boolean(true), boolean(false)), newEnv(|tmp:///|));
test bool shouldReturnStringOnTernaryOfStrings() = string() == lookupType(ifThenElse(boolean(true), string("s"), string("b")), newEnv(|tmp:///|));
test bool shouldReturnListOnTernaryOfLists() = \list(integer()) == lookupType(ifThenElse(boolean(true), \list([integer(1), integer(2)]), \list([integer(3), integer(4)])), newEnv(|tmp:///|));
test bool shouldReturnMapOnTernaryOfMaps() = 
    \map(integer(), string()) == lookupType(ifThenElse(boolean(true), \map((integer(1): string("s"))), \map((integer(2): string("s")))), newEnv(|tmp:///|));

test bool shouldReturnArtifactOnTernaryOfSameArtifacts() = 
    artifact(external("User", namespace("Test"), "User")) == lookupType(ifThenElse(boolean(true), get(artifact(local("User"))), get(artifact(local("User")))), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))),
		setContext(\module(namespace("Test"), [], util("User", [])), newEnv(|tmp:///|)))));
test bool shouldReturnUnknownTypeOnTernaryOfDifferentArtifacts() = 
    unknownType() == lookupType(ifThenElse(boolean(true), get(artifact(local("User"))), get(artifact(local("Customer")))), newEnv(|tmp:///|));
test bool shouldReturnRepositoryOnTernaryOfSameRepositories() = 
    repository(external("User", namespace("Test"), "User")) == lookupType(ifThenElse(boolean(true), get(repository(local("User"))), get(repository(local("User")))), 
    	setContext(\module(namespace("Test"), [], util("UserService", [])), addToAST(
    		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///|))));
test bool shouldReturnUnknownTypeOnTernaryOfDifferentRepositories() = 
    unknownType() == lookupType(ifThenElse(boolean(true), get(repository(local("User"))), get(repository(local("Customer")))), newEnv(|tmp:///|));
test bool shouldReturnUnTypeOnDifferentTypes() = 
    unknownType() == lookupType(ifThenElse(boolean(true), integer(2), get(artifact(local("User")))), newEnv(|tmp:///|));

@doc{
Test creating artifacts (VO and entities) locally and externally (imported)
}
test bool shouldReturnUnknownTypeOnNewNotImported() = unknownType() == lookupType(new(local("User"), []), newEnv(|tmp:///|));
test bool shouldReturnArtifactTypeOnNewInContext() = artifact(external("User", namespace("Example"), "User")) == lookupType(new(local("User"), []), setContext(
	\module(namespace("Example"), [], entity("User", [])),
	addToAST(file(|tmp:///|, \module(namespace("Example"), [], entity("User", []))), newEnv(|tmp:///|))));
	
test bool shouldReturnArtifactTypeOnNewExternal() = artifact(external("User", namespace("Example"), "User")) == 
	lookupType(new(external("User", namespace("Example"), "User"), []), 
	addToAST(file(|tmp:///|, \module(namespace("Example"), [], entity("User", []))), newEnv(|tmp:///|)));
	
test bool shouldReturnArtifactTypeOnNewExternalValueObject() = artifact(external("User", namespace("Example"), "User")) == 
	lookupType(new(external("User", namespace("Example"), "User"), []), 
	addToAST(file(|tmp:///|, \module(namespace("Example"), [], valueObject("User", []))), newEnv(|tmp:///|)));
	
test bool shouldReturnUnknownTypeOnNewExternalThatIsNotInAST() = unknownType() == 
	lookupType(new(external("User", namespace("Example"), "User"), []), newEnv(|tmp:///|));
	
test bool shouldReturnUnknownTypeOnNewExternalThatIsNotAnEntity() = unknownType() == 
	lookupType(new(external("User", namespace("Example"), "User"), []), 
	addToAST(file(|tmp:///|, \module(namespace("Example"), [], util("User", []))), newEnv(|tmp:///|)));

@doc{
Test getting artifacts locally and internally
}
test bool shouldReturnUnknownTypeOnGetUnimportedArtifact() = 
	unknownType() == lookupType(get(artifact(local("User"))), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetArtifactWhichIsEntity() = 
	unknownType() == lookupType(get(artifact(local("User"))), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
		newEnv(|tmp:///|))));
test bool shouldReturnArtifactTypeOnGetArtifactWhichIsUtil() = 
	artifact(external("User", namespace("Test"), "User")) == lookupType(get(artifact(local("User"))), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))),
		setContext(\module(namespace("Test"), [], entity("Customer", [])), newEnv(|tmp:///|)))));
		
test bool shouldReturnUnknownTypeOnGetArtifactWhichIsValueObject() = 
	unknownType() == lookupType(get(artifact(local("User"))), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], valueObject("User", []))),
		newEnv(|tmp:///|))));

test bool shouldReturnArtifactTypeOnGetExternalArtifact() = 
	artifact(external("User", namespace("Test"), "User")) == lookupType(get(artifact(external("User", namespace("Test"), "User"))), 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
    		file(|tmp:///|, \module(namespace("Test"), [], util("User", []))),
    	newEnv(|tmp:///|))));

test bool shouldReturnUnknownTypeOnGetExternalArtifactThatIsNotEntity() = 
	unknownType() == lookupType(get(artifact(external("User", namespace("Test"), "User"))), 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
    		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///|))));


test bool shouldReturnUnknownTypeOnGetLocalRepositoryWithMissingEntity() = 
	unknownType() == lookupType(get(repository(local("User"))), newEnv(|tmp:///|));

test bool shouldReturnRepositoryTypeOnGetRepository() = 
	repository(external("User", namespace("Test"), "User")) == lookupType(get(repository(local("User"))), 
	setContext(\module(namespace("Test"), [], util("UserService", [])), addToAST(
    		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///|))));
    	
test bool shouldReturnRepositoryTypeOnGetExternalRepository() = 
	repository(external("User", namespace("Test"), "User")) == lookupType(get(repository(external("User", namespace("Test"), "User"))), 
	addImported(\import("User", namespace("Test"), "User"), addToAST(
    		file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))),
    	newEnv(|tmp:///|))));

test bool shouldReturnSelfieTypeOnGetSelfie() = selfie() == lookupType(get(selfie()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetVoid() = unknownType() == lookupType(get(voidValue()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetString() = unknownType() == lookupType(get(string()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetFloat() = unknownType() == lookupType(get(float()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetInteger() = unknownType() == lookupType(get(integer()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetBoolean() = unknownType() == lookupType(get(boolean()), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetList() = unknownType() == lookupType(get(\list(string())), newEnv(|tmp:///|));
test bool shouldReturnUnknownTypeOnGetMap() = unknownType() == lookupType(get(\map(string(), integer())), newEnv(|tmp:///|));

test bool shouldReturnStringTypeWhenInvokingStringMethod() = string() == lookupType(invoke("myString", []), setContext(
	\module(namespace("Test"), [], entity("User", [
		method(\public(), string(), "myString", [], [], emptyExpr())
	])), newEnv(|tmp:///|)
));

test bool shouldReturnUnknownTypeWhenInvokingUnknownMethod() = unknownType() == lookupType(invoke("myString", []), setContext(
	\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///|)
));

test bool shouldReturnIntegerTypeWhenInvokingIntegerMethod() = integer() == lookupType(invoke("myString", []), setContext(
	\module(namespace("Test"), [], entity("User", [
		method(\public(), integer(), "myString", [], [], emptyExpr())
	])), newEnv(|tmp:///|)
));

test bool shouldReturnExternalArtifactTypeWhenInvokingLocalArtifactMethod() = artifact(external("User", namespace("Test"), "User")) == lookupType(invoke("myString", []), setContext(
	\module(namespace("Test"), [], entity("User", [
		method(\public(), artifact(local("User")), "myString", [], [], emptyExpr())
	])), addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", [
		method(\public(), artifact(local("User")), "myString", [], [], emptyExpr())
	]))), newEnv(|tmp:///|))
));

test bool shouldReturnExternalArtifactTypeWhenInvokingExternalArtifactMethod() = artifact(external("User", namespace("Example"), "User")) == 
	lookupType(invoke("myString", []), setContext(
		\module(namespace("Test"), [], entity("User", [
			method(\public(), artifact(external("User", namespace("Example"), "User")), "myString", [], [], emptyExpr())
		])), addToAST(file(|tmp:///|, \module(namespace("Example"), [], entity("User", []))), newEnv(|tmp:///|))
	));

test bool shouldReturnStringTypeWhenInvokingStringMethodInRepository() = string() == lookupType(invoke("myString", []), setContext(
	\module(namespace("Test"), [], repository("User", [
		method(\public(), string(), "myString", [], [], emptyExpr())
	])), newEnv(|tmp:///|)
));

test bool shouldReturnIntegerOnChainedInvokeFromLocalArtifact() = integer() == lookupType(invoke(invoke("artifact", []), "myInt", []), setContext(
	\module(namespace("Test"), [], repository("User", [
		method(\public(), artifact(local("Customer")), "artifact", [], [], emptyExpr())
	])), addToAST(file(|tmp:///|, \module(namespace("Test"), [], util("Customer", [
		method(\public(), integer(), "myInt", [], [], emptyExpr())
	]))), newEnv(|tmp:///|))
));

test bool shouldReturnUnknownTypeOnChainedInvokeFromLocalArtifactThatHasStringReturnedInTheMiddle() = 
	unknownType() == lookupType(invoke(invoke("artifact", []), "myInt", []), setContext(
	\module(namespace("Test"), [], repository("User", [
		method(\public(), string(), "artifact", [], [], emptyExpr())
	])), addToAST(file(|tmp:///|, \module(namespace("Test"), [], util("Customer", [
		method(\public(), integer(), "myInt", [], [], emptyExpr())
	]))), newEnv(|tmp:///|))
));

test bool shouldReturnIntegerOnChainedInvokeFromLocalRepository() = integer() == lookupType(invoke(invoke("repo", []), "myInt", []), setContext(
	\module(namespace("Test"), [], util("User", [
		method(\public(), repository(local("Customer")), "repo", [], [], emptyExpr())
	])), addToAST(file(|tmp:///|, \module(namespace("Test"), [], repository("Customer", [
		method(\public(), integer(), "myInt", [], [], emptyExpr())
	]))), newEnv(|tmp:///|))
));

test bool shouldReturnIntegerOnChainedInvokeFromExternalRepository() = integer() == lookupType(invoke(invoke("repo", []), "myInt", []), setContext(
	\module(namespace("Test"), [], util("User", [
		method(\public(), repository(external("Customer", namespace("Example"), "Customer")), "repo", [], [], emptyExpr())
	])), addToAST(file(|tmp:///|, \module(namespace("Example"), [], repository("Customer", [
		method(\public(), integer(), "myInt", [], [], emptyExpr())
	]))), newEnv(|tmp:///|))
));

@doc{
Lookup of property types
}
test bool shouldReturnIntegerOnAccessingIntegerLocalProperty() = integer() == lookupType(fieldAccess("prop"), setContext(
	\module(namespace("Test"), [], entity("User", [
		property(integer(), "prop", emptyExpr())
	])),
	newEnv(|tmp:///|)
));

test bool shouldReturnIntegerOnAccessingIntegerLocalPropertyUsingThis() = integer() == lookupType(fieldAccess(this(), "prop"), setContext(
	\module(namespace("Test"), [], entity("User", [
		property(integer(), "prop", emptyExpr())
	])),
	newEnv(|tmp:///|)
));

test bool shouldReturnIntegerOnAccessingIntegerLocalOneOneRelation() = artifact(external("User", namespace("Test"), "User")) == 
	lookupType(fieldAccess("prop"), setContext(
		\module(namespace("Test"), [], entity("User", [
			relation(\one(), \one(), "User", "prop")
		])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", [
			relation(\one(), \one(), "User", "prop")
		]))), newEnv(|tmp:///|))
	));

test bool shouldReturnIntegerOnAccessingIntegerLocalOneOneRelationUsingThis() = artifact(external("User", namespace("Test"), "User")) == 
	lookupType(fieldAccess(this(), "prop"), setContext(
		\module(namespace("Test"), [], entity("User", [
			relation(\one(), \one(), "User", "prop")
		])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", [
			relation(\one(), \one(), "User", "prop")
		]))), newEnv(|tmp:///|))
	));

test bool shouldReturnIntegerOnAccessingIntegerLocalOneManyRelation() = 
	\list(artifact(external("User", namespace("Test"), "User"))) == 
	lookupType(fieldAccess("prop"), setContext(
		\module(namespace("Test"), [], entity("User", [
			relation(\one(), many(), "User", "prop")
		])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", [
			relation(\one(), many(), "User", "prop")
		]))), newEnv(|tmp:///|))
	));

test bool shouldReturnIntegerOnAccessingIntegerLocalOneManyRelationUsingThis() = 
	\list(artifact(external("User", namespace("Test"), "User"))) == 
	lookupType(fieldAccess(this(), "prop"), setContext(
		\module(namespace("Test"), [], entity("User", [
			relation(\one(), many(), "User", "prop")
		])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", [
			relation(\one(), many(), "User", "prop")
		]))), newEnv(|tmp:///|))
	));

test bool shouldReturnUnknownTypeOnAccessingUndefinedField() = 
	unknownType() == 
	lookupType(fieldAccess("prop"), setContext(
		\module(namespace("Test"), [], entity("User", [])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|))
	));

test bool shouldReturnUnknownTypeOnAccessingRemoteField() = 
	unknownType() == 
	lookupType(fieldAccess(variable("someObject"), "prop"), setContext(
		\module(namespace("Test"), [], entity("User", [])),
		addToAST(file(|tmp:///|, \module(namespace("Test"), [], entity("User", []))), newEnv(|tmp:///|))
	));

