module Test::Transform::Glagol2PHP::Methods::Overriding

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Entities;

test bool shouldAddOverriderWithRulesWhenTransformingOverridedMethods() = 
    toPhpClassDef(entity("User", [
        method(\public(), voidValue(), "test", [param(integer(), "a", emptyExpr())], [], emptyExpr()),
        method(\public(), voidValue(), "test", [param(string(), "b", emptyExpr())], [], emptyExpr()),
        method(\public(), voidValue(), "test", [param(float(), "c", emptyExpr())], [], equals(variable("c"), integer(7)))
    ]), <zend(), doctrine()>) == 
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [phpName("\\JsonSerializable")], [
            phpTraitUse([phpName("JsonSerializeTrait"), phpName("HydrateTrait")], []),
            phpMethod("test", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
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
                ])),
                phpNewLine(), 
                phpReturn(phpSomeExpr(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
                  phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
                ])))
            ], phpNoName())
        ]
    ));
