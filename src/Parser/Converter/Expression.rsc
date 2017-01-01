module Parser::Converter::Expression

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::QuotedString;
import Exceptions::ParserExceptions;

public Expression convertExpression(a: (Expression) `(<Expression expr>)`) = \bracket(convertExpression(expr))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<Expression lhs> * <Expression rhs>`) 
    = product(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> / <Expression rhs>`) 
    = division(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> + <Expression rhs>`) 
    = addition(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> - <Expression rhs>`) 
    = subtraction(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \>= <Expression rhs>`) 
    = greaterThanOrEq(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \<= <Expression rhs>`) 
    = lessThanOrEq(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \< <Expression rhs>`) 
    = lessThan(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \> <Expression rhs>`) 
    = greaterThan(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> == <Expression rhs>`) 
    = equals(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> != <Expression rhs>`) 
    = nonEquals(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> && <Expression rhs>`) 
    = and(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> || <Expression rhs>`) 
    = or(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> % <Expression rhs>`) 
    = remainder(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<StringQuoted s>`)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Boolean b>`)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `[<{Expression ","}* items>]`)
    = \list([convertExpression(i) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName varName>`)
    = variable("<varName>")[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `+<Expression expr>`) 
    = positive(convertExpression(expr))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `this`) = this()[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `<StringQuoted s>`)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<Boolean b>`)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `[<{DefaultValue ","}* items>]`)
    = \list([convertExpression(i) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `get <InstanceType t>`)
    = get(convertInstanceType(t))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Type convertInstanceType(a: (InstanceType) `<Type t>`) = convertType(t)[@src=a@\loc];
public Type convertInstanceType(a: (InstanceType) `selfie`) = selfie()[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `get <Type t>`)
    = get(convertType(t))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName method>(<{Expression ","}* args>)`) 
    = invoke("<method>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }
    
    return invoke(convertExpression(prev), "<method>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName field>`) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }

    return fieldAccess(convertExpression(prev), "<field>")[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `{<{MapPair ","}* pairs>}`) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p) )
)[@src=a@\loc];

private tuple[Expression key, Expression \value] convertMapPair((MapPair) `<Expression key>:<Expression v>`)
    = <convertExpression(key), convertExpression(v)>;

private bool isValidForAccessChain((Expression) `<MemberName varName>`) = true;
private bool isValidForAccessChain((Expression) `this`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `get <Type t>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;
