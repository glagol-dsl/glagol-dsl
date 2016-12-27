module Parser::Converter::Type

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public Type convertType((Type) `int`) = integer();
public Type convertType((Type) `float`) = float();
public Type convertType((Type) `bool`) = boolean();
public Type convertType((Type) `boolean`) = boolean();
public Type convertType((Type) `void`) = voidValue();
public Type convertType((Type) `string`) = string();
public Type convertType((Type) `repository\<<ArtifactName name>\>`) = repository("<name>");
public Type convertType((Type) `<Type t>[]`) = \list(convertType(t));
public Type convertType((Type) `{<Type key>,<Type v>}`) = \map(convertType(key), convertType(v));
public Type convertType((Type) `<ArtifactName name>`) = artifact("<name>");
