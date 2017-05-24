module Test::Typechecker::Type

import Typechecker::Type;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shlouldNotGiveErrorsForScalarTypes() =
	checkType(integer(), property(integer(), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(float(), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(boolean(), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(string(), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shlouldGiveErrorWhenUsingVoidValueForPropertyType() =
	checkType(voidValue(), property(voidValue(), "prop", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on property in /User.g on line 10", newEnv(|tmp:///User.g|));
	
test bool shlouldGiveErrorWhenUsingVoidValueForParamType() =
	checkType(voidValue(), param(voidValue(), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on param \"prop\" in /User.g on line 10", newEnv(|tmp:///User.g|));
	
test bool shlouldNotGiveErrorWhenUsingVoidValueOnMethod() =
	checkType(voidValue(), method(\public(), voidValue(), "prop", [], []), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|);

test bool shlouldNotGiveErrorsForListAndMapTypes() =
	checkType(\list(integer()), property(\list(integer()), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|) &&
	checkType(\map(integer(), string()), property(\map(integer(), string()), "prop", {}, emptyExpr()), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|);

test bool shlouldGiveErrorWhenUsingNotImportedArtifact() =
	checkType(artifact("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(artifact("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" not imported, but used in /User.g on line 10", newEnv(|tmp:///User.g|));

test bool shlouldNotGiveErrorWhenUsingImportedArtifact() =
	checkType(artifact("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(artifact("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
	addImported(\import("Date", namespace("Test", namespace("Entity")), "Date"), newEnv(|tmp:///User.g|))) == 
	addImported(\import("Date", namespace("Test", namespace("Entity")), "Date"), newEnv(|tmp:///User.g|));

test bool shlouldGiveErrorWhenUsingRepositoryWithNotImportedEntity() =
	checkType(repository("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(repository("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" not imported, but used for a repository in /User.g on line 10",
		newEnv(|tmp:///User.g|)
	);

test bool shlouldGiveErrorWhenUsingRepositoryWithImportedArtifactButIsNotEntity() =
	checkType(repository("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(repository("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		
		addImported(\import("Date", namespace("Test"), "Date"),
			addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" is not an entity in /User.g on line 10",
	addImported(\import("Date", namespace("Test"), "Date"),
		addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
	));

test bool shouldNotGiveErrorsWhenUsingSelfieForGettingPropertyInstance() = 
	checkType(selfie(), property(repository("User"), "users", {}, get(selfie())), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shouldGiveErrorsWhenUsingSelfieForSomethingElseThanGettingPropertyInstance() = 
	checkType(selfie()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], property(repository("User"), "users", {}, emptyExpr()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Cannot use selfie as type in /User.g on line 10", newEnv(|tmp:///User.g|));
	
test bool shouldGiveErrorsWhenUsingSelfieForSomethingElseThanGettingPropertyInstance2() = 
	checkType(selfie()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], param(repository("User")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], "users", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Cannot use selfie as type in /User.g on line 10", newEnv(|tmp:///User.g|));

