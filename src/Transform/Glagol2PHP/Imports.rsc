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

private list[Declaration] extractImports(a: entity(_, list[Declaration] ds), env: <f, doctrine()>) =
    [\import("Mapping", namespace("Doctrine", namespace("ORM")), "ORM")] +
    commonImports(a, env);

private default list[Declaration] extractImports(Declaration artifact, env) = commonImports(artifact, env);

private list[Declaration] commonImports(Declaration artifact, env) =
    hasOverriding(artifact.declarations) ? 
        [\import("Overrider", namespace("Glagol", namespace("Overriding")), "Overrider")] : [];
    
private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as)) = 
	phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpSomeName(phpName(as)))
    when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as)) = 
	phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpNoName()) 
	when as == artifactName;
