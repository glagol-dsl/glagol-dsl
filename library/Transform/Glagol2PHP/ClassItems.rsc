module Transform::Glagol2PHP::ClassItems

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
import Transform::Glagol2PHP::Annotations;
import Map;

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, env, context) =
	[toPhpClassItem(ci, env, context) | ci <- declarations, isProperty(ci)] +
	(hasDependencies(declarations) ? [createDIConstructor(getDIProperties(declarations), env)] : []) +
	(hasConstructors(declarations) ? [createConstructor(getConstructors(declarations), env)] : []) +
	[createMethod(m, env) | m <- range(categorizeMethods(declarations))] +
	[toPhpClassItem(a, env) | a <- getActions(declarations)]
	;
