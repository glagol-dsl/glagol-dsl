module Test::Typechecker::Property::DefaultValue

import Typechecker::Property::DefaultValue;
import Syntax::Abstract::Glagol;

test bool shouldNotGiveErrorOnGetSelfie() = 
	checkDefaultValue(get(selfie()), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shouldNotGiveErrorOnEmptyExpr() = 
	checkDefaultValue(emptyExpr(), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shouldGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact("User")
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], <|tmp:///Util.g|, (), (), [], []>) == 
	<|tmp:///Util.g|, (), (), [], [
		<|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used in /Util.g on line 10">
	]>;

test bool shouldNotGiveNotImportedErrorOnGetArtifact() = 
	checkDefaultValue(get(artifact("User")
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], <|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [], []>) == 
	<|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [], []>;

test bool shouldGiveNotImportedErrorOnGetRepository() = 
	checkDefaultValue(get(repository("User")
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], <|tmp:///Util.g|, (), (), [], []>) == 
	<|tmp:///Util.g|, (), (), [], [
		<|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" not imported, but used for a repository in /Util.g on line 10">
	]>;

test bool shouldGiveNotEntityErrorOnGetRepository() = 
	checkDefaultValue(get(repository("User")
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], <|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", [])))
	], []>) == 
	<|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [
		file(|tmp:///User.g|, \module(namespace("Test"), [], util("User", [])))
	], [
		<|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>), "\"User\" is not an entity in /Util.g on line 10">
	]>;

test bool shouldNotGiveErrorOnGetRepository() = 
	checkDefaultValue(get(repository("User")
		[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)]
	)[@src=|tmp:///Util.g|(0, 0, <10, 10>, <15, 15>)], <|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])))
	], []>) == 
	<|tmp:///Util.g|, (), (
		"User": \import("User", namespace("Test"), "User")
	), [
		file(|tmp:///User.g|, \module(namespace("Test"), [], entity("User", [])))
	], []>;

test bool shouldNotGiveErrorOnIntegerScalar() = 
	checkDefaultValue(integer(12), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shouldNotGiveErrorOnFloatScalar() = 
	checkDefaultValue(float(1.22), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shouldNotGiveErrorOnStringScalar() = 
	checkDefaultValue(string("a string"), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shouldNotGiveErrorOnBooleanScalar() = 
	checkDefaultValue(boolean(false), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;


