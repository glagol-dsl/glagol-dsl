module Transform::Glagol2PHP::Statements

import Transform::Env;
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

public PhpStmt toPhpStmt(ifThen(Expression when, Statement body), TransformEnv env) = 
    phpIf(toPhpExpr(when, env), [toPhpStmt(body, env)], [], phpNoElse());
    
public PhpStmt toPhpStmt(ifThenElse(Expression when, Statement body, Statement \else), TransformEnv env) = 
    phpIf(toPhpExpr(when, env), [toPhpStmt(body, env)], [], phpSomeElse(phpElse([toPhpStmt(\else, env)])));

public PhpStmt toPhpStmt(expression(Expression expr), TransformEnv env) = phpExprstmt(toPhpExpr(expr, env));

public PhpStmt toPhpStmt(block(list[Statement] body), TransformEnv env) = phpBlock([toPhpStmt(stmt, env) | stmt <- body]);

public PhpStmt toPhpStmt(assign(Expression assignable, defaultAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssign(toPhpExpr(assignable, env), toPhpExpr(val, env)));

public PhpStmt toPhpStmt(assign(Expression assignable, defaultAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssign(toPhpExpr(assignable, env), toPhpExpr(val, env)));

public PhpStmt toPhpStmt(assign(Expression assignable, divisionAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), phpDiv()));

public PhpStmt toPhpStmt(assign(Expression assignable, productAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), phpMul()));
    
public PhpStmt toPhpStmt(assign(Expression assignable, subtractionAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), phpMinus()));
    
public PhpStmt toPhpStmt(assign(Expression assignable, additionAssign(), expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), phpPlus()));
    
public PhpStmt toPhpStmt(\return(emptyExpr()), TransformEnv env) = phpReturn(phpNoExpr());
public PhpStmt toPhpStmt(\return(Expression expr), TransformEnv env) = phpReturn(phpSomeExpr(toPhpExpr(expr, env)));

public PhpStmt toPhpStmt(persist(Expression expr), TransformEnv env) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("persist")), [
    phpActualParameter(toPhpExpr(expr, env), false)
]));

public PhpStmt toPhpStmt(remove(Expression expr), TransformEnv env) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("remove")), [
    phpActualParameter(toPhpExpr(expr, env), false)
]));

public PhpStmt toPhpStmt(flush(emptyExpr()), TransformEnv env) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("flush")), []));

public PhpStmt toPhpStmt(flush(Expression expr), TransformEnv env) = phpExprstmt(phpMethodCall(phpPropertyFetch(
    phpVar("this"), phpName(phpName("_em"))
), phpName(phpName("flush")), [
    phpActualParameter(toPhpExpr(expr, env), false)
]));

public PhpStmt toPhpStmt(declare(Type t, Expression var, emptyStmt()), TransformEnv env) 
    = phpExprstmt(phpAssign(toPhpExpr(var, env), phpScalar(phpNull())));
    
public PhpStmt toPhpStmt(declare(Type t, Expression var, expression(Expression val)), TransformEnv env)
    = phpExprstmt(phpAssign(toPhpExpr(var, env), toPhpExpr(val, env)));
    
public PhpStmt toPhpStmt(declare(Type t, Expression var, defaultValue: assign(assignable, op, expr)), TransformEnv env)
    = phpExprstmt(phpAssign(toPhpExpr(var, env), toPhpStmt(defaultValue, env).expr));

public PhpStmt toPhpStmt(foreach(Expression \list, emptyExpr(), Expression varName, Statement body, []), TransformEnv env)
    = phpForeach(toPhpExpr(\list, env), phpNoExpr(), false, toPhpExpr(varName, env), [toPhpStmt(body, env)]);
    
public PhpStmt toPhpStmt(foreach(Expression \list, Expression key, Expression varName, Statement body, []), TransformEnv env)
    = phpForeach(toPhpExpr(\list, env), phpSomeExpr(toPhpExpr(key, env)), false, toPhpExpr(varName, env), [toPhpStmt(body, env)]);
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) = toPhpExpr(conditions[0], env) when size(conditions) == 1;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) 
    = phpBinaryOperation(toPhpExpr(conditions[0], env), toPhpExpr(conditions[1], env), op) when size(conditions) == 2;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) {
    tuple[Expression element, list[Expression] rest] first = pop(conditions);

    return phpBinaryOperation(toPhpExpr(first.element, env), toBinaryOperation(first.rest, op, env), op);
}

public PhpStmt toPhpStmt(foreach(Expression \list, emptyExpr(), Expression varName, Statement body, list[Expression] conditions), TransformEnv env)
    = phpForeach(toPhpExpr(\list, env), phpNoExpr(), false, toPhpExpr(varName, env), [
        phpIf(toBinaryOperation(conditions, phpLogicalAnd(), env), [toPhpStmt(body, env)], [], phpNoElse())
    ]);
    
public PhpStmt toPhpStmt(foreach(Expression \list, Expression key, Expression varName, Statement body, list[Expression] conditions), TransformEnv env)
    = phpForeach(toPhpExpr(\list, env), phpSomeExpr(toPhpExpr(key, env)), false, toPhpExpr(varName, env), [
        phpIf(toBinaryOperation(conditions, phpLogicalAnd(), env), [toPhpStmt(body, env)], [], phpNoElse())
    ]);
    
public PhpStmt toPhpStmt(\continue(1), TransformEnv env) = phpContinue(phpNoExpr());
public PhpStmt toPhpStmt(\continue(int level), TransformEnv env) = phpContinue(phpSomeExpr(phpScalar(phpInteger(level))));

public PhpStmt toPhpStmt(\break(1), TransformEnv env) = phpBreak(phpNoExpr());
public PhpStmt toPhpStmt(\break(int level), TransformEnv env) = phpBreak(phpSomeExpr(phpScalar(phpInteger(level))));
