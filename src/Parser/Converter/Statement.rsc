module Parser::Converter::Statement

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Converter::Assignable;
import Parser::Converter::AssignOperator;
import Parser::Converter::Type;

public Statement convertStmt((Statement) `<Expression expr>;`) = expression(convertExpression(expr));
public Statement convertStmt((Statement) `;`) = emptyStmt();
public Statement convertStmt((Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts]);

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then));

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(e));

public Statement convertStmt((Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val));

public Statement convertStmt((Statement) `return <Expression expr>;`) = \return(convertExpression(expr));

public Statement convertStmt((Statement) `<Type t> <MemberName varName>;`) = declare(convertType(t), variable("<varName>"));
public Statement convertStmt((Statement) `<Type t> <MemberName varName>=<Statement defValue>`) 
    = declare(convertType(t), variable("<varName>"), convertStmt(defValue));
