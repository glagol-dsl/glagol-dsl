module Parser::Converter::Statement

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Converter::Assignable;
import Parser::Converter::AssignOperator;
import Parser::Converter::Type;
import String;

public Statement convertStmt(a: (Statement) `<Expression expr>;`) = expression(convertExpression(expr))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `;`) = emptyStmt()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(e))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `return;`) = \return(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `return <Expression expr>;`) = \return(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `persist <Expression expr>;`) = persist(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `flush;`) = flush(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `flush <Expression expr>;`) = flush(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `break ;`) = \break()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `break<Integer level>;`) = \break(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `continue ;`) = \continue()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `continue<Integer level>;`) = \continue(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>;`) = 
	declare(convertType(t), variable("<varName>")[@src=varName@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>=<Statement defValue>`) = 
	declare(convertType(t), variable("<varName>")[@src=varName@\loc], convertStmt(defValue))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>")[@src=var@\loc], convertStmt(body))[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>")[@src=var@\loc], convertStmt(body), [convertExpression(cond) | cond <- conds])[@src=a@\loc];
