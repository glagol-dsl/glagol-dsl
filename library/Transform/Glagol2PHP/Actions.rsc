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
import String;

public PhpClassItem toPhpClassItem(a: action(str name, list[Declaration] params, list[Statement] body), TransformEnv env)
    = phpMethod(
        name, 
        {phpPublic()}, 
        false, 
        toActionParams(params, name), 
        createInitializers(params, name, env) +
        [toPhpStmt(stmt, addDefinitions(params, env)) | stmt <- body], 
        phpNoName()
    )[
    	@phpAnnotations=toPhpAnnotations(a, env)
    ] when usesLumen(env);

@todo="Tests missing for this one"
private list[PhpParam] toActionParams(list[Declaration] params, _) {
    list[PhpParam] phpParams;
    
    phpParams = for (p <- params) {
        if (hasAnnotation(p, "autofind")) {
            append toPhpParam(param(integer(), "_<p.name>Id", emptyExpr()));
        } else if (!hasAnnotation(p, "autofill")) {
            append toPhpParam(p);
        }
    }
    
    return phpParams;
}

private list[PhpStmt] createInitializers(list[Declaration] params, str _, TransformEnv env) {

    list[PhpStmt] stmts = [];

    bool hasAutofind = false;

    for (p <- params, hasAnnotation(p, "autofind"), isEntity(p.paramType, env)) {
        hasAutofind = true;
        stmts += phpExprstmt(
            phpAssign(phpVar(p.name), phpMethodCall(phpCall(phpName(phpName("app")), [
            	phpActualParameter(phpFetchClassConst(phpName(phpName(
            		toString(findRepository(p.paramType, env), env)
            	)), "class"), false)
            ]), phpName(phpName("find")), [
                phpActualParameter(phpVar("_<p.name>Id"), false)
            ]))
        );
    }
    
    for (p <- params, hasAnnotation(p, "autofill")) {
        if (hasAutofind) 
            stmts += phpExprstmt(
                phpMethodCall(phpVar(p.name), phpName(phpName("_hydrate")), [
                    phpActualParameter(phpMethodCall(phpPropertyFetch(
                        phpCall(phpName(phpName("app")), [phpActualParameter(phpFetchClassConst(phpName(phpName("\\Illuminate\\Http\\Request")), "class"), false)]), 
                        phpName(phpName("request"))
                    ), phpName(phpName("all")), []), false)
                ])
            );
        else if (artifact(Name n) := p.paramType)
            stmts += [
                phpExprstmt(phpAssign(phpVar("reflection"), phpNew(phpName(phpName("\\ReflectionClass")), [
                    phpActualParameter(phpFetchClassConst(phpName(phpName(n.localName)), "class"), false)
                ]))),
                phpExprstmt(phpAssign(phpVar(p.name), phpMethodCall(phpVar("reflection"), phpName(phpName(
                    "newInstanceWithoutConstructor"
                )), []))),
                phpExprstmt(
                    phpMethodCall(phpVar(p.name), phpName(phpName("_hydrate")), [
                        phpActualParameter(phpMethodCall(phpPropertyFetch(
                            phpCall(phpName(phpName("app")), [phpActualParameter(phpFetchClassConst(phpName(phpName("\\Illuminate\\Http\\Request")), "class"), false)]), 
                        	phpName(phpName("request"))
                        ), phpName(phpName("all")), []), false)
                    ])
                )
            ];
    }
    
    return stmts;
}

private str toString(repository(str originalName, list[Declaration] ds), TransformEnv env) = "\\" + namespaceToString(getNamespace(env), "\\") + "\\<originalName>Repository";
