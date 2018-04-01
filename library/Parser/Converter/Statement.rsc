module Parser::Converter::Statement

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Converter::Query;
import Parser::Converter::Assignable;
import Parser::Converter::AssignOperator;
import Parser::Converter::Type;
import String;

public Statement convertStmt(a: (Statement) `<Expression expr>;`, ParseEnv env) = expression(convertExpression(expr, env))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `;`, ParseEnv env) = emptyStmt()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `{<Statement* stmts>}`, ParseEnv env) = block([convertStmt(stmt, env) | stmt <- stmts])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then>`, ParseEnv env)
    = ifThen(convertExpression(condition, env), convertStmt(then, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`, ParseEnv env)
    = ifThenElse(convertExpression(condition, env), convertStmt(then, env), convertStmt(e, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Assignable assignable><AssignOperator operator><Statement val>`, ParseEnv env)
    = assign(convertAssignable(assignable, env), convertAssignOperator(operator), convertStmt(val, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `return;`, ParseEnv env) = \return(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `return <Expression expr>;`, ParseEnv env) = \return(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `persist <Expression expr>;`, ParseEnv env) = persist(convertExpression(expr, env))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `remove <Expression expr>;`, ParseEnv env) = remove(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `flush;`, ParseEnv env) = flush(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `flush <Expression expr>;`, ParseEnv env) = flush(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `break ;`, ParseEnv env) = \break(1)[@src=a@\loc];
public Statement convertStmt(a: (Statement) `break<Integer level>;`, ParseEnv env) = \break(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `continue ;`, ParseEnv env) = \continue(1)[@src=a@\loc];
public Statement convertStmt(a: (Statement) `continue<Integer level>;`, ParseEnv env) = \continue(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>;`, ParseEnv env) =
	declare(convertType(t, env), variable(stringify(varName))[@src=varName@\loc], emptyStmt()[@src=varName@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>=<Statement defValue>`, ParseEnv env) =
	declare(convertType(t, env), variable(stringify(varName))[@src=varName@\loc], convertStmt(defValue, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), emptyExpr()[@src=a@\loc], variable(stringify(var))[@src=var@\loc], convertStmt(body, env), [])[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), emptyExpr()[@src=a@\loc], variable(stringify(var))[@src=var@\loc], convertStmt(body, env), [convertExpression(cond, env) | cond <- conds])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName key>:<MemberName var>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), variable(stringify(key))[@src=key@\loc], variable(stringify(var))[@src=var@\loc], convertStmt(body, env), [])[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName key>:<MemberName var>, <{Expression ","}+ conds>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), variable(stringify(key))[@src=key@\loc], variable(stringify(var))[@src=var@\loc], convertStmt(body, env), [convertExpression(cond, env) | cond <- conds])[@src=a@\loc];
    
