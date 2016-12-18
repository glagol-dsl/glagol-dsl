module Transform::Glagol2PHP::Namespaces

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Imports;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::ClassItems;
import Config::Reader;

public PhpStmt toPhpNamespace(Declaration namespace, list[Declaration] imports, Declaration artifact, env)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        toPhpUses(imports, artifact, env) + [toPhpClassDef(artifact, env)]
    );

public map[str, PhpScript] toPHPScript(env: <Framework f, orm: doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpNamespace(namespace, imports, artifact, env)]));
