module Transform::Glagol2PHP::Types

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpName toPhpTypeName(integer()) = phpName("int");
public PhpName toPhpTypeName(float()) = phpName("float");
public PhpName toPhpTypeName(boolean()) = phpName("bool");
public PhpName toPhpTypeName(string()) = phpName("string");
public PhpName toPhpTypeName(typedList(_)) = phpName("array");
public PhpName toPhpTypeName(typedMap(_, _)) = phpName("array");
public PhpName toPhpTypeName(artifactType(str name)) = phpName(name);
public PhpName toPhpTypeName(repositoryType(str name)) = phpName(name + "Repository");
