module Parser::Converter::Query

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Env;

public QueryStatement convertQuery(a: (QueryStatement) `<QuerySelectStmt selectStatement>`, ParseEnv env) = convertQuery(selectStatement, env);

public QueryStatement convertQuery(a: (QuerySelectStmt) `SELECT<QuerySpec spec>FROM<QuerySource s><QueryWhere? where><QueryOrderBy? order><QueryLimit? limit>`, ParseEnv env) =
	querySelect(convertSpec(spec), convertSource(s, env), convertWhere(where, env), covertOrderBy(order, env), convertLimit(limit, env))[@src=a@\loc];

public QuerySpec convertSpec(a: (QuerySpec) `<MemberName as>`) = querySpec(convertSymbol(as), true)[@src=a@\loc];
public QuerySpec convertSpec(a: (QuerySpec) `<MemberName as>[]`) = querySpec(convertSymbol(as), false)[@src=a@\loc];

public QuerySource convertSource(a: (QuerySource) `<ArtifactName artifact><MemberName as>`, ParseEnv env) = 
	querySource(createName("<artifact>", env), convertSymbol(as))[@src=a@\loc];
public QuerySource convertSource(a: (QuerySource) `<ArtifactName artifact>as<MemberName as>`, ParseEnv env) = 
	querySource(createName("<artifact>", env), convertSymbol(as))[@src=a@\loc];

public QueryWhere convertWhere(a: (QueryWhere) `WHERE<QueryExpression expr>`, ParseEnv env) = expression(convertQueryExpression(expr, env))[@src=a@\loc];
public QueryWhere convertWhere(a: appl(regular(opt(sort("QueryWhere"))), []), ParseEnv env) = noWhere()[@src=a@\loc];
public QueryWhere convertWhere(a: appl(regular(opt(sort("QueryWhere"))), list[Tree] args), ParseEnv env) = convertWhere(args[0], env);

public QueryOrderBy covertOrderBy(a: (QueryOrderBy) `ORDER BY<{QueryOrderByField ","}+ fields>`, ParseEnv env) = 
	orderBy([covertOrderBy(f, env) | f <- fields])[@src=a@\loc];
public QueryOrderBy covertOrderBy(a: (QueryOrderByField) `<QueryField field>`, ParseEnv env) = orderBy(convertQueryField(field), false)[@src=a@\loc];
public QueryOrderBy covertOrderBy(a: (QueryOrderByField) `<QueryField field>ASC`, ParseEnv env) = orderBy(convertQueryField(field), false)[@src=a@\loc];
public QueryOrderBy covertOrderBy(a: (QueryOrderByField) `<QueryField field>DESC`, ParseEnv env) = orderBy(convertQueryField(field), true)[@src=a@\loc];
public QueryOrderBy covertOrderBy(a: appl(Production prod, []), ParseEnv env) = noOrderBy()[@src=a@\loc];
public QueryOrderBy covertOrderBy(a: appl(regular(opt(sort("QueryOrderBy"))), list[Tree] args), ParseEnv env) = covertOrderBy(args[0], env);

public QueryField convertQueryField(a: (QueryField) `<MemberName artifact>.<MemberName field>`) = queryField(convertSymbol(artifact), convertSymbol(field))[@src=a@\loc];

public QueryLimit convertLimit(a: (QueryLimit) `LIMIT<QueryExpression size>`, ParseEnv env) = limit(convertQueryExpression(size, env), noQueryExpr()[@src=a@\loc])[@src=a@\loc];
public QueryLimit convertLimit(a: (QueryLimit) `LIMIT<QueryExpression size>OFFSET<QueryExpression offset>`, ParseEnv env) = 
	limit(convertQueryExpression(size, env), convertQueryExpression(offset, env))[@src=a@\loc];
public QueryLimit convertLimit(a: (QueryLimit) `LIMIT<QueryExpression offset>,<QueryExpression size>`, ParseEnv env) = 
	limit(convertQueryExpression(size, env), convertQueryExpression(offset, env))[@src=a@\loc];

public QueryLimit convertLimit(a: appl(Production prod, []), ParseEnv env) = noLimit()[@src=a@\loc];
public QueryLimit convertLimit(a: appl(regular(opt(sort("QueryLimit"))), list[Tree] args), ParseEnv env) = convertLimit(args[0], env);

public QueryExpression convertQueryExpression(a: (QueryExpression) `(<QueryExpression expr>)`, ParseEnv env) = \bracket(convertQueryExpression(expr, env))[@src=a@\loc];
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>=<QueryExpression r>`, ParseEnv env) = 
	equals(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>!=<QueryExpression r>`, ParseEnv env) = 
	nonEquals(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>\><QueryExpression r>`, ParseEnv env) = 
	greaterThan(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>\>=<QueryExpression r>`, ParseEnv env) = 
	greaterThanOrEq(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>\<<QueryExpression r>`, ParseEnv env) = 
	lowerThan(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>\<=<QueryExpression r>`, ParseEnv env) = 
	lowerThanOrEq(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression exp>IS NULL`, ParseEnv env) = 
	isNull(convertQueryExpression(exp, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression exp>IS NOT NULL`, ParseEnv env) = 
	isNotNull(convertQueryExpression(exp, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>AND<QueryExpression r>`, ParseEnv env) = 
	and(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>OR<QueryExpression r>`, ParseEnv env) = 
	or(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryExpression l>AND<QueryExpression r>`, ParseEnv env) = 
	and(convertQueryExpression(l, env), convertQueryExpression(r, env))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `\<<Expression exp>\>`, ParseEnv env) = 
	glagolExpr(convertExpression(exp, env), arbInt(100000))[@src=a@\loc];
	
public QueryExpression convertQueryExpression(a: (QueryExpression) `<QueryField field>`, ParseEnv env) = 
	queryField(convertQueryField(field))[@src=a@\loc];
