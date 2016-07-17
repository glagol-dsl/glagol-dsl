module Parser::Converter::Expression

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::QuotedString;

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
    = array([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `<MemberName varName>`)
    = variable("<varName>");
    
public Expression convertExpression((Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr));

public Expression convertExpression((DefaultValue) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((DefaultValue) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = array([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `new <ArtifactName name>`) = new("<name>", []);
public Expression convertExpression((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args]);

