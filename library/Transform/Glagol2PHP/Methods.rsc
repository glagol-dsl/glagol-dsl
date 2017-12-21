module Transform::Glagol2PHP::Methods

import Transform::Env;
import Transform::OriginAnnotator;
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
    = origin(phpMethod(
        name, 
        {toPhpModifier(modifier)}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], 
        toPhpReturnType(returnType)
    )[@phpAnnotations=toPhpAnnotations(d, env)], d);

public PhpClassItem toPhpClassItem(d: method(modifier, returnType, name, params, body, Expression when), TransformEnv env)
    = origin(phpMethod(
        name,
        {toPhpModifier(modifier)}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [origin(phpIf(toPhpExpr(when, addDefinitions(params, env)), [toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], [], origin(phpNoElse(), when)), when)], 
        toPhpReturnType(returnType)
    )[@phpAnnotations=toPhpAnnotations(d, env)], d);

public PhpClassItem createMethod(list[Declaration] methods, TransformEnv env)
    = toPhpClassItem(methods[0], env)
    when size(methods) == 1;

public PhpClassItem createMethod(list[Declaration] methods, TransformEnv env) = 
    origin(phpMethod(methods[0].name, {toPhpModifier(methods[0].modifier)}, false, [origin(phpParam("args", phpNoExpr(), phpNoName(), false, true), methods[0], true)], 
        [phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [])))] + 
        [origin(phpExprstmt(createOverrideRule(m, env)), m) | m <- methods] +
        [phpNewLine()] +
        [phpReturn(phpSomeExpr(phpMethodCall(phpVar(phpName(phpName("overrider"))), phpName(phpName("execute")), [
          phpActualParameter(phpVar(phpName(phpName("args"))), false, true)
        ])))], toPhpReturnType(methods[0].returnType))[
    	@phpAnnotations={annotation | m <- methods, annotation <- toPhpAnnotations(m, env)}
    ], methods[0])
    when size(methods) > 1;

private PhpOptionName toPhpReturnType(e: voidValue()) = origin(phpNoName(), e);
private PhpOptionName toPhpReturnType(e: integer()) = origin(phpSomeName(phpName("int")), e);
private PhpOptionName toPhpReturnType(e: string()) = origin(phpSomeName(phpName("string")), e);
private PhpOptionName toPhpReturnType(e: boolean()) = origin(phpSomeName(phpName("bool")), e);
private PhpOptionName toPhpReturnType(e: float()) = origin(phpSomeName(phpName("float")), e);
private PhpOptionName toPhpReturnType(e: \list(_)) = origin(phpSomeName(phpName("iterable")), e);
private PhpOptionName toPhpReturnType(e: \map(_,_)) = origin(phpSomeName(phpName("iterable")), e);
private PhpOptionName toPhpReturnType(e: artifact(Name name)) = origin(phpSomeName(phpName(extractName(name))), e);
private PhpOptionName toPhpReturnType(e: repository(Name name)) = origin(phpSomeName(phpName(extractName(name) + "Repository")), e);

private PhpModifier toPhpModifier(p: \public()) = origin(phpPublic(), p);
private PhpModifier toPhpModifier(p: \private()) = origin(phpPrivate(), p);
