module Test::Transform::Glagol2PHP::Constructors::Overriding

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Entities;
import Transform::Env;

test bool shouldAddOverriderWithRulesWhenTransformingOverridedConstructors() = 
    toPhpClassDef(entity("User", [
        constructor([param(integer(), "a", emptyExpr())], [], emptyExpr()),
        constructor([param(string(), "b", emptyExpr())], [], emptyExpr()),
        constructor([param(float(), "c", emptyExpr())], [], equals(variable("c"), integer(7)))
    ]), setContext(entity("User", []), newTransformEnv())) ==
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [phpName("\\JsonSerializable")], [
            phpTraitUse([phpName("JsonSerializeTrait")], []),
            phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
                phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [
		        	phpActualParameter(phpScalar(phpBoolean(true)), false),
		        	phpActualParameter(phpScalar(phpString("User")), false)
		        ]))),
                phpExprstmt(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("a", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Integer")), []), false)
                    ]
                )),
                phpExprstmt(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("b", phpNoExpr(), phpSomeName(phpName("string")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Str")), []), false)
                    ]
                )),
                phpExprstmt(phpMethodCall(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), 
                    phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("c", phpNoExpr(), phpSomeName(phpName("float")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Real")), []), false)
                    ]
                ), phpName(phpName("when")), [
                    phpActualParameter(phpClosure([
                        phpReturn(phpSomeExpr(phpBinaryOperation(phpVar(phpName(phpName("c"))), phpScalar(phpInteger(7)), phpIdentical())))
                    ], [phpParam("c", phpNoExpr(), phpSomeName(phpName("float")), false, false)], [], false, false), false)
                ])),
                phpNewLine(),
                phpExprstmt(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
                  phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
                ]))
            ], phpNoName())
        ]
    ));

test bool shouldAddOverriderWithWhenRulesWhenTransformingOverridedConstructors() = 
    toPhpClassDef(entity("User", [
        constructor([param(integer(), "a", emptyExpr())], [], equals(variable("a"), integer(7))),
        constructor([param(integer(), "b", emptyExpr())], [], emptyExpr()),
        constructor([param(integer(), "c", emptyExpr())], [], greaterThan(variable("c"), integer(13)))
    ]), setContext(entity("User", []), newTransformEnv())) ==
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [phpName("\\JsonSerializable")], [
            phpTraitUse([phpName("JsonSerializeTrait")], []),
            phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
                phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [
		        	phpActualParameter(phpScalar(phpBoolean(true)), false),
		        	phpActualParameter(phpScalar(phpString("User")), false)
		        ]))),
                phpExprstmt(phpMethodCall(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("a", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Integer")), []), false)
                    ]
                ), phpName(phpName("when")), [
                    phpActualParameter(phpClosure([
                        phpReturn(phpSomeExpr(phpBinaryOperation(phpVar(phpName(phpName("a"))), phpScalar(phpInteger(7)), phpIdentical())))
                    ], [phpParam("a", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false)
                ])),
                phpExprstmt(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("b", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Integer")), []), false)
                    ]
                )),
                phpExprstmt(phpMethodCall(phpMethodCall(
                    phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                        phpActualParameter(phpClosure([], [phpParam("c", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false),
                        phpActualParameter(phpNew(phpName(phpName("Parameter\\Integer")), []), false)
                    ]
                ), phpName(phpName("when")), [
                    phpActualParameter(phpClosure([
                        phpReturn(phpSomeExpr(phpBinaryOperation(phpVar(phpName(phpName("c"))), phpScalar(phpInteger(13)), phpGt())))
                    ], [phpParam("c", phpNoExpr(), phpSomeName(phpName("int")), false, false)], [], false, false), false)
                ])),
                phpNewLine(),
                phpExprstmt(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
                  phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
                ]))
            ], phpNoName())
        ]
    ));
