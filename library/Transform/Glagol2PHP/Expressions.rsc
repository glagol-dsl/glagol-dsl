module Transform::Glagol2PHP::Expressions

import Transform::Env;
import Transform::OriginAnnotator;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Utils::String;

// literals
public PhpExpr toPhpExpr(e: integer(int i), TransformEnv env) = origin(phpScalar(phpInteger(i)), e, true);
public PhpExpr toPhpExpr(e: float(real r), TransformEnv env) = origin(phpScalar(phpFloat(r)), e, true);
public PhpExpr toPhpExpr(e: string(str s), TransformEnv env) = origin(phpScalar(phpString(s)), e, true);
public PhpExpr toPhpExpr(e: boolean(bool b), TransformEnv env) = origin(phpScalar(phpBoolean(b)), e, true);

// arrays
public PhpExpr toPhpExpr(e: \list(list[Expression] items), TransformEnv env) = 
	origin(
		phpNew(
			phpName(phpName("Vector")), 
			[origin(phpActualParameter(
				origin(phpArray(
					[origin(phpArrayElement(phpNoExpr(), toPhpExpr(i, env), false), i) | i <- items
				]), e), false), e)]
		), 
	e);

public PhpExpr toPhpExpr(e: arrayAccess(Expression variable, Expression arrayIndexKey), TransformEnv env) = 
	origin(phpFetchArrayDim(toPhpExpr(variable, env), origin(phpSomeExpr(toPhpExpr(arrayIndexKey, env)), e)), e);

public PhpExpr toPhpExpr(e: \map(map[Expression key, Expression \value] m), TransformEnv env) = 
    origin(phpStaticCall(origin(phpName(phpName("MapFactory")), e, true), origin(phpName(phpName("createFromPairs")), e, true), [
        origin(phpActualParameter(
        	origin(phpNew(
        		origin(phpName(phpName("Pair")), k, true), [
        			origin(phpActualParameter(toPhpExpr(k, env), false), k), 
        			origin(phpActualParameter(toPhpExpr(m[k], env), false), m[k])
    			]), k), false
		), k) | k <- m
    ]), e);

public PhpExpr toPhpExpr(e: get(artifact(Name name)), TransformEnv env)
    = origin(phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("_<toLowerCaseFirstChar(name.localName)>"))), e, true);

public PhpExpr toPhpExpr(e: variable(GlagolID name), TransformEnv env) = 
	origin(isField(name, env) ? phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName(name))) : phpVar(phpName(phpName(name))), e, true);

public PhpExpr toPhpExpr(e: ifThenElse(Expression condition, Expression ifThen, Expression \else), TransformEnv env) 
    = origin(phpTernary(toPhpExpr(condition, env), origin(phpSomeExpr(toPhpExpr(ifThen, env)), ifThen), toPhpExpr(\else, env)), e);

public PhpExpr toPhpExpr(e: new(Name artifact, list[Expression] args), TransformEnv env)
    = origin(phpNew(origin(phpName(phpName(artifact.localName)), artifact, true), 
    	[origin(phpActualParameter(toPhpExpr(arg, env), false), arg) | arg <- args]), e);

// Binary operations
public PhpExpr toPhpExpr(e: equals(Expression l, Expression r), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(l, env), toPhpExpr(r, env), origin(phpIdentical(), e)), e);

public PhpExpr toPhpExpr(e: greaterThan(Expression l, Expression r), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(l, env), toPhpExpr(r, env), origin(phpGt(), e)), e);
	
public PhpExpr toPhpExpr(e: product(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpMul(), e)), e);
	
public PhpExpr toPhpExpr(e: remainder(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpMod(), e)), e);
	
public PhpExpr toPhpExpr(e: division(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpDiv(), e)), e);
	
public PhpExpr toPhpExpr(e: addition(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpPlus(), e)), e);
	
public PhpExpr toPhpExpr(e: concat(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpConcat(), e)), e);
	
public PhpExpr toPhpExpr(e: subtraction(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpMinus(), e)), e);
	
public PhpExpr toPhpExpr(b: \bracket(Expression e), TransformEnv env) = 
	origin(phpBracket(origin(phpSomeExpr(toPhpExpr(e, env)), b)), b);

public PhpExpr toPhpExpr(e: greaterThanOrEq(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpGeq(), e)), e);
	
public PhpExpr toPhpExpr(e: lessThanOrEq(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpLeq(), e)), e);

public PhpExpr toPhpExpr(e: lessThan(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpLt(), e)), e);

public PhpExpr toPhpExpr(e: greaterThan(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpGt(), e)), e);
	
public PhpExpr toPhpExpr(e: equals(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpIdentical(), e)), e);

public PhpExpr toPhpExpr(e: nonEquals(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpNotIdentical(), e)), e);

public PhpExpr toPhpExpr(e: and(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpLogicalAnd(), e)), e);

public PhpExpr toPhpExpr(e: or(Expression lhs, Expression rhs), TransformEnv env) = 
	origin(phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), origin(phpLogicalOr(), e)), e);

public PhpExpr toPhpExpr(e: cast(Type t, Expression expr), TransformEnv env) = 
	origin(phpCast(toPhpCastType(t), toPhpExpr(expr, env)), e);

public PhpCastType toPhpCastType(e: string()) = origin(phpString(), e);
public PhpCastType toPhpCastType(e: float()) = origin(phpFloat(), e);
public PhpCastType toPhpCastType(e: integer()) = origin(phpInt(), e);
public PhpCastType toPhpCastType(e: boolean()) = origin(phpBool(), e);

// Unary operations
public PhpExpr toPhpExpr(n: negative(Expression e), TransformEnv env) = 
	origin(phpUnaryOperation(toPhpExpr(e, env), origin(phpUnaryMinus(), n)), n);

// Method call
public PhpExpr toPhpExpr(e: invoke(s: symbol(str methodName), list[Expression] args), TransformEnv env) =
    phpMethodCall(
		phpVar(phpName(phpName("this"))), 
		origin(phpName(phpName(methodName)), s, true), 
		[origin(phpActualParameter(toPhpExpr(arg, env), false), arg) | arg <- args]
	);

public PhpExpr toPhpExpr(e: invoke(Expression prev, s: symbol(str methodName), list[Expression] args), TransformEnv env) =
    phpMethodCall(
		toPhpExpr(prev, env), 
		origin(phpName(phpName(methodName)), s, true), 
		[origin(phpActualParameter(toPhpExpr(arg, env), false), arg) | arg <- args]
	);

// Property fetch
public PhpExpr toPhpExpr(e: fieldAccess(s: symbol(str name)), TransformEnv env) =
    phpPropertyFetch(phpVar(phpName(phpName("this"))), origin(phpName(phpName(name)), s, true));
    
public PhpExpr toPhpExpr(e: fieldAccess(Expression prev, s: symbol(str name)), TransformEnv env) =
    phpPropertyFetch(toPhpExpr(prev, env), origin(phpName(phpName(name)), s, true));
    
public PhpExpr toPhpExpr(e: this(), TransformEnv env) = origin(phpVar(phpName(phpName("this"))), e);

public PhpExpr toPhpExpr(e: query(querySelect(spec: querySpec(symbol(str as), false), QuerySource src, QueryWhere where, QueryOrderBy order, QueryLimit limit)), TransformEnv env) =
	phpMethodCall(
		phpMethodCall(
			setWhereClause(where, makeQueryBuilder(spec, src), env),
			phpName(phpName("getQuery")),
			[]
		),
		phpName(phpName("execute")),
		[]
	);
	
public PhpExpr toPhpExpr(e: query(querySelect(spec: querySpec(symbol(str as), true), QuerySource src, QueryWhere where, QueryOrderBy order, QueryLimit limit)), TransformEnv env) =
	phpMethodCall(
		phpMethodCall(
			setWhereClause(where, makeQueryBuilder(spec, src), env),
			phpName(phpName("getQuery")),
			[]
		),
		phpName(phpName("getOneOrNullResult")),
		[]
	);

public PhpExpr setWhereClause(noWhere(), PhpExpr prev, TransformEnv env) = prev;
public PhpExpr setWhereClause(expression(QueryExpression expr), PhpExpr prev, TransformEnv env) = 
	phpMethodCall(
		phpMethodCall(prev, phpName(phpName("where")), [phpActualParameter(toPhpExpr(expr, env), false)]),
		phpName(phpName("setParameters")),
		[phpActualParameter(collectParameters(expr, env), false)]
	);

private PhpExpr collectParameters(QueryExpression expr, TransformEnv env) {
	map[str, PhpExpr] paramValues = ();
	
	top-down visit (expr) {
		case glagolExpr(Expression glExpr, int id): {
			paramValues["param_<id>"] = toPhpExpr(glExpr, env);
		}
	}
	
	return phpArray([phpArrayElement(phpSomeExpr(phpScalar(phpString(k))), paramValues[k], false) | k <- paramValues]);
}

public PhpExpr toPhpExpr(\bracket(QueryExpression expr), TransformEnv env) = toPhpExpr(expr, env);
public PhpExpr toPhpExpr(equals(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("eq")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(nonEquals(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("neq")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(greaterThan(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("gt")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(greaterThanOrEq(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("gte")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(lowerThan(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("lt")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(lowerThanOrEq(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("lte")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(isNull(QueryExpression expr), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("isNull")), [
		phpActualParameter(toPhpExpr(expr, env), false)
	]);
public PhpExpr toPhpExpr(isNotNull(QueryExpression expr), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("isNotNull")), [
		phpActualParameter(toPhpExpr(expr, env), false)
	]);
public PhpExpr toPhpExpr(and(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("andX")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(or(QueryExpression lhs, QueryExpression rhs), TransformEnv env) = 
	phpMethodCall(queryExpr(), phpName(phpName("orX")), [
		phpActualParameter(toPhpExpr(lhs, env), false), phpActualParameter(toPhpExpr(rhs, env), false)
	]);
public PhpExpr toPhpExpr(glagolExpr(Expression glExpr, int id), TransformEnv env) = phpScalar(phpString(":param_<id>"));
public PhpExpr toPhpExpr(queryField(queryField(symbol(str entity), symbol(str field))), TransformEnv env) = phpScalar(phpString("<entity>.<field>"));

public PhpExpr queryExpr() = 
	phpMethodCall(
		phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("_em"))),
		phpName(phpName("getExpressionBuilder")),
		[]
	);

public PhpExpr makeQueryBuilder(querySpec(symbol(str as), bool single), querySource(fullName(str org, Declaration ns, str entity), Symbol s)) = 
	phpMethodCall(
		phpMethodCall(
			phpMethodCall(
				phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("_em"))),
				phpName(phpName("createQueryBuilder")),
				[]
			),
			phpName(phpName("select")),
			[phpActualParameter(phpScalar(phpString(as)), false)]
		),
		phpName(phpName("from")),
		[
			phpActualParameter(phpFetchClassConst(phpName(phpName(entity)), "class"), false), 
			phpActualParameter(phpScalar(phpString(as)), false)
		]
	);
	