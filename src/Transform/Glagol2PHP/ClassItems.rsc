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

public PhpStmt toPhpClassDef(annotated(list[Annotation] annotations, Declaration artifact), env) 
    = applyAnnotationsOnStmt(toPhpClassDef(artifact, env), annotations, env);

public PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration), env)
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration, env), annotations, env);

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, env) =
	[toPhpClassItem(ci, env) | ci <- declarations, isProperty(ci) || isAnnotated(ci, isProperty)] +
	(hasConstructors(declarations) ? [createConstructor(getConstructors(declarations), env)] : []) +
	[toPhpClassItem(r, env) | r <- getRelations(declarations)] + 
	[createMethod(m, env) | m <- range(categorizeMethods(declarations))];

