module Test::Transform::Glagol2PHP::ClassItems

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::ClassItems;
import Config::Reader;

test bool shouldAddPhpAnnotationsToPhpClassDef() = 
	toPhpClassDef(annotated([], entity("Bla", [])), <anyFramework(), doctrine()>).classDef@phpAnnotations?;

test bool shouldAddAnnotationsToPhpClassItems() = 
	toPhpClassItem(annotated([
		annotation("Id", [])
	], constructor([], [])), <anyFramework(), doctrine()>)@phpAnnotations?;

test bool shouldTransformPropertiesToPhpClassItems() = 
	toPhpClassItems([
		property(voidValue(), "prop1", {}),
		property(voidValue(), "prop2", {}),
		property(voidValue(), "prop3", {}),
		annotated([], property(voidValue(), "prop4", {}))
	], <anyFramework(), anyORM()>) == 
	[
		phpProperty({phpPrivate()}, [phpProperty("prop1", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop2", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop3", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop4", phpNoExpr())])
	];

test bool shouldTransformConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([], [])
	], <anyFramework(), anyORM()>) == 
	[phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName())];

test bool shouldTransformOverridingConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([param(string(), "a")], []),
		constructor([param(integer(), "b")], [])
	], <anyFramework(), anyORM()>) == 
	[phpMethod(
    "__construct",
    {phpPublic()},
    false,
    [phpParam(
        "args",
        phpNoExpr(),
        phpNoName(),
        false,
        true)],
    [
      phpExprstmt(phpAssign(
          phpVar(phpName(phpName("overrider"))),
          phpNew(
            phpName(phpName("Overrider")),
            []))),
      phpExprstmt(phpMethodCall(
          phpVar(phpName(phpName("overrider"))),
          phpName(phpName("override")),
          [
            phpActualParameter(
              phpClosure(
                [],
                [phpParam(
                    "a",
                    phpNoExpr(),
                    phpSomeName(phpName("string")),
                    false,
                    false)],
                [],
                false,
                false),
              false),
            phpActualParameter(
              phpNew(
                phpName(phpName("Parameter\\Str")),
                []),
              false)
          ])),
      phpExprstmt(phpMethodCall(
          phpVar(phpName(phpName("overrider"))),
          phpName(phpName("override")),
          [
            phpActualParameter(
              phpClosure(
                [],
                [phpParam(
                    "b",
                    phpNoExpr(),
                    phpSomeName(phpName("int")),
                    false,
                    false)],
                [],
                false,
                false),
              false),
            phpActualParameter(
              phpNew(
                phpName(phpName("Parameter\\Integer")),
                []),
              false)
          ]))
    ],
    phpNoName())];

test bool shouldTransformMethodsToPhpClassItems() = 
	toPhpClassItems([
		method(\private(), voidValue(), "a", [], []),
		method(\private(), voidValue(), "b", [], []),
		method(\private(), voidValue(), "c", [], [])
	], <anyFramework(), anyORM()>) == 
	[
		phpMethod("a", {phpPrivate()}, false, [], [], phpNoName()),
		phpMethod("b", {phpPrivate()}, false, [], [], phpNoName()),
		phpMethod("c", {phpPrivate()}, false, [], [], phpNoName())
	];

test bool shouldTransformMethodsWithOverridingToPhpClassItems() = 
	toPhpClassItems([
		method(\private(), voidValue(), "a", [], []),
		method(\private(), voidValue(), "a", [param(string(), "blah")], [])
	], <anyFramework(), anyORM()>) == 
	[
		phpMethod(
		    "a",
		    {phpPrivate()},
		    false,
		    [phpParam(
		        "args",
		        phpNoExpr(),
		        phpNoName(),
		        false,
		        true)],
		    [
		      phpExprstmt(phpAssign(
		          phpVar(phpName(phpName("overrider"))),
		          phpNew(
		            phpName(phpName("Overrider")),
		            []))),
		      phpExprstmt(phpMethodCall(
		          phpVar(phpName(phpName("overrider"))),
		          phpName(phpName("override")),
		          [phpActualParameter(
		              phpClosure(
		                [],
		                [],
		                [],
		                false,
		                false),
		              false)])),
		      phpExprstmt(phpMethodCall(
		          phpVar(phpName(phpName("overrider"))),
		          phpName(phpName("override")),
		          [
		            phpActualParameter(
		              phpClosure(
		                [],
		                [phpParam(
		                    "blah",
		                    phpNoExpr(),
		                    phpSomeName(phpName("string")),
		                    false,
		                    false)],
		                [],
		                false,
		                false),
		              false),
		            phpActualParameter(
		              phpNew(
		                phpName(phpName("Parameter\\Str")),
		                []),
		              false)
		          ]))
		    ],
		    phpNoName())
	];

test bool shouldTransformRelationsToPhpClassItems() = 
	toPhpClassItems([
		relation(\one(), \one(), "User", "owner", {})
	], <anyFramework(), doctrine()>) == 
	[
		phpProperty(
		    {phpPrivate()},
		    [phpProperty(
		        "owner",
		        phpNoExpr())])
	] && toPhpClassItems([
		relation(\one(), \one(), "User", "owner", {})
	], <anyFramework(), doctrine()>)[0]@phpAnnotations == 
	{phpAnnotation("ORM\\OneToOne", phpAnnotationVal(("targetEntity":phpAnnotationVal("User"))))};
	
