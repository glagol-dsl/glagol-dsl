module Transform::Glagol2PHP::Expressions

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Utils::String;

// literals
public PhpExpr toPhpExpr(integer(int i), TransformEnv env) = phpScalar(phpInteger(i));
public PhpExpr toPhpExpr(float(real r), TransformEnv env) = phpScalar(phpFloat(r));
public PhpExpr toPhpExpr(string(str s), TransformEnv env) = phpScalar(phpString(s));
public PhpExpr toPhpExpr(boolean(bool b), TransformEnv env) = phpScalar(phpBoolean(b));

// arrays
public PhpExpr toPhpExpr(\list(list[Expression] items), TransformEnv env) = 
	phpNew(phpName(phpName("Vector")), [phpActualParameter(phpArray([phpArrayElement(phpNoExpr(), toPhpExpr(i, env), false) | i <- items]), false)]);

public PhpExpr toPhpExpr(arrayAccess(Expression variable, Expression arrayIndexKey), TransformEnv env) = 
	phpFetchArrayDim(toPhpExpr(variable, env), phpSomeExpr(toPhpExpr(arrayIndexKey, env)));

public PhpExpr toPhpExpr(\map(map[Expression key, Expression \value] m), TransformEnv env) = 
    phpStaticCall(phpName(phpName("MapFactory")), phpName(phpName("createFromPairs")), [
        phpActualParameter(phpNew(phpName(phpName("Pair")), [phpActualParameter(toPhpExpr(k, env), false), 
        phpActualParameter(toPhpExpr(m[k], env), false)]), false) | k <- m
    ]);

public PhpExpr toPhpExpr(get(artifact(Name name)), TransformEnv env)
    = phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName("_<toLowerCaseFirstChar(name.localName)>")));

public PhpExpr toPhpExpr(variable(GlagolID name), TransformEnv env) = phpVar(phpName(phpName(name)));

public PhpExpr toPhpExpr(ifThenElse(Expression condition, Expression ifThen, Expression \else), TransformEnv env) 
    = phpTernary(toPhpExpr(condition, env), phpSomeExpr(toPhpExpr(ifThen, env)), toPhpExpr(\else, env));

public PhpExpr toPhpExpr(new(Name artifact, list[Expression] args), TransformEnv env)
    = phpNew(phpName(phpName(artifact.localName)), [phpActualParameter(toPhpExpr(arg, env), false) | arg <- args]);

// Binary operations
public PhpExpr toPhpExpr(equals(Expression l, Expression r), TransformEnv env) = phpBinaryOperation(toPhpExpr(l, env), toPhpExpr(r, env), phpIdentical());
public PhpExpr toPhpExpr(greaterThan(Expression l, Expression r), TransformEnv env) = phpBinaryOperation(toPhpExpr(l, env), toPhpExpr(r, env), phpGt());
public PhpExpr toPhpExpr(product(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpMul());
public PhpExpr toPhpExpr(remainder(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpMod());
public PhpExpr toPhpExpr(division(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpDiv());
public PhpExpr toPhpExpr(addition(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpPlus());
public PhpExpr toPhpExpr(subtraction(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpMinus());
public PhpExpr toPhpExpr(\bracket(Expression e), TransformEnv env) = phpBracket(phpSomeExpr(toPhpExpr(e, env)));
public PhpExpr toPhpExpr(greaterThanOrEq(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpGeq());
public PhpExpr toPhpExpr(lessThanOrEq(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpLeq());
public PhpExpr toPhpExpr(lessThan(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpLt());
public PhpExpr toPhpExpr(greaterThan(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpGt());
public PhpExpr toPhpExpr(equals(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpIdentical());
public PhpExpr toPhpExpr(nonEquals(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpNotIdentical());
public PhpExpr toPhpExpr(and(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpLogicalAnd());
public PhpExpr toPhpExpr(or(Expression lhs, Expression rhs), TransformEnv env) = phpBinaryOperation(toPhpExpr(lhs, env), toPhpExpr(rhs, env), phpLogicalOr());

public PhpExpr toPhpExpr(cast(Type t, Expression expr), TransformEnv env) = phpCast(toPhpCastType(t), toPhpExpr(expr, env));

public PhpCastType toPhpCastType(string()) = phpString();
public PhpCastType toPhpCastType(float()) = phpFloat();
public PhpCastType toPhpCastType(integer()) = phpInt();
public PhpCastType toPhpCastType(boolean()) = phpBool();

// Unary operations
public PhpExpr toPhpExpr(negative(Expression e), TransformEnv env) = phpUnaryOperation(toPhpExpr(e, env), phpUnaryMinus());
public PhpExpr toPhpExpr(positive(Expression e), TransformEnv env) = phpUnaryOperation(toPhpExpr(e, env), phpUnaryPlus());

// Method call
public PhpExpr toPhpExpr(invoke(str methodName, list[Expression] args), TransformEnv env) =
    phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName(methodName)), [phpActualParameter(toPhpExpr(arg, env), false) | arg <- args]);

public PhpExpr toPhpExpr(invoke(Expression prev, str methodName, list[Expression] args), TransformEnv env) =
    phpMethodCall(toPhpExpr(prev, env), phpName(phpName(methodName)), [phpActualParameter(toPhpExpr(arg, env), false) | arg <- args]);

// Property fetch
public PhpExpr toPhpExpr(fieldAccess(str name), TransformEnv env) =
    phpPropertyFetch(phpVar(phpName(phpName("this"))), phpName(phpName(name)));
    
public PhpExpr toPhpExpr(fieldAccess(Expression prev, str name), TransformEnv env) =
    phpPropertyFetch(toPhpExpr(prev, env), phpName(phpName(name)));
    
public PhpExpr toPhpExpr(this(), TransformEnv env) = phpVar(phpName(phpName("this")));


