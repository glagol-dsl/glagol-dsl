module Transform::Glagol2PHP::ClassItems

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Actions;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Map;

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, TransformEnv env) =
	toPhpClassItems(declarations, [p | p <- declarations, isProperty(p)], env);

private list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, list[Declaration] properties, TransformEnv env) = 
	transformProperties(properties, env) +
	transformBehaviours(declarations, addDefinitions(properties, env));

private list[PhpClassItem] transformBehaviours(list[Declaration] declarations, TransformEnv env) = 
	transformConstructors(declarations, env) + 
	transformMethods(declarations, env) + 
	transformActions(declarations, env);

private list[PhpClassItem] transformActions(list[Declaration] declarations, TransformEnv env) = [toPhpClassItem(a, env) | a <- getActions(declarations)];

private list[PhpClassItem] transformMethods(list[Declaration] declarations, TransformEnv env) = [createMethod(m, env) | m <- range(categorizeMethods(declarations))];

private list[PhpClassItem] transformProperties(list[Declaration] properties, TransformEnv env) = [toPhpClassItem(p, env) | p <- properties];

private list[PhpClassItem] transformConstructors(list[Declaration] declarations, TransformEnv env) = 
	(hasDependencies(declarations) ? [createDIConstructor(getDIProperties(declarations), env)] : []) +
	(hasConstructors(declarations) ? [createConstructor(getConstructors(declarations), properties(declarations), env)] : []);
