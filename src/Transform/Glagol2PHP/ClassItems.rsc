module Transform::Glagol2PHP::ClassItems

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Doctrine::Relations;
import Map;

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, env, context) =
	[toPhpClassItem(ci, env, context) | ci <- declarations, isProperty(ci)] +
	[toPhpClassItem(r, env) | r <- getRelations(declarations)] + 
	(hasConstructors(declarations) ? [createConstructor(getConstructors(declarations), env)] : []) +
	[createMethod(m, env) | m <- range(categorizeMethods(declarations))];

