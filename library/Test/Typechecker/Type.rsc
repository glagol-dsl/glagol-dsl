module Test::Typechecker::Type

import Typechecker::Type;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shlouldNotGiveErrorsForScalarTypes() =
	checkType(integer(), property(integer(), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(float(), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(boolean(), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|) &&
	checkType(integer(), property(string(), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == newEnv(|tmp:///User.g|);

test bool shlouldGiveErrorWhenUsingVoidValueForPropertyType() =
	checkType(voidValue(), property(voidValue(), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on property", newEnv(|tmp:///User.g|));
	
test bool shlouldGiveErrorWhenUsingVoidValueForParamType() =
	checkType(voidValue(), param(voidValue(), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on param \"prop\"", newEnv(|tmp:///User.g|));
	
test bool shlouldNotGiveErrorWhenUsingVoidValueOnMethod() =
	checkType(voidValue(), method(\public(), voidValue(), "prop", [], [], emptyExpr()), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|);

test bool shlouldNotGiveErrorsForListAndMapTypes() =
	checkType(\list(integer()), property(\list(integer()), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|) &&
	checkType(\map(integer(), string()), property(\map(integer(), string()), "prop", emptyExpr()), newEnv(|tmp:///User.g|)) == 
	newEnv(|tmp:///User.g|);

test bool shlouldGiveErrorWhenUsingNotImportedArtifact() =
	checkType(artifact(fullName("User", namespace("Test"), "User"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		param(artifact(fullName("User", namespace("Test"), "User")), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) ==
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"User\" not imported, but used", newEnv(|tmp:///User.g|));

test bool shlouldNotGiveErrorWhenUsingImportedArtifact() =
	checkType(artifact(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		param(artifact(fullName("Date", namespace("Test"), "Date")), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
	addImported(\import("Date", namespace("Test"), "Date"), newEnv(|tmp:///User.g|))) == 
	addImported(\import("Date", namespace("Test"), "Date"), newEnv(|tmp:///User.g|));

test bool shlouldGiveErrorWhenUsingRepositoryWithNotImportedEntity() =
	checkType(repository(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		param(repository(fullName("Date", namespace("Test"), "Date")), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) ==
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" not imported, but used for a repository",
		newEnv(|tmp:///User.g|)
	);

test bool shlouldGiveErrorWhenUsingRepositoryWithImportedArtifactButIsNotEntity() =
	checkType(repository(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		param(repository(fullName("Date", namespace("Test"), "Date")), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		
		addImported(\import("Date", namespace("Test"), "Date"),
			addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [], notProxy())[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" is not an entity",
	addImported(\import("Date", namespace("Test"), "Date"),
		addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [], notProxy())[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
	));

test bool shouldGiveErrorsWhenUsingSelfieForSomethingElseThanGettingPropertyInstance() = 
	checkType(selfie()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], property(repository(fullName("User", namespace("Test"), "User")), "users", emptyExpr()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)])[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) ==
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Selfie cannot be used as property type", newEnv(|tmp:///User.g|));
	
test bool shouldGiveErrorsWhenUsingSelfieForSomethingElseThanGettingPropertyInstance2() = 
	checkType(selfie()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], param(repository(fullName("User", namespace("Test"), "User"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], "users", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], newEnv(|tmp:///User.g|)) ==
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Selfie cannot be used as property type", newEnv(|tmp:///User.g|));

test bool shlouldGiveErrorWhenGettingSelfieOfNonUtilArtifact() =
	checkType(artifact(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		property(artifact(fullName("Date", namespace("Test"), "Date")), "prop", get(selfie()))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		
		addImported(\import("Date", namespace("Test"), "Date"),
			addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], entity("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
		)
	) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Get selfie cannot be applied for type other than repositories and utils/services",
	addImported(\import("Date", namespace("Test"), "Date"),
		addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], entity("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
	));
	
test bool shlouldNotGiveErrorWhenGettingSelfieOfNonUtilArtifact() =
	checkType(artifact(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		property(artifact(fullName("Date", namespace("Test"), "Date")), "prop", get(selfie()))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		
		addImported(\import("Date", namespace("Test"), "Date"),
			addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [], notProxy())[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
		)
	) == 
	addImported(\import("Date", namespace("Test"), "Date"),
		addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [], notProxy())[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
	);

test bool shlouldNotGiveErrorWhenGettingSelfieOfRepository() =
	checkType(repository(fullName("Date", namespace("Test"), "Date"))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		property(repository(fullName("Date", namespace("Test"), "Date")), "prop", get(selfie()))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		addImported(\import("Date", namespace("Test"), "Date"),
			addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], entity("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
		)
	) == 
	addImported(\import("Date", namespace("Test"), "Date"),
		addToAST(file(|tmp:///Date.g|, \module(namespace("Test"), [], entity("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)])), newEnv(|tmp:///User.g|))
	);
	
test bool shlouldGiveErrorWhenGettingSelfieOfNonGettableType() =
	checkType(integer()[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		property(integer(), "prop", get(selfie()))[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)],
		newEnv(|tmp:///User.g|)
	) == 
	addError(|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Get selfie cannot be applied for type other than repositories and utils/services",
	newEnv(|tmp:///User.g|));
