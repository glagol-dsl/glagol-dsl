module Compiler::PHP::Uses

import Compiler::PHP::Code;
import Utils::NewLine;
import Syntax::Abstract::PHP;

public Code toCode(phpUse(set[PhpUse] uses), _) = (code() | it + toCode(use) | use <- uses);

public Code toCode(p: phpUse(phpName(str name), phpSomeName(phpName(str as)))) = code(nl()) + code("use <name> as <as>;", p);
	
public Code toCode(p: phpUse(phpName(str name), phpNoName())) = code(nl()) + code("use <name>;", p);
