module Compiler::PHP::Modifiers

import Compiler::PHP::Code;
import Syntax::Abstract::PHP;

public Code toCode(set[PhpModifier] modifiers) = (code() | it + toCode(m) + code(" ") | m <- modifiers);
	
public Code toCode(p: phpPublic()) = code("public", p);
public Code toCode(p: phpPrivate()) = code("private", p);
public Code toCode(p: phpProtected()) = code("protected", p);
public Code toCode(p: phpStatic()) = code("static", p);
public Code toCode(p: phpAbstract()) = code("abstract", p);
public Code toCode(p: phpFinal()) = code("final", p);
