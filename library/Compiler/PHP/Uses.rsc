module Compiler::PHP::Uses

import Compiler::PHP::Code;
import Utils::NewLine;
import Syntax::Abstract::PHP;

public Code toCode(phpUse(set[PhpUse] uses), _) = (code() | it + toCode(use) | use <- uses);

public Code toCode(p: phpUse(nm: phpName(str name), phpSomeName(als: phpName(str as)))) = 
	code(nl()) + code("use", p) + code(" ") + code(name, nm) + code(" ") + code("as", als) + code(" ") + code(as, als) + codeEnd(";", p)
	when !aliasMatchesClass(as, name);
	
public Code toCode(p: phpUse(nm: phpName(str name), phpSomeName(als: phpName(str as)))) = toCode(p[asName = phpNoName()]);

public Code toCode(p: phpUse(nm: phpName(str name), phpNoName())) = code(nl()) + code("use", p) + code(" ") + code(name, nm) + codeEnd(";", p);

private bool aliasMatchesClass(str as, str class) = /\\<as>$/i := class;
