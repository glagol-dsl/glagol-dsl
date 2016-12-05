module Transform::Glagol2PHP::Statements

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
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
