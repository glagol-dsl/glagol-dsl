module Test::Typechecker::Type

import Typechecker::Type;
import Typechecker::Env;
import Syntax::Abstract::Glagol;

test bool shlouldNotGiveErrorsForScalarTypes() =
	checkType(integer(), property(integer(), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []> &&
	checkType(integer(), property(float(), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []> &&
	checkType(integer(), property(boolean(), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []> &&
	checkType(integer(), property(string(), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], []>;

test bool shlouldGiveErrorWhenUsingVoidValueForPropertyType() =
	checkType(voidValue(), property(voidValue(), "prop", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], [
		<|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on property in /User.g on line 10">
	]>;
	
test bool shlouldGiveErrorWhenUsingVoidValueForParamType() =
	checkType(voidValue(), param(voidValue(), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], [
		<|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "Void type cannot be used on param \"prop\" in /User.g on line 10">
	]>;
	
test bool shlouldNotGiveErrorWhenUsingVoidValueOnMethod() =
	checkType(voidValue(), method(\public(), voidValue(), "prop", [], []), <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], []>;

test bool shlouldNotGiveErrorsForListAndMapTypes() =
	checkType(\list(integer()), property(\list(integer()), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], []> &&
	checkType(\map(integer(), string()), property(\map(integer(), string()), "prop", {}, emptyExpr()), <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], []>;

test bool shlouldGiveErrorWhenUsingNotImportedArtifact() =
	checkType(artifact("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(artifact("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], [
		<|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" not imported, but used as type in /User.g on line 10">
	]>;

test bool shlouldNotGiveErrorWhenUsingImportedArtifact() =
	checkType(artifact("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(artifact("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (
		"Date": \import("Date", namespace("Test"), "Date")
	), [], []>) == 
	<|tmp:///User.g|, (), (
		"Date": \import("Date", namespace("Test"), "Date")
	), [], []>;
	
test bool shlouldGiveErrorWhenUsingRepositoryWithNotImportedEntity() =
	checkType(repository("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(repository("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (), [], []>) == 
	<|tmp:///User.g|, (), (), [], [
		<|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" not imported, but used for a repository in /User.g on line 10">
	]>;
	
test bool shlouldGiveErrorWhenUsingRepositoryWithNotImportedEntity() =
	checkType(repository("Date")[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], 
		param(repository("Date"), "prop", emptyExpr())[@src=|tmp:///User.g|(0, 0, <10, 10>, <20, 20>)], <|tmp:///User.g|, (), (
			"Date": \import("Date", namespace("Test"), "Date")
		), [
			file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)]))
		], []>) == 
	<|tmp:///User.g|, (), (
			"Date": \import("Date", namespace("Test"), "Date")
		), [
			file(|tmp:///Date.g|, \module(namespace("Test"), [], util("Date", [])[@src=|tmp:///Date.g|(0, 0, <10, 10>, <20, 20>)]))
		], [
		<|tmp:///User.g|(0, 0, <10, 10>, <20, 20>), "\"Date\" is not an entity in /User.g on line 10">
	]>;



