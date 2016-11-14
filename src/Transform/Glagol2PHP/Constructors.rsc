module Transform::Glagol2PHP::Constructors

import Transform::Glagol2PHP::Params;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Overriding;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import List;

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [toPhpStmt(stmt) | stmt <- body], phpNoName());

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body, Expression when)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [
        phpIf(toPhpExpr(when), [toPhpStmt(stmt) | stmt <- body], [], phpNoElse())
    ], phpNoName());

public list[Declaration] getConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) := c || constructor(_, _, _) := c];
    
public list[Declaration] getNonConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) !:= c && constructor(_, _, _) !:= c];

public list[Declaration] getConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _, _) := c];

public list[Declaration] getNonConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _) !:= c];

public PhpClassItem createConstructor(list[Declaration] declarations)
    = phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
        phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [])))
    ] + [phpExprstmt(createOverrideRule(d)) | d <- declarations], phpNoName())
    when size(declarations) > 1;

public PhpClassItem createConstructor(list[Declaration] declarations) = toPhpClassItem(declarations[0]) when size(declarations) == 1;
