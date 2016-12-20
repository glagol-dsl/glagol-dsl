module Compiler::PHP::Modifiers

import Syntax::Abstract::PHP;

public str toCode(set[PhpModifier] modifiers) = ("" | it + toCode(m) + " " | m <- modifiers);
	
public str toCode(phpPublic()) = "public";
public str toCode(phpPrivate()) = "private";
public str toCode(phpProtected()) = "protected";
public str toCode(phpStatic()) = "static";
public str toCode(phpAbstract()) = "abstract";
public str toCode(phpFinal()) = "final";
