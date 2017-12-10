module Compiler::PHP::CastType

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;

public Code toCode(s: phpInt()) = code("int", s);
public Code toCode(s: phpBool()) = code("bool", s);
public Code toCode(s: phpFloat()) = code("float", s);
public Code toCode(s: phpString()) = code("string", s);
public Code toCode(s: phpArray()) = code("array", s);
public Code toCode(s: phpObject()) = code("object", s);
public Code toCode(s: phpUnset()) = code("unset", s);
