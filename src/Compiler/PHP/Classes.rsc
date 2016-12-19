module Compiler::PHP::Classes

import Syntax::Abstract::PHP;
import Compiler::PHP::NewLine;
import Compiler::PHP::Modifiers;
import Compiler::PHP::Properties;
import Compiler::PHP::Methods;
import Compiler::PHP::Annotations;
import Compiler::PHP::Glue;
import List;

public str toCode(phpClassDef(class: phpClass(
		str className, 
		set[PhpModifier] modifiers, 
		PhpOptionName extending, 
		list[PhpName] interfaces,
		list[PhpClassItem] members)), int i) = nl(2) +
	((class@phpAnnotations?) ? (toCode(class@phpAnnotations, i) + nl()) : "") +
	"<toCode(modifiers)>class <className> <extends(extending)><implements(interfaces)><nl()>{" + 
		("" | it + toCode(m, i + 1) | m <- members) +
	"}";

private str extends(phpNoName()) = "";
private str extends(phpSomeName(phpName(str name))) = "extends <name> ";

private str implements(list[PhpName] interfaces) = "" when size(interfaces) == 0;
private str implements(list[PhpName] interfaces) = "implements <interfaces[0].name> " when size(interfaces) == 1;
private default str implements(list[PhpName] interfaces) = 
	"implements <(glue([name | phpName(str name) <- interfaces], ", "))> ";
	
