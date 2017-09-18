module Transform::Glagol2PHP::Namespaces

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import Transform::Glagol2PHP::Imports;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Repositories;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::ValueObjects;
import Transform::Glagol2PHP::Controllers;
import Transform::Glagol2PHP::ClassItems;
import Config::Config;
import Transform::Env;

public PhpStmt toPhpNamespace(m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact), list[Declaration] ast, TransformEnv env)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        toPhpUses(m, ast, env) + [toPhpClassDef(artifact, env)]
    );

public map[str, PhpScript] toPHPScript(
	TransformEnv env, 
	m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact),
	list[Declaration] ast) = 
	(makeFilename(namespace, artifact): phpScript([phpDeclareStrict(), toPhpNamespace(m, ast, env)]));
