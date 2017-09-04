module Test::Compiler::PHP::Consts

import Compiler::PHP::Consts;
import Syntax::Abstract::PHP;

test bool shoudCompileOneConstWithStringDefaultValue() = 
	toCode(phpConstCI([phpConst("TEST", phpScalar(phpString("test")))]), 0) ==
	"\nconst TEST = \"test\";\n";
