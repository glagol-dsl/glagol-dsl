module Compiler::PHP::Code

import Syntax::Abstract::PHP;
import List;

alias Code = list[tuple[str line, loc origin, bool useEnd, str name]];

public Code code() = [];

public bool isDefaultLoc(loc l) = l == defaultLoc();
private loc defaultLoc() = |tmp:///unknown|(0, 0, <0, 0>, <0, 0>);

// code start
public Code code(str line, PhpExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpOptionExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpSomeName(phpName(str name))) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, name>];
public Code code(str line, origin: phpNoName()) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpOptionElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpActualParameter origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpConst(str name, PhpExpr constValue)) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, name>];
public Code code(str line, PhpArrayElement origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpName(str name)) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, name>];
public Code code(str line, origin: phpName(phpName(str name))) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, name>];
public Code code(str line, origin: phpExpr(PhpExpr expr)) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCastType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpClosureUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpIncludeType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpOp origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpParam(str paramName, PhpOptionExpr paramDefault, PhpOptionName paramType, bool byRef, bool isVariadic)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), false, paramName>];
public Code code(str line, PhpScalar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpStmt origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpDeclaration origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCatch origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCase origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpElseIf origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpMethod(str name, set[PhpModifier] modifiers, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName returnType)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), false, name>]; 
public Code code(str line, PhpClassItem origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpAdaptation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpProperty(str propertyName, PhpOptionExpr defaultValue)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), false, propertyName>];
public Code code(str line, PhpModifier origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, origin: phpClass(str className, set[PhpModifier] modifiers, PhpOptionName extends, list[PhpName] implements, list[PhpClassItem] members)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), false, className>]; 
public Code code(str line, origin: phpInterface(str interfaceName, list[PhpName] extends, list[PhpClassItem] members)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), false, interfaceName>];
public Code code(str line, origin: phpTrait(str traitName, list[PhpClassItem] members)) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, traitName>];
public Code code(str line, origin: phpStaticVar(str name, PhpOptionExpr defaultValue)) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, name>];
public Code code(str line, PhpScript origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpAnnotation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public default Code code(str line, node origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line) = [<line, defaultLoc(), false, "">];

// code end
public Code codeEnd(str line, PhpExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOptionExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpSomeName(phpName(str name))) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, name>];
public Code codeEnd(str line, origin: phpNoName()) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOptionElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpActualParameter origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpConst(str name, PhpExpr constValue)) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, name>];
public Code codeEnd(str line, PhpArrayElement origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpName(str name)) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, name>];
public Code codeEnd(str line, origin: phpName(phpName(str name))) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, name>];
public Code codeEnd(str line, origin: phpExpr(PhpExpr expr)) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCastType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpClosureUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpIncludeType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOp origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpParam(str paramName, PhpOptionExpr paramDefault, PhpOptionName paramType, bool byRef, bool isVariadic)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), true, paramName>];
public Code codeEnd(str line, PhpScalar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpStmt origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpDeclaration origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCatch origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCase origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpElseIf origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpMethod(str name, set[PhpModifier] modifiers, bool byRef, list[PhpParam] params, list[PhpStmt] body, PhpOptionName returnType)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), true, name>]; 
public Code codeEnd(str line, PhpClassItem origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpAdaptation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpProperty(str propertyName, PhpOptionExpr defaultValue)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), true, propertyName>];
public Code codeEnd(str line, PhpModifier origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, origin: phpClass(str className, set[PhpModifier] modifiers, PhpOptionName extends, list[PhpName] implements, list[PhpClassItem] members)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), true, className>]; 
public Code codeEnd(str line, origin: phpInterface(str interfaceName, list[PhpName] extends, list[PhpClassItem] members)) = 
	[<line, origin@origin? ? origin@origin : defaultLoc(), true, interfaceName>];
public Code codeEnd(str line, origin: phpTrait(str traitName, list[PhpClassItem] members)) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, traitName>];
public Code codeEnd(str line, origin: phpStaticVar(str name, PhpOptionExpr defaultValue)) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, name>];
public Code codeEnd(str line, PhpScript origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpAnnotation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public default Code codeEnd(str line, node origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line) = [<line, defaultLoc(), true, "">];

public Code glue(list[lrel[str, loc, bool, str]] pieces, Code s) = code("") when size(pieces) == 0;
public Code glue(list[lrel[str, loc, bool, str]] pieces, Code s) = pieces[0] when size(pieces) == 1;
public Code glue(list[lrel[str, loc, bool, str]] pieces) = glue(pieces, code(""));
public default Code glue(list[lrel[str, loc, bool, str]] pieces, Code d) = (pieces[0] | it + d + p | p <- slice(pieces, 1, size(pieces) - 1));

public str implode(Code pieces) = ("" | it + l | <str l, loc d, bool _, str _> <- pieces);
