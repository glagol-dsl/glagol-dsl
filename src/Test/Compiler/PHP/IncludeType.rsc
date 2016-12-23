module Test::Compiler::PHP::IncludeType

import Syntax::Abstract::PHP;
import Compiler::PHP::IncludeType;

test bool shouldCompileToPhpInclude() = toCode(phpInclude()) == "include";
test bool shouldCompileToPhpIncludeOnce() = toCode(phpIncludeOnce()) == "include_once";
test bool shouldCompileToPhpRequire() = toCode(phpRequire()) == "require";
test bool shouldCompileToPhpRequireOnce() = toCode(phpRequireOnce()) == "require_once";
