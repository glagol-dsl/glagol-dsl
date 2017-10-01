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
import Transform::OriginAnnotator;

public PhpStmt toPhpNamespace(m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact), list[Declaration] ast, TransformEnv env)
    = origin(phpNamespace(
        origin(phpSomeName(phpName(namespaceToString(namespace, "\\"))), namespace, true),
        toPhpUses(m, ast, env) + [toPhpClassDef(artifact, setContext(m, env))]
    ), namespace);

public map[str, PhpScript] toPHPScript(
	TransformEnv env, 
	m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact),
	list[Declaration] ast) = 
	(makeFilename(namespace, artifact): origin(phpScript([origin(phpDeclareStrict(), m), toPhpNamespace(m, ast, env)]), m));
