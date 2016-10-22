module Parser::Converter::Declaration::Constructor

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;
import Exceptions::ParserExceptions;

public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);
}
    
public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
}

public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{Parameter ","}* parameters>);`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], []);
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, _) = convertConstructor(construct, artifactName);
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, _) 
    = annotated([convertAnnotation(annotation) | annotation <- annotations], convertConstructor(construct, artifactName));
