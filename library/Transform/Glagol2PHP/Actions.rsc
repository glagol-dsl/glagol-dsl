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
        createInitializers(params, name) +
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
            append toPhpParam(param(integer(), "id", emptyExpr()));
        } else if (!hasAnnotation(p, "autofill")) {
            append toPhpParam(p);
        }
    }
    
    return phpParams;
}
 
private list[PhpParam] toActionParams(list[Declaration] params, _) = [toPhpParam(p) | p <- params]; 

private list[PhpStmt] createInitializers(list[Declaration] params, _) {

    list[PhpStmt] stmts = [];

    bool hasAutofind = false;

    for (p <- params, hasAnnotation(p, "autofind")) {
        hasAutofind = true;
        stmts += phpExprstmt(
            phpAssign(phpVar(p.name), phpMethodCall(phpPropertyFetch(phpVar("this"), phpName(phpName(
                toLowerCase(p.name) + "s"
            ))), phpName(phpName("find")), [
                phpActualParameter(phpVar("id"), false)
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
