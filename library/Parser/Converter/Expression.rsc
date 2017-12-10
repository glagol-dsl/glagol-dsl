module Parser::Converter::Expression

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::QuotedString;
import Parser::Converter::Symbol;
import Exceptions::ParserExceptions;

public Expression convertExpression(a: (Expression) `(<Expression expr>)`, ParseEnv env) = \bracket(convertExpression(expr, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<Expression lhs> * <Expression rhs>`, ParseEnv env)
    = product(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> / <Expression rhs>`, ParseEnv env)
    = division(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> + <Expression rhs>`, ParseEnv env)
    = addition(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> - <Expression rhs>`, ParseEnv env)
    = subtraction(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \>= <Expression rhs>`, ParseEnv env)
    = greaterThanOrEq(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \<= <Expression rhs>`, ParseEnv env)
    = lessThanOrEq(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \< <Expression rhs>`, ParseEnv env)
    = lessThan(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \> <Expression rhs>`, ParseEnv env)
    = greaterThan(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> == <Expression rhs>`, ParseEnv env)
    = equals(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> != <Expression rhs>`, ParseEnv env)
    = nonEquals(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> && <Expression rhs>`, ParseEnv env)
    = and(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> || <Expression rhs>`, ParseEnv env)
    = or(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> % <Expression rhs>`, ParseEnv env)
    = remainder(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`, ParseEnv env)
    = ifThenElse(convertExpression(condition, env), convertExpression(thenExp, env), convertExpression(elseExp, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<StringQuoted s>`, ParseEnv env)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DecimalIntegerLiteral number>`, ParseEnv env)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DeciFloatNumeral number>`, ParseEnv env)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Boolean b>`, ParseEnv env)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `[<{Expression ","}* items>]`, ParseEnv env)
    = \list([convertExpression(i, env) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName varName>`, ParseEnv env)
    = variable("<varName>")[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `-<Expression expr>`, ParseEnv env)
    = negative(convertExpression(expr, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `+<Expression expr>`, ParseEnv env)
    = positive(convertExpression(expr, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `this`, ParseEnv env) = this()[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `<StringQuoted s>`, ParseEnv env)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DecimalIntegerLiteral number>`, ParseEnv env)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DeciFloatNumeral number>`, ParseEnv env)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<Boolean b>`, ParseEnv env)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `[<{DefaultValue ","}* items>]`, ParseEnv env)
    = \list([convertExpression(i, env) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `get <InstanceType t>`, ParseEnv env)
    = get(convertInstanceType(t, env))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env)
    = new(createName("<name>", env)[@src=name@\loc], [convertExpression(arg, env) | arg <- args])[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `{<{MapPair ","}* pairs>}`, ParseEnv env) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p, env) )
)[@src=a@\loc];

public Type convertInstanceType(a: (InstanceType) `<Type t>`, ParseEnv env) = convertType(t, env)[@src=a@\loc];
public Type convertInstanceType(a: (InstanceType) `selfie`, ParseEnv env) = selfie()[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env)
    = new(createName("<name>", env)[@src=name@\loc], [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
    
// public Expression convertExpression(a: (Expression) `get <Type t>`, ParseEnv env) = get(convertType(t, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName method>(<{Expression ","}* args>)`, ParseEnv env)
    = invoke(convertSymbol(method), [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`, ParseEnv env) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }
    
    return invoke(convertExpression(true, prev, env), convertSymbol(method), [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
}

public Expression convertExpression(brackets: true, e: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env) = 
	\bracket(convertExpression(e, env))[@src = e@\loc];
	
public Expression convertExpression(brackets: true, e, ParseEnv env) = convertExpression(e, env);

public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName field>`, ParseEnv env) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }

    return fieldAccess(convertExpression(true, prev, env), convertSymbol(field))[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `{<{MapPair ","}* pairs>}`, ParseEnv env) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p, env) )
)[@src=a@\loc];

private tuple[Expression key, Expression \value] convertMapPair((MapPair) `<Expression key>:<Expression v>`, ParseEnv env)
    = <convertExpression(key, env), convertExpression(v, env)>;

public Expression convertExpression(a: (Expression) `(<Type t>)<Expression expr>`, ParseEnv env) = 
	cast(convertType(t, env), convertExpression(expr, env))[@src=a@\loc];

private bool isValidForAccessChain((Expression) `<MemberName varName>`) = true;
private bool isValidForAccessChain((Expression) `this`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
//private bool isValidForAccessChain((Expression) `get <Type t>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;
