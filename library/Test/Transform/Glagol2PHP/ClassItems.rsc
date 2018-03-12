module Test::Transform::Glagol2PHP::ClassItems

import Transform::Env;
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
		newTransformEnv(anyFramework(), doctrine())).classDef@phpAnnotations?;

test bool shouldAddAnnotationsToPhpClassItems() = 
	toPhpClassItem(constructor([], [], emptyExpr())[@annotations=[annotation("Id", [])]], 
		newTransformEnv(anyFramework(), doctrine()))@phpAnnotations?;

test bool shouldTransformPropertiesToPhpClassItems() = 
	toPhpClassItems([
		property(voidValue(), "prop1", emptyExpr()),
		property(voidValue(), "prop2", emptyExpr()),
		property(voidValue(), "prop3", emptyExpr()),
		property(voidValue(), "prop4", emptyExpr())[@annotations=[]]
	], setContext(entity("", []), newTransformEnv(anyFramework(), anyORM()))) ==
	[
		phpProperty({phpPrivate()}, [phpProperty("prop1", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop2", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop3", phpNoExpr())]),
		phpProperty({phpPrivate()}, [phpProperty("prop4", phpNoExpr())])
	];

test bool shouldTransformConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([], [], emptyExpr())
	], setContext(entity("", []), newTransformEnv(anyFramework(), anyORM()))) ==
	[phpMethod("__construct", {phpPublic()}, false, [], [], phpNoName())];

test bool shouldTransformOverridingConstructorsToPhpClassItems() = 
	toPhpClassItems([
		constructor([param(string(), "a", emptyExpr())], [], emptyExpr()),
		constructor([param(integer(), "b", emptyExpr())], [], emptyExpr())
	], setContext(entity("", []), newTransformEnv(anyFramework(), anyORM()))) ==
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
            [
	        	phpActualParameter(phpScalar(phpBoolean(true)), false),
	        	phpActualParameter(phpScalar(phpString("")), false)
	        ]))),
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
	], setContext(entity("", []), newTransformEnv(anyFramework(), anyORM()))) ==
	[
		phpMethod("a", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}],
		phpMethod("b", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}],
		phpMethod("c", {phpPrivate()}, false, [], [], phpNoName())[@phpAnnotations={}]
	];

test bool shouldTransformMethodsWithOverridingToPhpClassItems() = 
	toPhpClassItems([
		method(\private(), voidValue(), "a", [], [], emptyExpr()),
		method(\private(), voidValue(), "a", [param(string(), "blah", emptyExpr())], [], emptyExpr())
	], setContext(util("", [], notProxy()), newTransformEnv(anyFramework(), anyORM()))) ==
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
		            [
			        	phpActualParameter(phpScalar(phpBoolean(false)), false),
			        	phpActualParameter(phpScalar(phpString("")), false),
			        	phpActualParameter(phpScalar(phpString("a")), false)
			        ]))),
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
	
