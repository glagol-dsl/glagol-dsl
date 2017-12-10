module Test::Compiler::PHP::IncludeType

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;
import Compiler::PHP::IncludeType;

test bool shouldCompileToPhpInclude() = implode(toCode(phpInclude())) == "include";
test bool shouldCompileToPhpIncludeOnce() = implode(toCode(phpIncludeOnce())) == "include_once";
test bool shouldCompileToPhpRequire() = implode(toCode(phpRequire())) == "require";
test bool shouldCompileToPhpRequireOnce() = implode(toCode(phpRequireOnce())) == "require_once";
