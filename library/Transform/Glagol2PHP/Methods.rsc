module Transform::Glagol2PHP::Methods

import Transform::Env;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Params;
import Transform::Glagol2PHP::Overriding;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import List;

public PhpClassItem toPhpClassItem(d: method(modifier, returnType, name, params, body, emptyExpr()), TransformEnv env)
    = phpMethod(
        name, 
        {toPhpModifier(modifier)}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], 
        toPhpReturnType(returnType)
    )[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];

public PhpClassItem toPhpClassItem(d: method(modifier, returnType, name, params, body, Expression when), TransformEnv env)
    = phpMethod(
        name,
        {toPhpModifier(modifier)}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [phpIf(toPhpExpr(when, addDefinitions(params, env)), [toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], [], phpNoElse())], 
        toPhpReturnType(returnType)
    )[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];

public PhpClassItem createMethod(list[Declaration] methods, TransformEnv env)
    = toPhpClassItem(methods[0], env)
    when size(methods) == 1;

public PhpClassItem createMethod(list[Declaration] methods, TransformEnv env) = 
    phpMethod(methods[0].name, {toPhpModifier(methods[0].modifier)}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], 
        [phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [])))] + 
        [phpExprstmt(createOverrideRule(m, env)) | m <- methods] +
        [phpNewLine()] +
        [phpReturn(phpSomeExpr(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
          phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
        ])))], toPhpReturnType(methods[0].returnType))[
    	@phpAnnotations={annotation | m <- methods, annotation <- toPhpAnnotations(m, env)}
    ]
    when size(methods) > 1;

private PhpModifier toPhpModifier(\public()) = phpPublic();
private PhpModifier toPhpModifier(\private()) = phpPrivate();
