module Parser::Converter::Type

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;

public Type convertType(a: (Type) `int`, ParseEnv env) = integer()[@src=a@\loc];
public Type convertType(a: (Type) `float`, ParseEnv env) = float()[@src=a@\loc];
public Type convertType(a: (Type) `bool`, ParseEnv env) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `boolean`, ParseEnv env) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `void`, ParseEnv env) = voidValue()[@src=a@\loc];
public Type convertType(a: (Type) `string`, ParseEnv env) = string()[@src=a@\loc];
public Type convertType(a: (Type) `repository\<<ArtifactName name>\>`, ParseEnv env) = repository(createName("<name>", env)[@src=name@\loc])[@src=a@\loc];
public Type convertType(a: (Type) `<Type t>[]`, ParseEnv env) = \list(convertType(t, env))[@src=a@\loc];
public Type convertType(a: (Type) `{<Type key>,<Type v>}`, ParseEnv env) = \map(convertType(key, env), convertType(v, env))[@src=a@\loc];
public Type convertType(a: (Type) `<ArtifactName name>`, ParseEnv env) = artifact(createName("<name>", env)[@src=name@\loc])[@src=a@\loc];
