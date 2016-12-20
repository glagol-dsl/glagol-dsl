module Compiler::PHP::CastType

import Syntax::Abstract::PHP;

public str toCode(phpInt()) = "int";
public str toCode(phpBool()) = "bool";
public str toCode(phpFloat()) = "float";
public str toCode(phpString()) = "string";
public str toCode(phpArray()) = "array";
public str toCode(phpObject()) = "object";
public str toCode(phpUnset()) = "unset";
