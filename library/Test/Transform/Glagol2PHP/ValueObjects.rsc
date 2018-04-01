module Test::Transform::Glagol2PHP::ValueObjects

import Transform::Env;
import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::ValueObjects;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool shouldTransformToValueObjectPhpClassDefStmt() = 
	toPhpClassDef(valueObject("Money", [
		property(string(), "a property", emptyExpr())
	], notProxy()), newTransformEnv(anyFramework(), anyORM())) ==
	phpClassDef(phpClass("Money", {}, phpNoName(), [phpName("\\JsonSerializable")], [
		phpTraitUse([phpName("\\Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait")], []),
		phpProperty(
        {phpPrivate()},
        [phpProperty(
            "a property",
            phpNoExpr())])
	]));

test bool shouldTransformAnnotatedValueObjectToValueObjectPhpClassDefStmt() = 
	toPhpClassDef(valueObject("Money", [], notProxy())[@annotations=[]], newTransformEnv(anyFramework(), anyORM())) ==
	phpClassDef(phpClass("Money", {}, phpNoName(), [phpName("\\JsonSerializable")], [phpTraitUse([phpName("\\Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait")], [])])) &&
	toPhpClassDef(valueObject("Money", [], notProxy())[@annotations=[annotation("doc", [annotationVal("This is a doc")])]], newTransformEnv(anyFramework(), anyORM())).classDef@phpAnnotations ==
		{phpAnnotation("doc", phpAnnotationVal("This is a doc"))};

