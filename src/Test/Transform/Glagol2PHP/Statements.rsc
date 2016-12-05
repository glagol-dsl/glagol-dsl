module Test::Transform::Glagol2PHP::Statements

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Statements;

test bool shouldTransformToIfWithoutElse() = 
    toPhpStmt(ifThen(greaterThan(intLiteral(21), variable("input")), expression(invoke("myFunc", [
        variable("input")
    ])))) ==
    phpIf(
        phpBinaryOperation(phpScalar(phpInteger(21)), phpVar(phpName(phpName("input"))), phpGt()),
        [
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("myFunc")), [
                phpActualParameter(phpVar(phpName(phpName("input"))), false)
            ]))
        ], [], phpNoElse()
    );

test bool shouldTransformToAnExpression() = 
    toPhpStmt(expression(greaterThanOrEq(floatLiteral(1.32), variable("input")))) ==
    phpExprstmt(phpBinaryOperation(phpScalar(phpFloat(1.32)), phpVar(phpName(phpName("input"))), phpGeq()));
    
test bool shouldTransformToABlock() =
    toPhpStmt(block([
        expression(greaterThanOrEq(variable("input"), strLiteral("blah"))),
        expression(equals(floatLiteral(1.32), variable("input")))
    ])) ==
    phpBlock([
        phpExprstmt(phpBinaryOperation(phpVar(phpName(phpName("input"))), phpScalar(phpString("blah")), phpGeq())),
        phpExprstmt(phpBinaryOperation(phpScalar(phpFloat(1.32)), phpVar(phpName(phpName("input"))), phpIdentical()))
    ]);

test bool shouldTransformToIfThenElse() =
    toPhpStmt(ifThenElse(equals(strLiteral("SOME_CONST"), variable("input")), expression(invoke("someFunc", [])), expression(invoke("someOtherFunc", [])))) ==
    phpIf(
        phpBinaryOperation(phpScalar(phpString("SOME_CONST")), phpVar(phpName(phpName("input"))), phpIdentical()),
        [
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("someFunc")), []))
        ], [], phpSomeElse(phpElse([
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("someOtherFunc")), []))
        ]))
    );
    
