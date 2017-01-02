module Parser::Converter::Type

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public Type convertType(a: (Type) `int`) = integer()[@src=a@\loc];
public Type convertType(a: (Type) `float`) = float()[@src=a@\loc];
public Type convertType(a: (Type) `bool`) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `boolean`) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `void`) = voidValue()[@src=a@\loc];
public Type convertType(a: (Type) `string`) = string()[@src=a@\loc];
public Type convertType(a: (Type) `repository\<<ArtifactName name>\>`) = repository("<name>")[@src=a@\loc];
public Type convertType(a: (Type) `<Type t>[]`) = \list(convertType(t))[@src=a@\loc];
public Type convertType(a: (Type) `{<Type key>,<Type v>}`) = \map(convertType(key), convertType(v))[@src=a@\loc];
public Type convertType(a: (Type) `<ArtifactName name>`) = artifact("<name>")[@src=a@\loc];
