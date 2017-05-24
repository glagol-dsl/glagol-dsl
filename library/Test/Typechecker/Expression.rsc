module Test::Typechecker::Expression

import Typechecker::Expression;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

TypeEnv emptyEnv = newEnv(|tmp:///|);

// Lookup literal types
test bool shouldReturnIntegerWhenLookingUpTypeForIntegerLiteral() = integer() == lookupType(integer(5), emptyEnv);
test bool shouldReturnFloatWhenLookingUpTypeForFloatLiteral() = float() == lookupType(float(5.3), emptyEnv);
test bool shouldReturnStringWhenLookingUpTypeForStringLiteral() = string() == lookupType(string("dasads"), emptyEnv);
test bool shouldReturnBooleanWhenLookingUpTypeForBooleanTrueLiteral() = boolean() == lookupType(boolean(true), emptyEnv);
test bool shouldReturnBooleanWhenLookingUpTypeForBooleanFalseLiteral() = boolean() == lookupType(boolean(true), emptyEnv);

// Lookup list types
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForLists() = 
    \list(integer()) == lookupType(\list([integer(5)]), emptyEnv);
    
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForTwoMemberLists() = 
    \list(integer()) == lookupType(\list([integer(5), integer(6)]), emptyEnv);

test bool shouldReturnUnknownTypeWhenLookingUpTypeForListWithDifferentValueTypes() = 
    \list(unknownType()) == lookupType(\list([integer(5), string("dassd")]), emptyEnv);
    
test bool shouldReturnUnTypeWhenLookingUpTypeForListWithDifferentValueTypes2() = 
    \list(unknownType()) == lookupType(\list([string("dasdsa"), float(445.23)]), emptyEnv);
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForListNoElements() = 
    \list(voidValue()) == lookupType(\list([]), emptyEnv);
    
// Lookup map types
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForMaps() = 
    \map(string(), integer()) == lookupType(\map((string("key1"): integer(5))), emptyEnv);
    
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForTwoMemberMaps() = 
    \map(string(), integer()) == lookupType(\map((string("key1"): integer(5), string("key2"): integer(6))), emptyEnv);

test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes() = 
    \map(string(), unknownType()) == lookupType(\map((string("key1"): integer(5), string("key2"): string("dassd"))), emptyEnv);
    
test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes2() = 
    \map(string(), unknownType()) == lookupType(\map((string("key1"): string("dasdsa"), string("key2"): float(445.23))), emptyEnv);
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForMapNoElements() = 
    \map(unknownType(), unknownType()) == lookupType(\map(()), emptyEnv);

// Lookup array access 
test bool shouldReturnIntegerTypeFromAListUsingIndexToAccessIt() = 
    integer() == lookupType(arrayAccess(\list([integer(5), integer(4)]), integer(0)), emptyEnv);
    
test bool shouldReturnListStrTypeFromAListUsingIndexToAccessIt() = 
    \list(string()) == lookupType(arrayAccess(\list([\list([string("blah"), string("blah2")]), \list([string("blah3")])]), integer(0)), emptyEnv);

test bool shouldReturnUnknownTypeWhenTryingToAccessNonArray() = 
    unknownType() == lookupType(arrayAccess(integer(5), integer(0)), emptyEnv);

test bool shouldReturnIntegerTypeFromAMapUsingIndexToAccessIt() = 
    integer() == lookupType(arrayAccess(\map((string("first"): integer(5), string("second"): integer(4))), string("second")), emptyEnv);

// Variables
test bool shouldReturnUnknownTypeForVariableThatIsNotInEnv() =
    unknownType() == lookupType(variable("myVar"), emptyEnv);

test bool shouldReturnStringTypeForLocalVariableThatIsInEnv() =
    string() == lookupType(variable("myVar"), addDefinition(declare(string(), variable("myVar"), emptyStmt()), emptyEnv));
    
test bool shouldReturnStringTypeForFieldPropertyThatIsInEnv() =
    integer() == lookupType(variable("myVar"), addDefinition(property(integer(), "myVar", {}, emptyExpr()), emptyEnv));
    
test bool shouldReturnStringTypeForParamThatIsInEnv() =
    float() == lookupType(variable("myVar"), addDefinition(param(float(), "myVar", emptyExpr()), emptyEnv));

test bool shouldReturnIntegerTypeForIntegerInBrackets() = integer() == lookupType(\bracket(integer(12)), emptyEnv);

test bool shouldReturnIntegerTypeForProductOfIntegers() = integer() == lookupType(product(integer(23), integer(33)), emptyEnv);
test bool shouldReturnFloatTypeForProductOfFloats() = float() == lookupType(product(float(23.22), float(33.33)), emptyEnv);
test bool shouldReturnUnknownTypeForProductOfStrings() = unknownType() == lookupType(product(string("adsdassda"), string("adsadsads")), emptyEnv);

test bool shouldReturnIntegerTypeForRemainderOfIntegers() = integer() == lookupType(remainder(integer(23), integer(33)), emptyEnv);
test bool shouldReturnFloatTypeForRemainderOfFloats() = float() == lookupType(remainder(float(23.22), float(33.33)), emptyEnv);
test bool shouldReturnUnknownTypeForRemainderOfStrings() = unknownType() == lookupType(remainder(string("adsdassda"), string("adsadsads")), emptyEnv);

test bool shouldReturnIntegerTypeForDivOfIntegers() = integer() == lookupType(division(integer(23), integer(33)), emptyEnv);
test bool shouldReturnFloatTypeForDivOfFloats() = float() == lookupType(division(float(23.22), float(33.33)), emptyEnv);
test bool shouldReturnUnknownTypeForDivOfStrings() = unknownType() == lookupType(division(string("adsdassda"), string("adsadsads")), emptyEnv);

test bool shoudReturnStringTypeForAddOfStrings() = string() == lookupType(addition(string("test"), string("test")), emptyEnv);
test bool shoudReturnIntegerTypeForAddOfIntegers() = integer() == lookupType(addition(integer(1), integer(2)), emptyEnv);
test bool shoudReturnFloatTypeForAddOfFloats() = float() == lookupType(addition(float(1.2), float(2.2)), emptyEnv);

test bool shoudReturnUnknownTypeForAddOfFloatAndInt() = unknownType() == lookupType(addition(float(1.2), integer(2)), emptyEnv);

test bool shouldReturnIntegerTypeForSubOfIntegers() = integer() == lookupType(subtraction(integer(23), integer(33)), emptyEnv);
test bool shouldReturnFloatTypeForSubOfFloats() = float() == lookupType(subtraction(float(23.22), float(33.33)), emptyEnv);
test bool shouldReturnUnknownTypeForSubOfStrings() = unknownType() == lookupType(subtraction(string("adsdassda"), string("adsadsads")), emptyEnv);

test bool shouldReturnBoolWhenComparingGTEOfIntegers() = boolean() == lookupType(greaterThanOrEq(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTEOfIntegerAndFloat() = boolean() == lookupType(greaterThanOrEq(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTEOfFloats() = boolean() == lookupType(greaterThanOrEq(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTEOfFloatAndInteger() = boolean() == lookupType(greaterThanOrEq(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTEOfFloatAndBoolean() = unknownType() == lookupType(greaterThanOrEq(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTEOfFloatAndString() = unknownType() == lookupType(greaterThanOrEq(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndFloat() = unknownType() == lookupType(greaterThanOrEq(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndString() = unknownType() == lookupType(greaterThanOrEq(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTEOfBooleanAndInteger() = unknownType() == lookupType(greaterThanOrEq(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBoolWhenComparingLTEOfIntegers() = boolean() == lookupType(lessThanOrEq(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTEOfIntegerAndFloat() = boolean() == lookupType(lessThanOrEq(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTEOfFloats() = boolean() == lookupType(lessThanOrEq(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTEOfFloatAndInteger() = boolean() == lookupType(lessThanOrEq(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTEOfFloatAndBoolean() = unknownType() == lookupType(lessThanOrEq(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTEOfFloatAndString() = unknownType() == lookupType(lessThanOrEq(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndFloat() = unknownType() == lookupType(lessThanOrEq(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndString() = unknownType() == lookupType(lessThanOrEq(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTEOfBooleanAndInteger() = unknownType() == lookupType(lessThanOrEq(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBoolWhenComparingLTOfIntegers() = boolean() == lookupType(lessThan(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTOfIntegerAndFloat() = boolean() == lookupType(lessThan(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTOfFloats() = boolean() == lookupType(lessThan(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingLTOfFloatAndInteger() = boolean() == lookupType(lessThan(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTOfFloatAndBoolean() = unknownType() == lookupType(lessThan(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTOfFloatAndString() = unknownType() == lookupType(lessThan(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndFloat() = unknownType() == lookupType(lessThan(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndString() = unknownType() == lookupType(lessThan(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingLTOfBooleanAndInteger() = unknownType() == lookupType(lessThan(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBoolWhenComparingGTOfIntegers() = boolean() == lookupType(greaterThan(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTOfIntegerAndFloat() = boolean() == lookupType(greaterThan(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTOfFloats() = boolean() == lookupType(greaterThan(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingGTOfFloatAndInteger() = boolean() == lookupType(greaterThan(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTOfFloatAndBoolean() = unknownType() == lookupType(greaterThan(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTOfFloatAndString() = unknownType() == lookupType(greaterThan(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndFloat() = unknownType() == lookupType(greaterThan(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndString() = unknownType() == lookupType(greaterThan(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingGTOfBooleanAndInteger() = unknownType() == lookupType(greaterThan(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBooleanWhenComparingEQOfStrings() = boolean() == lookupType(equals(string("dasda"), string("dads")), emptyEnv);
test bool shouldReturnBooleanWhenComparingEQOfIntegers() = boolean() == lookupType(equals(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBooleanWhenComparingEQOfIntegerAndFloat() = boolean() == lookupType(equals(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBooleanWhenComparingEQOfFloats() = boolean() == lookupType(equals(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBooleanWhenComparingEQOfFloatAndInteger() = boolean() == lookupType(equals(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnknownTypeWhenComparingEQOfFloatAndBoolean() = unknownType() == lookupType(equals(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnknownTypeWhenComparingEQOfFloatAndString() = unknownType() == lookupType(equals(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndFloat() = unknownType() == lookupType(equals(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndString() = unknownType() == lookupType(equals(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnknownTypeWhenComparingEQOfBooleanAndInteger() = unknownType() == lookupType(equals(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBoolWhenComparingNonEQOfStrings() = boolean() == lookupType(nonEquals(string("dasda"), string("dads")), emptyEnv);
test bool shouldReturnBoolWhenComparingNonEQOfIntegers() = boolean() == lookupType(nonEquals(integer(1), integer(2)), emptyEnv);
test bool shouldReturnBoolWhenComparingNonEQOfIntegerAndFloat() = boolean() == lookupType(nonEquals(integer(1), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingNonEQOfFloats() = boolean() == lookupType(nonEquals(float(1.2), float(2.2)), emptyEnv);
test bool shouldReturnBoolWhenComparingNonEQOfFloatAndInteger() = boolean() == lookupType(nonEquals(float(1.2), integer(2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingNonEQOfFloatAndBoolean() = unknownType() == lookupType(nonEquals(float(1.2), boolean(true)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingNonEQOfFloatAndString() = unknownType() == lookupType(nonEquals(float(1.2), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndFloat() = unknownType() == lookupType(nonEquals(boolean(true), float(1.2)), emptyEnv);
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndString() = unknownType() == lookupType(nonEquals(boolean(false), string("s")), emptyEnv);
test bool shouldReturnUnTypeWhenComparingNonEQOfBooleanAndInteger() = unknownType() == lookupType(nonEquals(boolean(false), integer(3)), emptyEnv);

test bool shouldReturnBooleanTypeOnConjunctionOfBooleans() = boolean() == lookupType(and(boolean(true), boolean(false)), emptyEnv);
test bool shouldReturnUnknownTypeOnConjunctionOfNonBooleans() = unknownType() == lookupType(and(boolean(true), integer(1)), emptyEnv);

test bool shouldReturnBooleanTypeOnDisjunctionOfBooleans() = boolean() == lookupType(or(boolean(true), boolean(false)), emptyEnv);
test bool shouldReturnUnknownTypeOnDisjunctionOfNonBooleans() = unknownType() == lookupType(or(boolean(true), integer(1)), emptyEnv);

test bool shouldReturnIntegerTypeOnPositiveInteger() = integer() == lookupType(positive(integer(2)), emptyEnv);
test bool shouldReturnIntegerTypeOnPositiveFloat() = float() == lookupType(positive(float(2.2)), emptyEnv);

test bool shouldReturnIntegerTypeOnNegativeInteger() = integer() == lookupType(negative(integer(2)), emptyEnv);
test bool shouldReturnIntegerTypeOnNegativeFloat() = float() == lookupType(negative(float(2.2)), emptyEnv);

test bool shouldReturnIntegerOnTernaryOfIntegers() = integer() == lookupType(ifThenElse(boolean(true), integer(1), integer(2)), emptyEnv);
test bool shouldReturnFloatOnTernaryOfFloats() = float() == lookupType(ifThenElse(boolean(true), float(1.1), float(2.2)), emptyEnv);
test bool shouldReturnBooleanOnTernaryOfBooleans() = boolean() == lookupType(ifThenElse(boolean(true), boolean(true), boolean(false)), emptyEnv);
test bool shouldReturnStringOnTernaryOfStrings() = string() == lookupType(ifThenElse(boolean(true), string("s"), string("b")), emptyEnv);
test bool shouldReturnListOnTernaryOfLists() = \list(integer()) == lookupType(ifThenElse(boolean(true), \list([integer(1), integer(2)]), \list([integer(3), integer(4)])), emptyEnv);
test bool shouldReturnMapOnTernaryOfMaps() = 
    \map(integer(), string()) == lookupType(ifThenElse(boolean(true), \map((integer(1): string("s"))), \map((integer(2): string("s")))), emptyEnv);
test bool shouldReturnArtifactOnTernaryOfSameArtifacts() = 
    artifact("User") == lookupType(ifThenElse(boolean(true), get(artifact("User")), get(artifact("User"))), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))),
		emptyEnv)));
test bool shouldReturnUnknownTypeOnTernaryOfDifferentArtifacts() = 
    unknownType() == lookupType(ifThenElse(boolean(true), get(artifact("User")), get(artifact("Customer"))), emptyEnv);
test bool shouldReturnRepositoryOnTernaryOfSameRepositories() = 
    repository("User") == lookupType(ifThenElse(boolean(true), get(repository("User")), get(repository("User"))), emptyEnv);
test bool shouldReturnUnknownTypeOnTernaryOfDifferentRepositories() = 
    unknownType() == lookupType(ifThenElse(boolean(true), get(repository("User")), get(repository("Customer"))), emptyEnv);
test bool shouldReturnUnTypeOnDifferentTypes() = 
    unknownType() == lookupType(ifThenElse(boolean(true), integer(2), get(artifact("User"))), emptyEnv);

test bool shouldReturnArtifactTypeOnNew() = artifact("User") == lookupType(new("User", []), emptyEnv);

test bool shouldReturnUnknownTypeOnGetUnimportedArtifact() = unknownType() == lookupType(get(artifact("User")), emptyEnv);
test bool shouldReturnUnknownTypeOnGetArtifactWhichIsEntity() = unknownType() == lookupType(get(artifact("User")), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
		emptyEnv)));
test bool shouldReturnArtifactTypeOnGetArtifactWhichIsUtil() = 
	artifact("User") == lookupType(get(artifact("User")), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))),
		emptyEnv)));
test bool shouldReturnUnknownTypeOnGetArtifactWhichIsValueObject() = 
	unknownType() == lookupType(get(artifact("User")), addImported(\import("User", namespace("Test"), "User"), addToAST(
		file(|tmp:///User.g|, \module(namespace("Test"), [], valueObject("User", []))),
		emptyEnv)));
test bool shouldReturnRepositoryTypeOnGetRepository() = repository("User") == lookupType(get(repository("User")), emptyEnv);
test bool shouldReturnSelfieTypeOnGetSelfie() = selfie() == lookupType(get(selfie()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetVoid() = unknownType() == lookupType(get(voidValue()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetString() = unknownType() == lookupType(get(string()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetFloat() = unknownType() == lookupType(get(float()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetInteger() = unknownType() == lookupType(get(integer()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetBoolean() = unknownType() == lookupType(get(boolean()), emptyEnv);
test bool shouldReturnUnknownTypeOnGetList() = unknownType() == lookupType(get(\list(string())), emptyEnv);
test bool shouldReturnUnknownTypeOnGetMap() = unknownType() == lookupType(get(\map(string(), integer())), emptyEnv);


