module Parser::Converter::Declaration::Method

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));
    
private Modifier convertModifier((Modifier) `public`) = \public();
private Modifier convertModifier((Modifier) `private`) = \private();

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _) = convertMethod(method);
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Method method>`, _, _) 
    = annotated([convertAnnotation(annotation) | annotation <- annotations], convertMethod(method));

