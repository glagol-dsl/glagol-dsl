module Test::Transform::Glagol2PHP::Constructors::Overriding

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import Transform::Glagol2PHP::Entities;

test bool shouldAddOverriderWithRulesWhenTransformingOverridedConstructors() = 
    toPhpClassDef(entity("User", [
        constructor([param(integer(), "a")], []),
        constructor([param(string(), "b")], []),
        constructor([param(float(), "c")], [], equals(variable("c"), integer(7)))
    ]), <zend(), doctrine()>) == 
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [], [
            phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
                phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), []))),
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
                ]))
            ], phpNoName())
        ]
    ));

test bool shouldAddOverriderWithWhenRulesWhenTransformingOverridedConstructors() = 
    toPhpClassDef(entity("User", [
        constructor([param(integer(), "a")], [], equals(variable("a"), integer(7))),
        constructor([param(integer(), "b")], []),
        constructor([param(integer(), "c")], [], greaterThan(variable("c"), integer(13)))
    ]), <zend(), doctrine()>) == 
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [], [
            phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
                phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), []))),
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
                ]))
            ], phpNoName())
        ]
    ));
