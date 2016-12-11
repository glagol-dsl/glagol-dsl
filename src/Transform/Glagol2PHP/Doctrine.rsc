module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::ClassItems;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Imports;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol::Helpers;
import Config::Reader;
import List;

public map[str, PhpScript] toPHPScript(env: <Framework f, orm: doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpNamespace(namespace, imports, artifact, env)]));

private PhpStmt toPhpNamespace(Declaration namespace, list[Declaration] imports, Declaration artifact, env)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        toPhpUses(imports, artifact, env) + [toPhpClassDef(artifact, env)]
    );
