module Test::Transform::Glagol2PHP::Entities

import Transform::Env;
import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::Entities;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool shouldTransformToEntityPhpClassDefStmt() = 
	toPhpClassDef(entity("User", []), newTransformEnv(anyFramework(), doctrine())) ==
	phpClassDef(phpClass("User", {}, phpNoName(), [phpName("\\JsonSerializable")], [
	   phpTraitUse([phpName("JsonSerializeTrait")], [])
	])) &&
	toPhpClassDef(entity("User", []), newTransformEnv(anyFramework(), doctrine())).classDef@phpAnnotations ==
		{phpAnnotation("ORM\\Entity")};

test bool shouldTransformAnnotatedEntityToEntityPhpClassDefStmt() = 
	toPhpClassDef(entity("User", [])[@annotations=[]], newTransformEnv(anyFramework(), doctrine())) ==
	phpClassDef(phpClass("User", {}, phpNoName(), [phpName("\\JsonSerializable")], [
	   phpTraitUse([phpName("JsonSerializeTrait")], [])
	])) &&
	toPhpClassDef(entity("User", [])[@annotations=[annotation("doc", [annotationVal("This is a doc")])]], 
		newTransformEnv(anyFramework(), doctrine())).classDef@phpAnnotations ==
		{phpAnnotation("ORM\\Entity"), phpAnnotation("doc", phpAnnotationVal("This is a doc"))};
