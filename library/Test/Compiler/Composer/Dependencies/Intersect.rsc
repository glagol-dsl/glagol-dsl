module Test::Compiler::Composer::Dependencies::Intersect

import Compiler::Composer::Dependencies::Intersect;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldGetDependenciesForLumenAndDoctrine() =
    getIntersectDependencies(lumen(), doctrine()) == ();

test bool shouldGetDependenciesForAnyOtherIntersect() = 
    getIntersectDependencies(anyFramework(), anyORM()) == ();
