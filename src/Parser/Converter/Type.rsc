module Parser::Converter::Type

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public Type convertType((Type) `int`) = integer();
public Type convertType((Type) `float`) = float();
public Type convertType((Type) `bool`) = boolean();
public Type convertType((Type) `boolean`) = boolean();
public Type convertType((Type) `void`) = voidValue();
public Type convertType((Type) `string`) = string();
public Type convertType((Type) `<Type \type>[]`) = typedArray(convertType(\type));
public Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");
