module Test::Typechecker::Property::DefaultValue

import Typechecker::Property::DefaultValue;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shouldNotGiveErrorOnGetSelfie() = 
	checkDefaultValue(get(selfie()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldNotGiveErrorOnEmptyExpr() = 
	checkDefaultValue(emptyExpr(), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact(unresolvedName("User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], newEnv(|tmp:///Util.g|)) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used in /Util.g on line 10", newEnv(|tmp:///Util.g|));

test bool shouldNotGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact(unresolvedName("User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], addImported(\import("User", namespace("Test", namespace("Entity")), "User"), newEnv(|tmp:///Util.g|))) == 
	addImported(\import("User", namespace("Test", namespace("Entity")), "User"), newEnv(|tmp:///Util.g|));

test bool shouldGiveNotImportedErrorOnGetRepository() = 
	checkDefaultValue(get(repository(unresolvedName("User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], newEnv(|tmp:///Util.g|)) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used for a repository in /Util.g on line 10", newEnv(|tmp:///Util.g|));

test bool shouldGiveNotEntityErrorOnGetRepository() = 
	checkDefaultValue(get(repository(unresolvedName("User"))
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], 
	
	addImported(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Util.g|)))) == 
	addError(|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" is not an entity in /Util.g on line 10",
		addImported(\import("User", namespace("Test"), "User"), addToAST(file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", []))), newEnv(|tmp:///Util.g|))));

test bool shouldNotGiveErrorOnGetRepository() = 
	checkDefaultValue(get(repository(unresolvedName("User"))
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


