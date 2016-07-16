module Parser::Converter::Statement

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Converter::Assignable;
import Parser::Converter::AssignOperator;

public Statement convertStmt((Statement) `<Expression expr>;`) = expression(convertExpression(expr));
public Statement convertStmt((Statement) `;`) = emptyStmt();
public Statement convertStmt((Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts]);

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then));

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then> else <Statement \else>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(\else));

public Statement convertStmt((Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val));

public Statement convertStmt((Statement) `return <Expression expr>;`) = \return(convertExpression(expr));
