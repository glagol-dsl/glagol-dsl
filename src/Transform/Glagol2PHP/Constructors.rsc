module Transform::Glagol2PHP::Constructors

import Transform::Glagol2PHP::Params;
//import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [toPhpStmt(stmt) | stmt <- body]);

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body, Expression when)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [
        phpIf(toPhpExpr(when), [toPhpStmt(stmt) | stmt <- body], [], phpNoElse())
    ]);

public list[Declaration] getConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) := c || constructor(_, _, _) := c];
    
public list[Declaration] getNonConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) !:= c && constructor(_, _, _) !:= c];

public list[Declaration] getConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _, _) !:= c];

public list[Declaration] getNonConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _) !:= c];

public list[PhpClassItem] createOverridedConstructor(list[Declaration] declarations);
