module Compiler::Lumen::Routes::Api

import Compiler::PHP::Compiler;
import Compiler::PHP::Code;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Transform::Glagol2PHP::Common;
import Utils::Glue;

public str createRoutesApi(list[Declaration] ast) =
    implode(toCode(phpScript([phpExprstmt(toResourceRoute(ns, c, name)) | \module(ns, _, c) <- getControllerModules(ast), action(name, _, _) <- c.declarations])));
    
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "index") =
    phpMethodCall(phpVar("app"), phpName(phpName("get")), [
		phpActualParameter(phpScalar(phpString(toString(route))), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@index")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "show") =
    phpMethodCall(phpVar("app"), phpName(phpName("get")), [
		phpActualParameter(phpScalar(phpString(toString(route) + "/{_id}")), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@show")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "create") =
    phpMethodCall(phpVar("app"), phpName(phpName("get")), [
		phpActualParameter(phpScalar(phpString(toString(route) + "/create")), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@create")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "store") =
    phpMethodCall(phpVar("app"), phpName(phpName("post")), [
		phpActualParameter(phpScalar(phpString(toString(route))), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@store")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "edit") =
    phpMethodCall(phpVar("app"), phpName(phpName("get")), [
		phpActualParameter(phpScalar(phpString(toString(route) + "/{_id}/edit")), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@edit")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "update") =
    phpMethodCall(phpVar("app"), phpName(phpName("put")), [
		phpActualParameter(phpScalar(phpString(toString(route) + "/{_id}")), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@update")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), "delete") =
    phpMethodCall(phpVar("app"), phpName(phpName("delete")), [
		phpActualParameter(phpScalar(phpString(toString(route) + "/{_id}")), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@delete")), false)
	]);
	
private PhpExpr toResourceRoute(Declaration ns, controller(str name, ControllerType controllerType, Route route, _), str act) =
    phpMethodCall(phpVar("app"), phpName(phpName("get")), [
		phpActualParameter(phpScalar(phpString(toString(route))), false),
		phpActualParameter(phpScalar(phpString(toControllerFullName(ns, name) + "@" + act)), false)
	]);
    
private str toString(route(list[Route] routeParts)) = "/" + glue([toString(p) | p <- routeParts], "/");
private str toString(routePart(str name)) = name;
private str toString(routeVar(str name)) = "{<name>}";

private str toControllerFullName(Declaration ns, str name) = namespaceToString(ns, "\\") + "\\<name>";
