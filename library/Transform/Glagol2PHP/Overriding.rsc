module Transform::Glagol2PHP::Overriding

import Transform::Env;
import Transform::OriginAnnotator;
import Transform::Glagol2PHP::Params;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Statements;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import List;

// TODO overriding has a bug with annotated parameters
public PhpExpr createOverrideRule(list[Declaration] params, list[Statement] body, TransformEnv env)
    = phpMethodCall(
        phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
            phpActualParameter(phpClosure([toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], [toPhpParam(p) | p <- params], [], false, false), false)
        ] + [phpActualParameter(createOverrideType(p.paramType), false) | p <- params]
    );
    
public PhpExpr createOverrideRule(list[Declaration] params, list[Statement] body, Expression when, TransformEnv env)
    = phpMethodCall(createOverrideRule(constructor(params, body, emptyExpr()), env), phpName(phpName("when")), [
        phpActualParameter(phpClosure([
            phpReturn(phpSomeExpr(toPhpExpr(when, addDefinitions(params, env))))
        ], [toPhpParam(param) | param <- params], [], false, false), false)
    ]);

public PhpExpr createOverrideRule(constructor(list[Declaration] params, list[Statement] body, emptyExpr()), TransformEnv env) 
    = createOverrideRule(params, body, env);
public PhpExpr createOverrideRule(constructor(list[Declaration] params, list[Statement] body, Expression when), TransformEnv env)
    = createOverrideRule(params, body, when, env);
public PhpExpr createOverrideRule(method(_, _, _, list[Declaration] params, list[Statement] body, emptyExpr()), TransformEnv env) 
    = createOverrideRule(params, body, env);
public PhpExpr createOverrideRule(method(_, _, _, list[Declaration] params, list[Statement] body, Expression when), TransformEnv env)
    = createOverrideRule(params, body, when, env);
    
private PhpExpr createOverrideType(e: integer()) = origin(phpNew(phpName(phpName("Parameter\\Integer")), []), e, true);
private PhpExpr createOverrideType(e: float()) = origin(phpNew(phpName(phpName("Parameter\\Real")), []), e, true);
private PhpExpr createOverrideType(e: string()) = origin(phpNew(phpName(phpName("Parameter\\Str")), []), e, true);
private PhpExpr createOverrideType(e: boolean()) = origin(phpNew(phpName(phpName("Parameter\\Boolean")), []), e, true);
private PhpExpr createOverrideType(e: \list(Type \type)) = origin(phpNew(origin(phpName(phpName("Parameter\\TypedList")), e, true), [
    origin(phpActualParameter(createOverrideType(\type), false), e)
]), e);
private PhpExpr createOverrideType(e: \map(Type key, Type v)) = origin(phpNew(origin(phpName(phpName("Parameter\\Map")), e, true), [
    origin(phpActualParameter(createOverrideType(key), false), key), origin(phpActualParameter(createOverrideType(v), false), v)
]), e);
private PhpExpr createOverrideType(a: artifact(Name name)) = origin(phpNew(origin(phpName(phpName("Parameter\\Custom")), a, true), [
    origin(phpActualParameter(origin(phpFetchClassConst(origin(phpName(phpName(name.localName)), name), "class"), a), false), a)
]), a);
private PhpExpr createOverrideType(r: repository(Name name)) = origin(phpNew(origin(phpName(phpName("Parameter\\Custom")), r, true), [
    origin(phpActualParameter(origin(phpScalar(phpString(name.localName + "Repository")), name, true), false), r)
]), r);
