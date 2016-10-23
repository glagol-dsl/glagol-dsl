module Test::Transform::Glagol2PHP::Constructors::Overriding

extend Transform::Glagol2PHP::Doctrine;

test bool shhouldAddIfElseIfBlocksWhenTransformingOverridedConstructors() = 
    toPhpStmt(entity("User", [
        constructor([param(integer(), "a")], [], equals(variable("a"), intLiteral(7))),
        constructor([param(string(), "name")], [], equals(variable("name"), strLiteral("Avitohol")))
    ])) == 
    phpClassDef(phpClass(
        "User", {}, phpNoName(), [], [
            phpMethod("__construct", {phpPublic()}, false, [], [
                phpIf(phpBinaryOperation(phpVar(phpName(phpName("a"))), phpScalar(phpInteger(7)), phpIdentical()), [], [
                    phpElseIf(phpBinaryOperation(phpVar(phpName(phpName("name"))), phpScalar(phpString("Avitohol")), phpIdentical()), [])
                ], phpNoElse())
            ])
        ]
    ));
