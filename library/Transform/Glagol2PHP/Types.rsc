module Transform::Glagol2PHP::Types

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;

public PhpName toPhpTypeName(integer()) = phpName("int");
public PhpName toPhpTypeName(float()) = phpName("float");
public PhpName toPhpTypeName(boolean()) = phpName("bool");
public PhpName toPhpTypeName(string()) = phpName("string");
public PhpName toPhpTypeName(\list(_)) = phpName("Vector");
public PhpName toPhpTypeName(\map(_, _)) = phpName("Map");
public PhpName toPhpTypeName(artifact(Name name)) = phpName(extractName(name));
public PhpName toPhpTypeName(repository(Name name)) = phpName(extractName(name) + "Repository");
