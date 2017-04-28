module Test::Typechecker::Expression

import Typechecker::Expression;
import Syntax::Abstract::Glagol;
import Typechecker::Env;

TypeEnv emptyEnv = <|tmp:///|, (), (), [], []>;

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
    
test bool shouldReturnUnknownTypeWhenLookingUpTypeForListWithDifferentValueTypes2() = 
    \list(unknownType()) == lookupType(\list([string("dasdsa"), float(445.23)]), emptyEnv);
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForListZeroElements() = 
    \list(voidValue()) == lookupType(\list([]), emptyEnv);
    
// Lookup map types
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForMaps() = 
    \list(integer()) == lookupType(\map((string("key1"): integer(5))), emptyEnv);
    
test bool shouldReturnTheFirstElementTypeWhenLookingUpTypeForTwoMemberMaps() = 
    \list(integer()) == lookupType(\map((string("key1"): integer(5), string("key2"): integer(6))), emptyEnv);

test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes() = 
    \list(unknownType()) == lookupType(\map((string("key1"): integer(5), string("key2"): string("dassd"))), emptyEnv);
    
test bool shouldReturnUnknownTypeWhenLookingUpTypeForMapWithDifferentValueTypes2() = 
    \list(unknownType()) == lookupType(\map((string("key1"): string("dasdsa"), string("key2"): float(445.23))), emptyEnv);
    
test bool shouldReturnVoidListTypeWhenLookingUpTypeForMapZeroElements() = 
    \list(voidValue()) == lookupType(\map(()), emptyEnv);

// Lookup array access 
test bool shouldReturnIntegerTypeFromAListUsingIndexToAccessIt() = 
    integer() == lookupType(arrayAccess(\list([integer(5), integer(4)]), integer(0)), emptyEnv);
    
test bool shouldReturnListStringTypeFromAListUsingIndexToAccessIt() = 
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


