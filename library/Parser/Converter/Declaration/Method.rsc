module Parser::Converter::Declaration::Method

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], convertWhen(when, env))[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], convertWhen(when, env))[@src=a@\loc];
    
private Modifier convertModifier(a: (Modifier) `public`) = \public()[@src=a@\loc];
private Modifier convertModifier(a: (Modifier) `private`) = \private()[@src=a@\loc];

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _, ParseEnv env) = convertMethod(method, env);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Method method>`, _, _, ParseEnv env) 
    = convertMethod(method, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

