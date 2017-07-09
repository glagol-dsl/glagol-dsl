module Test::Typechecker::Property

import Syntax::Abstract::Glagol;
import Typechecker::Property;
import Typechecker::Env;
import Typechecker::Errors;

test bool shouldNotGiveErrorsOnCheckTypeMismatchOfSelfieOnArtifact() = 
	checkTypeMismatch(selfie(), artifact(local("UserService")), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldNotGiveErrorsOnCheckTypeMismatchOfSelfieOnRepository() = 
	checkTypeMismatch(selfie(), repository(local("User")), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldNotGiveErrorsOnCheckTypeMismatchOfSameTypes() = 
	checkTypeMismatch(integer(), integer(), newEnv(|tmp:///|)) == newEnv(|tmp:///|);

test bool shouldNotGiveErrorsOnCheckTypeMismatchOnVoidList() = 
	checkTypeMismatch(\list(voidValue()), \list(integer()), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
	
test bool shouldNotGiveErrorsOnCheckTypeMismatchOnVoidMap() = 
	checkTypeMismatch(\map(voidValue(), voidValue()), \map(integer(), integer()), newEnv(|tmp:///|)) == newEnv(|tmp:///|);
	
test bool shouldGiveTypeMismatchErrorWhenTypesDoNotMatch() = 
	checkTypeMismatch(integer(), string()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], newEnv(|tmp:///|)) == 
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		typeMismatch(string()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		integer()[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]), newEnv(|tmp:///|));
	
test bool shouldGiveTypeMismatchErrorWhenHavingUnknownTypeAsDefaultValue() = 
	checkProperty(property(\list(integer())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], "prop", \list([
		integer(12)[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		string("dasdas")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
	])), newEnv(|tmp:///|)) ==
	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), 
		typeMismatch(\list(integer())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
		\list(unknownType())), newEnv(|tmp:///|));

	
	
