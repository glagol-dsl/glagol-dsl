module Compiler::PHP::Compiler

import Syntax::Abstract::PHP;
import Compiler::PHP::Indentation;
import Compiler::PHP::NewLine;
import Compiler::PHP::Glue;
import Compiler::PHP::Annotations;
import List;
import Set;

public str toCode(phpScript(list[PhpStmt] body)) = 
	"\<?php" + nl() + ("" | it + toCode(stmt, 0) | stmt <- body) + nl();

public str toCode(phpNamespace(phpSomeName(phpName(str name)), list[PhpStmt] body), int i) =
	"namespace <name>;" + nl() +
	("" | it + toCode(stmt, i) | stmt <- body)
	;

public str toCode(phpUse(set[PhpUse] uses), _) = ("" | it + toCode(use) | use <- uses);

public str toCode(phpUse(phpName(str name), phpSomeName(phpName(str as)))) = "<nl()>use <name> as <as>;";
	
public str toCode(phpUse(phpName(str name), phpNoName())) =  "<nl()>use <name>;";

public str toCode(phpClassDef(class: phpClass(
		str className, 
		set[PhpModifier] modifiers, 
		PhpOptionName extending, 
		list[PhpName] interfaces,
		list[PhpClassItem] members)), int i) = nl(2) +
	toCode(class@phpAnnotations, i) + nl() +
	"<toCode(modifiers)>class <className> <extends(extending)><implements(interfaces)>{<nl()>" + 
		("" | it + toCode(m, i + 1) | m <- members) +
	"<nl()>}";

public str toCode(set[PhpModifier] modifiers) =
	("" | it + toCode(m) + " " | m <- modifiers);

public str toCode(p: phpProperty(set[PhpModifier] modifiers, list[PhpProperty] prop), int i) = 
	"<nl()>" +
	"<toCode(p@phpAnnotations, i)><nl()>" +
	"<s(i)><toCode(modifiers)><toCode(prop[0])>;<nl(2)>"
	when size(prop) == 1;

public str toCode(phpProperty(str propertyName, phpNoExpr())) = "$<propertyName>";

public str toCode(phpPublic()) = "public";
public str toCode(phpPrivate()) = "private";
public str toCode(phpProtected()) = "protected";
public str toCode(phpStatic()) = "static";
public str toCode(phpAbstract()) = "abstract";
public str toCode(phpFinal()) = "final";

private str extends(phpNoName()) = "";
private str extends(phpSomeName(phpName(str name))) = "extends <name> ";

private str implements(list[PhpName] interfaces) = "" when size(interfaces) == 0;
private str implements(list[PhpName] interfaces) = "implements <implts[0].name> " when size(interfaces) == 1;
private default str implements(list[PhpName] interfaces) = 
	"implements <(glue([name | phpName(str name) <- interfaces]))> ";
