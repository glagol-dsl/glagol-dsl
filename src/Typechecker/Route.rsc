module Typechecker::Route

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import List;

public TypeEnv checkRoute(r:route(list[Route] routeParts), TypeEnv env) =
	env[errors = env.errors + 
		[<r@src, "Duplicated route in <ro@src.path> on line <ro@src.begin.line>"> | ro <- getAllRoutesLike(r, env), ro@src != r@src]
	]
	when size(getAllRoutesLike(r, env)) > 1;

public TypeEnv checkRoute(r:route(list[Route] routeParts), TypeEnv env) = env;

private list[Route] getAllRoutesLike(Route r, TypeEnv env) =
	[ro | file(_, \module(_, _, controller(_, _, Route ro, _))) <- env.ast, ro == r];
