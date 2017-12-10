module Test::Compiler::PHP::Uses

import Compiler::PHP::Code;
import Compiler::PHP::Uses;
import Syntax::Abstract::PHP;

test bool shouldCompileToUseWithoutAlias() = 
	implode(toCode(phpUse(phpName("My\\Lib\\Util"), phpNoName()))) == "\nuse My\\Lib\\Util;";

test bool shouldCompileToUseWithAlias() = 
	implode(toCode(phpUse(phpName("My\\Lib\\Util"), phpSomeName(phpName("MyUtil"))))) == "\nuse My\\Lib\\Util as MyUtil;";

test bool shouldCompileToUses() = 
	implode(toCode(phpUse({phpUse(phpName("My\\Lib\\Util"), phpNoName()), phpUse(phpName("My\\Lib\\Other"), phpNoName())}), 0)) ==
	"\nuse My\\Lib\\Util;\nuse My\\Lib\\Other;";
