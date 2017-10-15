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
public Code code(str line, PhpOptionName origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpOptionElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpActualParameter origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpConst origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpArrayElement origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpName origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpNameOrExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCastType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpClosureUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpIncludeType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpOp origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpParam origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpScalar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpStmt origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpDeclaration origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCatch origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpCase origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpElseIf origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpClassItem origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpAdaptation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpProperty origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpModifier origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpClassDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpInterfaceDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpTraitDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpStaticVar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpScript origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line, PhpAnnotation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public default Code code(str line, node origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), false, "">];
public Code code(str line) = [<line, defaultLoc(), false, "">];

// code end
public Code codeEnd(str line, PhpExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOptionExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOptionName origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOptionElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpActualParameter origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpConst origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpArrayElement origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpName origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpNameOrExpr origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCastType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpClosureUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpIncludeType origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpOp origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpParam origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpScalar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpStmt origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpDeclaration origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCatch origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpCase origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpElseIf origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpElse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpUse origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpClassItem origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpAdaptation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpProperty origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpModifier origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpClassDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpInterfaceDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpTraitDef origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpStaticVar origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpScript origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line, PhpAnnotation origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public default Code codeEnd(str line, node origin) = [<line, origin@origin? ? origin@origin : defaultLoc(), true, "">];
public Code codeEnd(str line) = [<line, defaultLoc(), true, "">];

public Code glue(list[lrel[str, loc, bool, str]] pieces, Code s) = code("") when size(pieces) == 0;
public Code glue(list[lrel[str, loc, bool, str]] pieces, Code s) = pieces[0] when size(pieces) == 1;
public Code glue(list[lrel[str, loc, bool, str]] pieces) = glue(pieces, code(""));
public default Code glue(list[lrel[str, loc, bool, str]] pieces, Code d) = (pieces[0] | it + d + p | p <- slice(pieces, 1, size(pieces) - 1));

public str implode(Code pieces) = ("" | it + l | <str l, loc d, bool _, str _> <- pieces);
