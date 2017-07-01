module Test::Transform::Glagol2PHP::ValueObjects

import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::ValueObjects;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool shouldTransformToValueObjectPhpClassDefStmt() = 
	toPhpClassDef(valueObject("Money", [
		property(string(), "a property", emptyExpr())
	]), <anyFramework(), anyORM()>) ==
	phpClassDef(phpClass("Money", {}, phpNoName(), [], [
		phpProperty(
        {phpPrivate()},
        [phpProperty(
            "a property",
            phpNoExpr())])
	]));

test bool shouldTransformAnnotatedValueObjectToValueObjectPhpClassDefStmt() = 
	toPhpClassDef(valueObject("Money", [])[@annotations=[]], <anyFramework(), anyORM()>) ==
	phpClassDef(phpClass("Money", {}, phpNoName(), [], [])) &&
	toPhpClassDef(valueObject("Money", [])[@annotations=[annotation("doc", [annotationVal("This is a doc")])]], <anyFramework(), anyORM()>).classDef@phpAnnotations ==
		{phpAnnotation("doc", phpAnnotationVal("This is a doc"))};

