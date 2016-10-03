module Parser::Converter::Expression

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::QuotedString;
import Exceptions::ParserExceptions;

public Expression convertExpression((Expression) `(<Expression expr>)`) = \bracket(convertExpression(expr));

public Expression convertExpression((Expression) `<Expression lhs> * <Expression rhs>`) 
    = product(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> / <Expression rhs>`) 
    = division(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> + <Expression rhs>`) 
    = addition(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> - <Expression rhs>`) 
    = subtraction(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \>= <Expression rhs>`) 
    = greaterThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \<= <Expression rhs>`) 
    = lessThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \< <Expression rhs>`) 
    = lessThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \> <Expression rhs>`) 
    = greaterThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> == <Expression rhs>`) 
    = equals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> != <Expression rhs>`) 
    = nonEquals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> && <Expression rhs>`) 
    = and(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> || <Expression rhs>`) 
    = or(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp));

public Expression convertExpression((Expression) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((Expression) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((Expression) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((Expression) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((Expression) `[<{Expression ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `<MemberName varName>`)
    = variable("<varName>");
    
public Expression convertExpression((Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr));

public Expression convertExpression((Expression) `this`) = this();

public Expression convertExpression((DefaultValue) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((DefaultValue) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((DefaultValue) `get <InstanceType t>`)
    = get(convertInstanceType(t));
    
public Type convertInstanceType((InstanceType) `<Type t>`) = convertType(t);
public Type convertInstanceType((InstanceType) `selfie`) = selfie();
    
public Expression convertExpression((Expression) `new <ArtifactName name>`) = new("<name>", []);
public Expression convertExpression((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args]);
    
public Expression convertExpression((Expression) `get <Type t>`)
    = get(convertType(t));
    
public Expression convertExpression((Expression) `<MemberName method>(<{Expression ","}* args>)`) 
    = invoke("<method>", [convertExpression(arg) | arg <- args]);
    
public Expression convertExpression((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator");
    }
    
    return invoke(convertExpression(prev), "<method>", [convertExpression(arg) | arg <- args]);
}

public Expression convertExpression((Expression) `<Expression prev>.<MemberName field>`) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator");
    }

    return fieldAccess(convertExpression(prev), "<field>");
}

public Expression convertExpression((Expression) `{<{MapPair ","}* pairs>}`) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p) )
);

private tuple[Expression key, Expression \value] convertMapPair((MapPair) `<Expression key>:<Expression v>`)
    = <convertExpression(key), convertExpression(v)>;

private bool isValidForAccessChain((Expression) `<MemberName varName>`) = true;
private bool isValidForAccessChain((Expression) `this`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>`) = true;
private bool isValidForAccessChain((Expression) `get <Type t>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;
