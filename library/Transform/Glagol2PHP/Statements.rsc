module Transform::Glagol2PHP::Statements

import Transform::Env;
import Transform::OriginAnnotator;
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

public PhpStmt toPhpStmt(e: ifThen(Expression when, Statement body), TransformEnv env) = 
    origin(phpIf(toPhpExpr(when, env), [toPhpStmt(body, env)], [], phpNoElse()), e);
    
public PhpStmt toPhpStmt(e: ifThenElse(Expression when, Statement body, Statement \else), TransformEnv env) = 
    origin(phpIf(toPhpExpr(when, env), [toPhpStmt(body, env)], [], origin(phpSomeElse(phpElse([toPhpStmt(\else, env)])), \else)), e);

public PhpStmt toPhpStmt(e: expression(Expression expr), TransformEnv env) = origin(phpExprstmt(toPhpExpr(expr, env)), e);

public PhpStmt toPhpStmt(e: block(list[Statement] body), TransformEnv env) = origin(phpBlock([toPhpStmt(stmt, env) | stmt <- body]), e);

public PhpStmt toPhpStmt(e: assign(Expression assignable, defaultAssign(), expression(Expression val)), TransformEnv env)
    = origin(
    	phpExprstmt(
    		origin(phpAssign(toPhpExpr(assignable, env), toPhpExpr(val, env)), e)), e);

public PhpStmt toPhpStmt(e: assign(Expression assignable, defaultAssign(), expression(Expression val)), TransformEnv env)
    = origin(phpExprstmt(origin(phpAssign(toPhpExpr(assignable, env), toPhpExpr(val, env)), e)), e);

public PhpStmt toPhpStmt(e: assign(Expression assignable, d: divisionAssign(), expression(Expression val)), TransformEnv env)
    = origin(phpExprstmt(origin(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), origin(phpDiv(), d)), e)), e);

public PhpStmt toPhpStmt(e: assign(Expression assignable, d: productAssign(), expression(Expression val)), TransformEnv env)
    = origin(phpExprstmt(origin(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), origin(phpMul(), d)), e)), e);
    
public PhpStmt toPhpStmt(e: assign(Expression assignable, d: subtractionAssign(), expression(Expression val)), TransformEnv env)
    = origin(phpExprstmt(origin(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), origin(phpMinus(), d)), e)), e);
    
public PhpStmt toPhpStmt(e: assign(Expression assignable, d: additionAssign(), expression(Expression val)), TransformEnv env)
    = origin(phpExprstmt(origin(phpAssignWOp(toPhpExpr(assignable, env), toPhpExpr(val, env), origin(phpPlus(), d)), e)), e);
    
public PhpStmt toPhpStmt(e: \return(emptyExpr()), TransformEnv env) = origin(phpReturn(phpNoExpr()), e, true);
public PhpStmt toPhpStmt(e: \return(Expression expr), TransformEnv env) = origin(phpReturn(origin(phpSomeExpr(toPhpExpr(expr, env)), e)), e);

public PhpStmt toPhpStmt(e: persist(Expression expr), TransformEnv env) = 
	origin(
		phpExprstmt(
			origin(
				phpMethodCall(
					origin(
						phpPropertyFetch(
					    phpVar("this"), phpName(phpName("_em"))
					), e, true), 
					origin(phpName(phpName("persist")), e, true), 
					[origin(phpActualParameter(toPhpExpr(expr, env), false), expr)]
				), e
			)
		), e
	);

public PhpStmt toPhpStmt(e: remove(Expression expr), TransformEnv env) = 
	origin(
		phpExprstmt(
			origin(
				phpMethodCall(
					origin(
						phpPropertyFetch(
					    phpVar("this"), phpName(phpName("_em"))
					), e, true), 
					origin(phpName(phpName("remove")), e, true), 
					[origin(phpActualParameter(toPhpExpr(expr, env), false), expr)]
				), e
			)
		), e
	);

public PhpStmt toPhpStmt(e: flush(emptyExpr()), TransformEnv env) = 
	origin(
		phpExprstmt(
			origin(
				phpMethodCall(
					origin(
						phpPropertyFetch(
					    phpVar("this"), phpName(phpName("_em"))
					), e, true), 
					origin(phpName(phpName("flush")), e, true), []
				), e
			)
		), e
	);

public PhpStmt toPhpStmt(e: flush(Expression expr), TransformEnv env) = 
	origin(
		phpExprstmt(
			origin(
				phpMethodCall(
					origin(
						phpPropertyFetch(
					    phpVar("this"), phpName(phpName("_em"))
					), e, true), 
					origin(phpName(phpName("flush")), e, true), 
					[origin(phpActualParameter(toPhpExpr(expr, env), false), expr)]
				), e
			)
		), e
	);

public PhpStmt toPhpStmt(e: declare(Type t, Expression var, emptyStmt()), TransformEnv env) = 
	origin(phpExprstmt(origin(phpAssign(toPhpExpr(var, env), origin(phpScalar(phpNull()), e, true)), e)), e);
    
public PhpStmt toPhpStmt(e: declare(Type t, Expression var, expression(Expression val)), TransformEnv env) = 
	origin(phpExprstmt(origin(phpAssign(toPhpExpr(var, env), toPhpExpr(val, env)), e)), e);
    
public PhpStmt toPhpStmt(e: declare(Type t, Expression var, defaultValue: assign(assignable, op, expr)), TransformEnv env) = 
	origin(phpExprstmt(origin(phpAssign(toPhpExpr(var, env), toPhpStmt(defaultValue, env).expr), e)), e);

public PhpStmt toPhpStmt(e: foreach(Expression \list, emptyExpr(), Expression varName, Statement body, []), TransformEnv env) = 
	origin(phpForeach(toPhpExpr(\list, env), origin(phpNoExpr(), e), false, toPhpExpr(varName, env), [toPhpStmt(body, env)]), e);
    
public PhpStmt toPhpStmt(e: foreach(Expression \list, Expression key, Expression varName, Statement body, []), TransformEnv env) = 
	origin(phpForeach(toPhpExpr(\list, env), origin(phpSomeExpr(toPhpExpr(key, env)), key), false, toPhpExpr(varName, env), [toPhpStmt(body, env)]), e);
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) = toPhpExpr(conditions[0], env) when size(conditions) == 1;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) 
    = origin(phpBinaryOperation(toPhpExpr(conditions[0], env), toPhpExpr(conditions[1], env), op), conditions[0]) when size(conditions) == 2;
    
private PhpExpr toBinaryOperation(list[Expression] conditions, PhpOp op, TransformEnv env) {
    tuple[Expression element, list[Expression] rest] first = pop(conditions);

    return origin(phpBinaryOperation(toPhpExpr(first.element, env), toBinaryOperation(first.rest, op, env), op), first.element);
}

public PhpStmt toPhpStmt(e: foreach(Expression \list, emptyExpr(), Expression varName, Statement body, list[Expression] conditions), TransformEnv env)
    = origin(phpForeach(toPhpExpr(\list, env), origin(phpNoExpr(), e), false, toPhpExpr(varName, env), [
        origin(phpIf(toBinaryOperation(conditions, phpLogicalAnd(), env), [toPhpStmt(body, env)], [], phpNoElse()), conditions[0])
    ]), e);
    
public PhpStmt toPhpStmt(e: foreach(Expression \list, Expression key, Expression varName, Statement body, list[Expression] conditions), TransformEnv env)
    = origin(phpForeach(toPhpExpr(\list, env), origin(phpSomeExpr(toPhpExpr(key, env)), key), false, toPhpExpr(varName, env), [
        origin(phpIf(toBinaryOperation(conditions, phpLogicalAnd(), env), [toPhpStmt(body, env)], [], phpNoElse()), conditions[0])
    ]), e);
    
public PhpStmt toPhpStmt(e: \continue(1), TransformEnv env) = origin(phpContinue(phpNoExpr()), e, true);
public PhpStmt toPhpStmt(e: \continue(int level), TransformEnv env) = origin(phpContinue(phpSomeExpr(phpScalar(phpInteger(level)))), e, true);

public PhpStmt toPhpStmt(e: \break(1), TransformEnv env) = origin(phpBreak(phpNoExpr()), e, true);
public PhpStmt toPhpStmt(e: \break(int level), TransformEnv env) = origin(phpBreak(phpSomeExpr(phpScalar(phpInteger(level)))), e, true);
