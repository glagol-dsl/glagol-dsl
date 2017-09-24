module Test::Typechecker::Property::DefaultValue

import Typechecker::Property::DefaultValue;
import Typechecker::Env;
import Typechecker::Errors;
import Syntax::Abstract::Glagol;

test bool shouldGiveErrorOnGetOnEntity() = 
	checkDefaultValue(get(selfie())[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], 
		setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|))) == 
	addError(
		|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "Get is not allowed in entities and value objects", 
		setContext(\module(namespace("Test"), [], entity("User", [])), newEnv(|tmp:///User.g|)));
		
test bool shouldGiveErrorOnGetOnVo() = 
	checkDefaultValue(get(selfie())[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], 
		setContext(\module(namespace("Test"), [], valueObject("User", [])), newEnv(|tmp:///User.g|))) == 
	addError(
		|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "Get is not allowed in entities and value objects", 
		setContext(\module(namespace("Test"), [], valueObject("User", [])), newEnv(|tmp:///User.g|)));
	
test bool shouldNotGiveErrorOnGetSelfie() = 
	checkDefaultValue(get(selfie()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnEmptyExpr() = 
	checkDefaultValue(emptyExpr(), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact(fullName("User", namespace("Example"), "User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], newEnv(|tmp:///Util.g|)) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used", newEnv(|tmp:///Util.g|));

test bool shouldNotGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact(fullName("User", namespace("Test", namespace("Entity")), "User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], addImported(\import("User", namespace("Test", namespace("Entity")), "User"), newEnv(|tmp:///Util.g|))) == 
	addImported(\import("User", namespace("Test", namespace("Entity")), "User"), newEnv(|tmp:///Util.g|));

test bool shouldGiveNotImportedErrorOnGetRepository() = 
	checkDefaultValue(get(repository(fullName("User", namespace("Test", namespace("Entity")), "User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], newEnv(|tmp:///Util.g|)) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used for a repository", newEnv(|tmp:///Util.g|));

test bool shouldGiveNotEntityErrorOnGetRepository() = 
	checkDefaultValue(get(repository(fullName("User", namespace("Test"), "User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], 
	
	addImported(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Util.g|)))) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" is not an entity",
		addImported(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Util.g|))));

test bool shouldNotGiveErrorOnGetRepository() = 
	checkDefaultValue(get(repository(fullName("User", namespace("Test"), "User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], 
		addImported(\import("User", namespace("Test"), "User"),
		addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
		newEnv(|tmp:///Util.g|)))) == 
	addImported(\import("User", namespace("Test"), "User"),
		addToAST(
			file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", []))),
		newEnv(|tmp:///Util.g|)));

test bool shouldNotGiveErrorOnIntegerScalar() = 
	checkDefaultValue(integer(12), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnFloatScalar() = 
	checkDefaultValue(float(1.22), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnStringScalar() = 
	checkDefaultValue(string("a string"), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnBooleanScalar() = 
	checkDefaultValue(boolean(false), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnListOfIntegers() = 
	checkDefaultValue(\list([integer(1), integer(2)]), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnListOfStrings() = 
	checkDefaultValue(\list([string("das"), string("adasd")]), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnListOfBools() = 
	checkDefaultValue(\list([boolean(true), boolean(false)]), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);
	
test bool shouldNotGiveErrorOnListOfFloats() = 
	checkDefaultValue(\list([float(12.3), float(15.3)]), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);
	
test bool shouldGiveErrorOnListOfVariables() = 
	checkDefaultValue(\list([
		variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
	]), newEnv(|tmp:///User.g|)) == 
	addError(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		notAllowed(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]), newEnv(|tmp:///User.g|));
	
test bool shouldGiveErrorOnMapOfVariablesAsKeys() = 
	checkDefaultValue(\map((
		variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]: integer(2)
	)), newEnv(|tmp:///User.g|)) == 
	addError(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		notAllowed(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]), newEnv(|tmp:///User.g|));
		
test bool shouldGiveErrorOnMapOfVariablesAsItems() = 
	checkDefaultValue(\map((
		integer(2): variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
	)), newEnv(|tmp:///User.g|)) == 
	addError(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		notAllowed(variable("das")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]), newEnv(|tmp:///User.g|));


