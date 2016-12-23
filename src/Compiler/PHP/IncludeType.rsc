module Compiler::PHP::IncludeType

import Syntax::Abstract::PHP;

public str toCode(phpInclude()) = "include";
public str toCode(phpIncludeOnce()) = "include_once";
public str toCode(phpRequire()) = "require";
public str toCode(phpRequireOnce()) = "require_once";
