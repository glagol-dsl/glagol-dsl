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

test bool shouldTransformToAssignUsingDefaultOperator() =
    toPhpStmt(assign(variable("trackID"), defaultAssign(), expression(intLiteral(89)))) == 
    phpExprstmt(phpAssign(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89))));

test bool shouldTransformToAssignUsingDivisionOperator() =
    toPhpStmt(assign(variable("trackID"), divisionAssign(), expression(intLiteral(89)))) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpDiv()));

test bool shouldTransformToAssignUsingProductOperator() =
    toPhpStmt(assign(variable("trackID"), productAssign(), expression(intLiteral(89)))) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpMul()));
    
test bool shouldTransformToAssignUsingSubOperator() =
    toPhpStmt(assign(variable("trackID"), subtractionAssign(), expression(intLiteral(89)))) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpMinus()));
    
test bool shouldTransformToAssignUsingAddOperator() =
    toPhpStmt(assign(variable("trackID"), additionAssign(), expression(intLiteral(89)))) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpPlus()));

test bool shouldTransformToReturnStmt() =
    toPhpStmt(\return(variable("output"))) ==
    phpReturn(phpSomeExpr(phpVar(phpName(phpName("output")))));

test bool shouldTransformToEmptyReturnStmt() = toPhpStmt(\return(emptyExpr())) == phpReturn(phpNoExpr());

test bool shouldTransformToNulledDeclaration() =
    toPhpStmt(declare(integer(), variable("var1"))) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpScalar(phpNull())));
    
test bool shouldTransformToDeclarationWithDefaultValue() =
    toPhpStmt(declare(integer(), variable("var1"), expression(intLiteral(23)))) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpScalar(phpInteger(23))));
    
test bool shouldTransformToDeclarationWithAssignAsDefaultValue() =
    toPhpStmt(declare(integer(), variable("var1"), assign(variable("var2"), defaultAssign(), expression(intLiteral(44))))) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpAssign(phpVar(phpName(phpName("var2"))), phpScalar(phpInteger(44)))));
