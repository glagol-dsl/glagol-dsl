module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Namespaces;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol::Helpers;
import Config::Reader;
import List;

public map[str, PhpScript] toPHPScript(env: <Framework f, orm: doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpNamespace(namespace, imports, artifact, env)]));
