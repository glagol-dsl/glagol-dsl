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


