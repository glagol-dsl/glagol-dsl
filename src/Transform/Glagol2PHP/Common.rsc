module Transform::Glagol2PHP::Common

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private str EXT = "php";
// TODO Check behaviour under windows
private str DS = "/";

public str namespaceToString(namespace(str name), _) = name;
public str namespaceToString(namespace(str name, Declaration subNamespace), str delimiter) 
    = name + delimiter + namespaceToString(subNamespace, delimiter);

public str makeFilename(Declaration namespace, entity(str name, _)) = namespaceToDir(namespace) + name + ".<EXT>";
public str makeFilename(Declaration namespace, annotated(_, Declaration entity)) = makeFilename(namespace, entity);

private str namespaceToDir(namespace(str name)) = name + DS;
private str namespaceToDir(namespace(str name, Declaration sub)) = name + DS + namespaceToDir(sub);

@doc="Converts Glagol import into PHP use (with alias)"
public PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpSomeName(phpName(as))) when as != artifactName;

@doc="Converts Glagol import into PHP use (WITHOUT alias)"
public PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpNoName()) when as == artifactName;
