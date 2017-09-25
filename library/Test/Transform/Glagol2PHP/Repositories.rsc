module Test::Transform::Glagol2PHP::Repositories

import Transform::Env;
import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::Repositories;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

test bool shouldTransformToRepositoryPhpClassDefStmt() = 
	toPhpClassDef(repository("User", [
		property(string(), "a property", emptyExpr())
	]), newTransformEnv(anyFramework(), doctrine())) ==
	phpClassDef(phpClass("UserRepository", {}, phpSomeName(phpName("EntityRepository")), [], [
		phpProperty(
        {phpPrivate()},
        [phpProperty(
            "a property",
            phpNoExpr())])
	]));

test bool shouldTransformAnnotatedRepositoryToRepositoryPhpClassDefStmt() = 
	toPhpClassDef(repository("User", [])[@annotations=[]], newTransformEnv(anyFramework(), doctrine())) ==
	phpClassDef(phpClass("UserRepository", {}, phpSomeName(phpName("EntityRepository")), [], [])) &&
	toPhpClassDef(repository("User", [])[@annotations=[annotation("doc", [annotationVal("This is a doc")])]], newTransformEnv(anyFramework(), doctrine())).classDef@phpAnnotations ==
		{phpAnnotation("doc", phpAnnotationVal("This is a doc"))};

