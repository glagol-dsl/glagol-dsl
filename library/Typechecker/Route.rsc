module Typechecker::Route

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import List;

public TypeEnv checkRoute(r:route(list[Route] routeParts), TypeEnv env) = 
	checkRouteParts(r, checkRouteDuplication(r, getAllRoutesLike(r, env), env));

public TypeEnv checkRouteDuplication(r, list[Route] routeParts, TypeEnv env) = 
	addError(r, "Route <toString(r)> is duplicated", env)
	when size(routeParts) > 1;

public TypeEnv checkRouteDuplication(r, list[Route] routeParts, TypeEnv env) = env;

public TypeEnv checkRouteParts(r:route(list[Route] routeParts), TypeEnv env) = 
	addError(r, "Route <toString(r)> has duplicated var placeholders", env)
	when hasDuplicatingPlaceholders(distribution([v | v: routeVar(str name) <- routeParts]));

public TypeEnv checkRouteParts(r:route(list[Route] routeParts), TypeEnv env) = env;

private list[Route] getAllRoutesLike(Route r, TypeEnv env) =
	[ro | file(_, \module(_, _, controller(_, _, Route ro, _))) <- env.ast, ro == r];

private bool hasDuplicatingPlaceholders(map[Route, int] varDist) = (false | true | r <- varDist, varDist[r] > 1);

private str toString(route(list[Route] routeParts)) = ("" | it + "/" + toString(r) | r <- routeParts);
private str toString(routePart(str name)) = name;
private str toString(routeVar(str name)) = ":<name>";
