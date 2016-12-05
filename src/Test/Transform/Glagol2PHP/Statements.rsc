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
    
