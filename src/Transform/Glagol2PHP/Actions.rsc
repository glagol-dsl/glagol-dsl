module Transform::Glagol2PHP::Actions

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Params;

public PhpClassItem toPhpClassItem(a: action(str name, list[Declaration] params, list[Statement] body), env: <f: laravel(), ORM orm>)
    = phpMethod(
        name, 
        {phpPublic()}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [toPhpStmt(stmt) | stmt <- body], 
        phpNoName()
    )[
    	@phpAnnotations=toPhpAnnotations(a, env)
    ];
