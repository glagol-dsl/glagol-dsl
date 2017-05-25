module Test::Transform::Glagol2PHP::ClassItems

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Config::Config;

test bool shouldAddPhpAnnotationsToPhpClassDef() = 
	toPhpClassDef(entity("Bla", [])[@annotations=[annotation("doc", [annotationVal("a doc")])]], 
		<anyFramework(), doctrine()>).classDef@phpAnnotations?;

test bool shouldAddAnnotationsToPhpClassItems() = 
	toPhpClassItem(constructor([], [], emptyExpr())[@annotations=[annotation("Id", [])]], 
		<anyFramework(), doctrine()>)@phpAnnotations?;

test bool shouldTransformPropertiesToPhpClassItems() = 
	toPhpClassItems([
		property(voidValue(), "prop1", {}, emptyExpr()),
		property(voidValue(), "prop2", {}, emptyExpr()),
		property(voidValue(), "prop3", {}, emptyExpr()),
		property(voidValue(), "prop4", {}, emptyExpr())[@annotations=[]]
	], <anyFramework(), anyORM()>, entity("", [])) == 
	[
		phpProperty({phpPrivate()}, [phpProperty("prop1", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop2", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop3", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop4", phpNoExpr())])
	];

test bool shouldTransformConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([], [], emptyExpr())
	], <anyFramework(), anyORM()>, entity("", [])) == 
	[phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName())];

test bool shouldTransformOverridingConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([param(string(), "a", emptyExpr())], [], emptyExpr()),
		constructor([param(integer(), "b", emptyExpr())], [], emptyExpr())
	], <anyFramework(), anyORM()>, entity("", [])) == 
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
          ])),
      phpNewLine(),
      phpExprstmt(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
        phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
      ]))
    ],
    phpNoName())];

test bool shouldTransformMethodsToPhpClassItems() = 
	toPhpClassItems([
		method(\private(), voidValue(), "a", [], [], emptyExpr()),
		method(\private(), voidValue(), "b", [], [], emptyExpr()),
		method(\private(), voidValue(), "c", [], [], emptyExpr())
	], <anyFramework(), anyORM()>, entity("", [])) == 
	[
		phpMethod("a", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}],
		phpMethod("b", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}],
		phpMethod("c", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}]
	];

test bool shouldTransformMethodsWithOverridingToPhpClassItems() = 
	toPhpClassItems([
		method(\private(), voidValue(), "a", [], [], emptyExpr()),
		method(\private(), voidValue(), "a", [param(string(), "blah", emptyExpr())], [], emptyExpr())
	], <anyFramework(), anyORM()>, util("", [])) == 
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
		          ])),
      			phpNewLine(),
	            phpReturn(phpSomeExpr(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
                  phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
                ])))
		    ],
		    phpNoName())
	];

test bool shouldTransformRelationsToPhpClassItems() = 
	toPhpClassItems([
		relation(\one(), \one(), "User", "owner", {})
	], <anyFramework(), doctrine()>, entity("", [])) == 
	[
		phpProperty(
		    {phpPrivate()},
		    [phpProperty(
		        "owner",
		        phpNoExpr())])
	] && toPhpClassItems([
		relation(\one(), \one(), "User", "owner", {})
	], <anyFramework(), doctrine()>, entity("", []))[0]@phpAnnotations == 
	{
		phpAnnotation("ORM\\OneToOne", phpAnnotationVal(("targetEntity":phpAnnotationVal("User")))),
		phpAnnotation("var", phpAnnotationVal("User"))
	};
	
