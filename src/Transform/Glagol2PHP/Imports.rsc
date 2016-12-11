module Transform::Glagol2PHP::Imports

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol::Helpers;
import Config::Reader;

public list[PhpStmt] toPhpUses(list[Declaration] imports, Declaration artifact, env) =
    [phpUse(
        {toPhpUse(i) | i <- imports + extractImports(artifact, env)}
    )];
    
private list[Declaration] extractImports(annotated(_, Declaration artifact), env) = extractImports(artifact, env);

private list[Declaration] extractImports(Declaration artifact: entity(_, list[Declaration] ds), <Framework f, doctrine()>) {
    list[Declaration] imports = [
        \import("Mapping", namespace("Doctrine", namespace("ORM")), "ORM")
    ];

    if (hasOverriding(ds)) {
        imports += \import("Overrider", namespace("Glagol", namespace("Overriding")), "Overrider");
    }

    return imports;
}

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpSomeName(phpName(as))) when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpNoName()) when as == artifactName;
