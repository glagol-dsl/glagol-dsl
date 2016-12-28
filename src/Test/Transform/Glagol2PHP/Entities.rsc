module Test::Transform::Glagol2PHP::Entities

import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::Entities;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool shouldTransformToEntityPhpClassDefStmt() = 
	toPhpClassDef(entity("User", []), <anyFramework(), doctrine()>) ==
	phpClassDef(phpClass("User", {}, phpNoName(), [], [])) &&
	toPhpClassDef(entity("User", []), <anyFramework(), doctrine()>).classDef@phpAnnotations ==
		{phpAnnotation("ORM\\Entity")};

test bool shouldTransformAnnotatedEntityToEntityPhpClassDefStmt() = 
	toPhpClassDef(entity("User", [])[@annotations=[]], <anyFramework(), doctrine()>) ==
	phpClassDef(phpClass("User", {}, phpNoName(), [], [])) &&
	toPhpClassDef(entity("User", [])[@annotations=[annotation("doc", [annotationVal("This is a doc")])]], 
		<anyFramework(), doctrine()>).classDef@phpAnnotations ==
		{phpAnnotation("ORM\\Entity"), phpAnnotation("doc", phpAnnotationVal("This is a doc"))};
