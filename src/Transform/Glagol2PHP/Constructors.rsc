module Transform::Glagol2PHP::Constructors

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Params;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Overriding;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import List;

public PhpClassItem toPhpClassItem(d: constructor(list[Declaration] params, list[Statement] body), env) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], 
    	[toPhpStmt(stmt) | stmt <- body], phpNoName())[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];

public PhpClassItem toPhpClassItem(d: constructor(list[Declaration] params, list[Statement] body, Expression when), env) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [
        phpIf(toPhpExpr(when), [toPhpStmt(stmt) | stmt <- body], [], phpNoElse())
    ], phpNoName())[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];
    
public list[Declaration] getNonConstructors(list[Declaration] declarations)
    = [c | c <- declarations, !isConstructor(c)];

public list[Declaration] getConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _, _) := c];

public list[Declaration] getNonConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _) !:= c];

public PhpClassItem createConstructor(list[Declaration] declarations, env)
    = phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
        phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [])))
    ] + [phpExprstmt(createOverrideRule(d)) | d <- declarations], phpNoName())[
    	@phpAnnotations=({} | it + toPhpAnnotations(d, env) | d <- declarations)
    ]
    when size(declarations) > 1;

public PhpClassItem createConstructor(list[Declaration] declarations, env) = 
	toPhpClassItem(declarations[0], env) when size(declarations) == 1;
