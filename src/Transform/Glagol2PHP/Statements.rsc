module Transform::Glagol2PHP::Statements

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Config::Config;
import List;
import IO;

public PhpStmt toPhpStmt(ifThen(Expression when, Statement body)) = 
    phpIf(toPhpExpr(when), [toPhpStmt(body)], [], phpNoElse());
    
public PhpStmt toPhpStmt(ifThenElse(Expression when, Statement body, Statement \else)) = 
    phpIf(toPhpExpr(when), [toPhpStmt(body)], [], phpSomeElse(phpElse([toPhpStmt(\else)])));

public PhpStmt toPhpStmt(expression(Expression expr)) = phpExprstmt(toPhpExpr(expr));

public PhpStmt toPhpStmt(block(list[Statement] body)) = phpBlock([toPhpStmt(stmt) | stmt <- body]);

public PhpStmt toPhpStmt(assign(Expression assignable, defaultAssign(), expression(Expression val)))
    = phpExprstmt(phpAssign(toPhpExpr(assignable), toPhpExpr(val)));

public PhpStmt toPhpStmt(assign(Expression assignable, defaultAssign(), expression(Expression val)))
    = phpExprstmt(phpAssign(toPhpExpr(assignable), toPhpExpr(val)));

public PhpStmt toPhpStmt(assign(Expression assignable, divisionAssign(), expression(Expression val)))
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable), toPhpExpr(val), phpDiv()));

public PhpStmt toPhpStmt(assign(Expression assignable, productAssign(), expression(Expression val)))
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable), toPhpExpr(val), phpMul()));
    
public PhpStmt toPhpStmt(assign(Expression assignable, subtractionAssign(), expression(Expression val)))
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable), toPhpExpr(val), phpMinus()));
    
public PhpStmt toPhpStmt(assign(Expression assignable, additionAssign(), expression(Expression val)))
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable), toPhpExpr(val), phpPlus()));
    
public PhpStmt toPhpStmt(\return(emptyExpr())) = phpReturn(phpNoExpr());
public PhpStmt toPhpStmt(\return(Expression expr)) = phpReturn(phpSomeExpr(toPhpExpr(expr)));

public PhpStmt toPhpStmt(persist(Expression expr)) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("persist")), [
    phpActualParameter(toPhpExpr(expr), false)
]));

public PhpStmt toPhpStmt(remove(Expression expr)) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("remove")), [
    phpActualParameter(toPhpExpr(expr), false)
]));

public PhpStmt toPhpStmt(flush(Expression expr)) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("flush")), [
    phpActualParameter(toPhpExpr(expr), false)
]));

public PhpStmt toPhpStmt(flush(emptyExpr())) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("flush")), []));

public PhpStmt toPhpStmt(declare(Type t, Expression var)) 
    = phpExprstmt(phpAssign(toPhpExpr(var), phpScalar(phpNull())));
    
public PhpStmt toPhpStmt(declare(Type t, Expression var, expression(Expression val)))
    = phpExprstmt(phpAssign(toPhpExpr(var), toPhpExpr(val)));
    
public PhpStmt toPhpStmt(declare(Type t, Expression var, defaultValue: assign(assignable, op, expr)))
    = phpExprstmt(phpAssign(toPhpExpr(var), toPhpStmt(defaultValue).expr));

public PhpStmt toPhpStmt(foreach(Expression \list, Expression varName, Statement body))
    = phpForeach(toPhpExpr(\list), phpNoExpr(), false, toPhpExpr(varName), [toPhpStmt(body)]);
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op) = toPhpExpr(conditions[0]) when size(conditions) == 1;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op) 
    = phpBinaryOperation(toPhpExpr(conditions[0]), toPhpExpr(conditions[1]), op) when size(conditions) == 2;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op) {
    tuple[Expression element, list[Expression] rest] first = pop(conditions);

    return phpBinaryOperation(toPhpExpr(first.element), toBinaryOperation(first.rest, op), op);
}
    
public PhpStmt toPhpStmt(foreach(Expression \list, Expression varName, Statement body, list[Expression] conditions))
    = phpForeach(toPhpExpr(\list), phpNoExpr(), false, toPhpExpr(varName), [
        phpIf(toBinaryOperation(conditions, phpLogicalAnd()), [toPhpStmt(body)], [], phpNoElse())
    ]);
    
public PhpStmt toPhpStmt(\continue()) = phpContinue(phpNoExpr());
public PhpStmt toPhpStmt(\continue(int level)) = phpContinue(phpSomeExpr(phpScalar(phpInteger(level))));

public PhpStmt toPhpStmt(\break()) = phpBreak(phpNoExpr());
public PhpStmt toPhpStmt(\break(int level)) = phpBreak(phpSomeExpr(phpScalar(phpInteger(level))));
