module Parser::Converter::Declaration::Method

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], convertWhen(when))[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], convertWhen(when))[@src=a@\loc];
    
private Modifier convertModifier(a: (Modifier) `public`) = \public()[@src=a@\loc];
private Modifier convertModifier(a: (Modifier) `private`) = \private()[@src=a@\loc];

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _) = convertMethod(method);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Method method>`, _, _) 
    = convertMethod(method)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];

