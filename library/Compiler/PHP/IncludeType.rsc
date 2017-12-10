module Compiler::PHP::IncludeType

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;

public Code toCode(p: phpInclude()) = code("include", p);
public Code toCode(p: phpIncludeOnce()) = code("include_once", p);
public Code toCode(p: phpRequire()) = code("require", p);
public Code toCode(p: phpRequireOnce()) = code("require_once", p);
