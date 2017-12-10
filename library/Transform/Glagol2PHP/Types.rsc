module Transform::Glagol2PHP::Types

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::OriginAnnotator;

public PhpName toPhpTypeName(e: integer()) = origin(phpName("int"), e);
public PhpName toPhpTypeName(e: float()) = origin(phpName("float"), e);
public PhpName toPhpTypeName(e: boolean()) = origin(phpName("bool"), e);
public PhpName toPhpTypeName(e: string()) = origin(phpName("string"), e);
public PhpName toPhpTypeName(e: \list(_)) = origin(phpName("Vector"), e);
public PhpName toPhpTypeName(e: \map(_, _)) = origin(phpName("Map"), e);
public PhpName toPhpTypeName(e: artifact(Name name)) = origin(phpName(extractName(name)), e);
public PhpName toPhpTypeName(e: repository(Name name)) = origin(phpName(extractName(name) + "Repository"), e);
