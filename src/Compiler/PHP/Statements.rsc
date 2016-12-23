module Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::Indentation;
import Compiler::PHP::Glue;
import Compiler::PHP::NewLine;
import List;

public str toCode(list[PhpStmt] statements, i) = ("" | it + toCode(stmt, i) + nl() | stmt <- statements);
public str toCode(phpExprstmt(PhpExpr expr), int i) = "<s(i)><toCode(expr, i)>;";
public str toCode(phpReturn(phpSomeExpr(PhpExpr expr)), int i) = "<nl()><s(i)>return <toCode(expr, i)>;";
public str toCode(phpReturn(phpNoExpr()), int i) = "<nl()><s(i)>return;";
public str toCode(phpBreak(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>break <toCode(expr, i)>;";
public str toCode(phpBreak(phpNoExpr()), int i) = "<s(i)>break;";
public str toCode(phpContinue(phpSomeExpr(PhpExpr expr)), int i) = "<s(i)>continue <toCode(expr, i)>;";
public str toCode(phpContinue(phpNoExpr()), int i) = "<s(i)>continue;";
public str toCode(phpConst(list[PhpConst] consts), int i) = "<s(i)>const <glue([toCode(c, i) | c <- consts], ",<nl()><s(i)>      ")>;";
public str toCode(phpConst(str name, PhpExpr val), int i) = "<name> = <toCode(val, i)>";
public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = "declare(<glue([toCode(d, i) | d <- decls], ", ")>);" when size(body) == 0;
public str toCode(phpDeclare(list[PhpDeclaration] decls, list[PhpStmt] body), int i) = "declare(<glue([toCode(d, i) | d <- decls], ", ")>) {<nl()><toCode(body, i + 1)>}" when size(body) > 0;
public str toCode(phpDeclaration(str key, PhpExpr val), int i) = "<key>=<toCode(val, i)>";
