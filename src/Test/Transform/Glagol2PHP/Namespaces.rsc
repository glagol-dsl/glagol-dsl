module Test::Transform::Glagol2PHP::Namespaces

import Transform::Glagol2PHP::Namespaces;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;

test bool shouldTransformToAPhpNamespace() = 
	toPhpNamespace(namespace("Test", namespace("Entity", namespace("User"))), 
		[], entity("User", []), <anyFramework(), doctrine()>) == 
	phpNamespace(
	  phpSomeName(phpName("Test\\Entity\\User")),
	  [
	    phpUse({phpUse(
	          phpName("Doctrine\\ORM\\Mapping"),
	          phpSomeName(phpName("ORM")))}),
	    phpClassDef(phpClass(
	        "User",
	        {},
	        phpNoName(),
	        [],
	        []))
	  ]) && toPhpNamespace(namespace("Test", namespace("Entity", namespace("User"))), 
		[], entity("User", []), <anyFramework(), doctrine()>).body[1].classDef@phpAnnotations == 
		{phpAnnotation("ORM\\Entity")};
