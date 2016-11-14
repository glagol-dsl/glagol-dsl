module Transform::Glagol2PHP::Overriding

import Transform::Glagol2PHP::Params;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Statements;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import List;


public PhpExpr createOverrideRule(list[Declaration] params, list[Statement] body)
    = phpMethodCall(
        phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
            phpActualParameter(phpClosure([toPhpStmt(stmt) | stmt <- body], [toPhpParam(p) | p <- params], [], false, false), false)
        ] + [phpActualParameter(createOverrideType(p), false) | p <- params]
    );
    
public PhpExpr createOverrideRule(list[Declaration] params, list[Statement] body, Expression when)
    = phpMethodCall(createOverrideRule(constructor(params, body)), phpName(phpName("when")), [
        phpActualParameter(phpClosure([
            phpReturn(phpSomeExpr(toPhpExpr(when)))
        ], [toPhpParam(param) | param <- params], [], false, false), false)
    ]);

public PhpExpr createOverrideRule(constructor(list[Declaration] params, list[Statement] body)) 
    = createOverrideRule(params, body);
public PhpExpr createOverrideRule(constructor(list[Declaration] params, list[Statement] body, Expression when))
    = createOverrideRule(params, body, when);
public PhpExpr createOverrideRule(method(_, _, _, list[Declaration] params, list[Statement] body)) 
    = createOverrideRule(params, body);
public PhpExpr createOverrideRule(method(_, _, _, list[Declaration] params, list[Statement] body, Expression when))
    = createOverrideRule(params, body, when);
    
private PhpExpr createOverrideType(param(integer(), _)) = phpNew(phpName(phpName("Parameter\\Integer")), []);
private PhpExpr createOverrideType(param(float(), _)) = phpNew(phpName(phpName("Parameter\\Real")), []);
private PhpExpr createOverrideType(param(string(), _)) = phpNew(phpName(phpName("Parameter\\Str")), []);
private PhpExpr createOverrideType(param(boolean(), _)) = phpNew(phpName(phpName("Parameter\\Boolean")), []);
private PhpExpr createOverrideType(param(typedList(Type \type), _)) = phpNew(phpName(phpName("Parameter\\TypedList")), [
    phpActualParameter(createOverrideType(\type), false)
]);
private PhpExpr createOverrideType(param(typedMap(Type key, Type v), _)) = phpNew(phpName(phpName("Parameter\\Map")), [
    phpActualParameter(createOverrideType(key), false), phpActualParameter(createOverrideType(v), false)
]);
private PhpExpr createOverrideType(param(artifactType(str name), _)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpScalar(phpString(name)), false)
]);
private PhpExpr createOverrideType(param(repositoryType(str name), _)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpScalar(phpString(name + "Repository")), false)
]);
