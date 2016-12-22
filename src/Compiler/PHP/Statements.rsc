module Compiler::PHP::Statements

import Syntax::Abstract::PHP;
import Compiler::PHP::Expressions;
import Compiler::PHP::Indentation;
import Compiler::PHP::Glue;
import Compiler::PHP::NewLine;

public str toCode(list[PhpStmt] statements, i) = ("" | it + toCode(stmt, i) + nl() | stmt <- statements);
public str toCode(phpExprstmt(PhpExpr expr), int i) = "<s(i)><toCode(expr, i)>;";
public str toCode(phpReturn(phpSomeExpr(PhpExpr expr)), int i) = "<nl()><s(i)>return <toCode(expr, i)>;";
public str toCode(phpReturn(phpNoExpr()), int i) = "<nl()><s(i)>return;";
