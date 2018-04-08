module Transform::Glagol2PHP::Actions

import Transform::Glagol2PHP::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Config::Config;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Params;
import Transform::Env;
import Transform::OriginAnnotator;
import String;

public PhpClassItem toPhpClassItem(a: action(str name, list[Declaration] params, list[Statement] body), TransformEnv env)
    = origin(phpMethod(
        name, 
        {origin(phpPublic(), a)}, 
        false, 
        toActionParams(params, name), 
        createInitializers(params, name, env) +
        [origin(toPhpStmt(stmt, addDefinitions(params, env)), stmt) | stmt <- body], 
        phpNoName()
    )[@phpAnnotations=toPhpAnnotations(a, env)], a) when usesLumen(env);

@todo="Tests missing for this one"
private list[PhpParam] toActionParams(list[Declaration] params, _) {
    list[PhpParam] phpParams;
    
    phpParams = for (p <- params) {
        if (hasAnnotation(p, "autofind")) {
            append origin(toPhpParam(param(integer(), "_<p.name>Id", emptyExpr())), p, true);
        } else {
            append origin(toPhpParam(p), p);
        }
    }
    
    return phpParams;
}

private list[PhpStmt] createInitializers(list[Declaration] params, str _, TransformEnv env) {

    list[PhpStmt] stmts = [];

    bool hasAutofind = false;

    for (p <- params, hasAnnotation(p, "autofind"), isEntity(p.paramType, env)) {
        hasAutofind = true;
        stmts += origin(phpExprstmt(
            phpAssign(phpVar(p.name), phpMethodCall(phpMethodCall(phpCall(phpName(phpName("app")), [
	            	phpActualParameter(phpScalar(phpString("em")), false)
	            ]), phpName(phpName("getRepository")), [
	                phpActualParameter(phpFetchClassConst(phpName(phpName(p.paramType.name.localName)), "class"), false)
	            ]), 
            phpName(phpName("find")), [
            	phpActualParameter(phpVar("_<p.name>Id"), false)
            ]))
        ), p, true);
    }
    
    return stmts;
}

private str toString(repository(str originalName, list[Declaration] ds), TransformEnv env) = "\\" + namespaceToString(getNamespace(env), "\\") + "\\<originalName>Repository";
