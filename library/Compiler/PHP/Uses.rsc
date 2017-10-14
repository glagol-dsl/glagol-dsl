module Compiler::PHP::Uses

import Compiler::PHP::Code;
import Utils::NewLine;
import Syntax::Abstract::PHP;

public Code toCode(phpUse(set[PhpUse] uses), _) = (code() | it + toCode(use) | use <- uses);

public Code toCode(p: phpUse(nm: phpName(str name), phpSomeName(als: phpName(str as)))) = 
	code(nl()) + code("use", p) + code(" ") + code(name, nm) + code(" ") + code("as", als) + code(" ") + code(as, als) + codeEnd(";", p);
	
public Code toCode(p: phpUse(nm: phpName(str name), phpNoName())) = code(nl()) + code("use", p) + code(" ") + code(name, nm) + codeEnd(";", p);
