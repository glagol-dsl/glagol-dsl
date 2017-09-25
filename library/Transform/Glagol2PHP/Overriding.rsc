module Transform::Glagol2PHP::Overriding

import Transform::Env;
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
    
private PhpExpr createOverrideType(integer()) = phpNew(phpName(phpName("Parameter\\Integer")), []);
private PhpExpr createOverrideType(float()) = phpNew(phpName(phpName("Parameter\\Real")), []);
private PhpExpr createOverrideType(string()) = phpNew(phpName(phpName("Parameter\\Str")), []);
private PhpExpr createOverrideType(boolean()) = phpNew(phpName(phpName("Parameter\\Boolean")), []);
private PhpExpr createOverrideType(\list(Type \type)) = phpNew(phpName(phpName("Parameter\\TypedList")), [
    phpActualParameter(createOverrideType(\type), false)
]);
private PhpExpr createOverrideType(\map(Type key, Type v)) = phpNew(phpName(phpName("Parameter\\Map")), [
    phpActualParameter(createOverrideType(key), false), phpActualParameter(createOverrideType(v), false)
]);
private PhpExpr createOverrideType(artifact(Name name)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpFetchClassConst(phpName(phpName(name.localName)), "class"), false)
]);
private PhpExpr createOverrideType(repository(Name name)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpScalar(phpString(name.localName + "Repository")), false)
]);
