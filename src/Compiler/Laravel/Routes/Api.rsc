module Compiler::Laravel::Routes::Api

import Compiler::PHP::Compiler;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Common;
import Utils::Glue;

public str createRoutesApi(list[Declaration] ast) =
    toCode(phpScript([phpExprstmt(toResourceRoute(ns, c)) | \module(ns, _, c) <- getControllerModules(ast)]));

private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, list[Declaration] declarations)) =
    phpStaticCall(phpName(phpName("Route")), phpName(phpName("resource")), [
        phpActualParameter(phpScalar(phpString(toString(route))), false),
        phpActualParameter(phpFetchClassConst(phpName(phpName(toControllerFullName(ns, name))), "class"), false)
    ]);
    
private str toString(route(list[Route] routeParts)) = "/" + glue([toString(p) | p <- routeParts], "/");
private str toString(routePart(str name)) = name;
private str toString(routeVar(str name)) = "{<name>}";

private str toControllerFullName(Declaration ns, str name) = namespaceToString(ns, "\\") + "\\<name>";
