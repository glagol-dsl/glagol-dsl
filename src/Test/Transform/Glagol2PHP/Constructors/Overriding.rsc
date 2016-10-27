module Test::Transform::Glagol2PHP::Constructors::Overriding

extend Transform::Glagol2PHP::Doctrine;

test bool shouldAddIfElseIfBlocksWhenTransformingOverridedConstructors() = 
    toPhpStmt(entity("User", [
        constructor([param(integer(), "a")], []),
        constructor([param(string(), "b")], []),
        constructor([param(float(), "c")], [], equals(variable("a"), intLiteral(7)))
    ])) == 
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
                phpIf(phpBinaryOperation(phpVar(phpName(phpName("a"))), phpScalar(phpInteger(7)), phpIdentical()), [
                    phpExprstmt(phpMethodCall(
                        phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
                            phpActualParameter(phpClosure([], [phpParam("c", phpNoExpr(), phpSomeName(phpName("float")), false, false)], [], false, false), false),
                            phpActualParameter(phpNew(phpName(phpName("Parameter\\Real")), []), false)
                        ]
                    ))], [], phpNoElse())
            ])
        ]
    ));
