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
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body])[@src=a@\loc];
}
    
public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>);`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p) | p <- parameters], [])[@src=a@\loc];
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, _) = convertConstructor(construct, artifactName);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, _) 
    = convertConstructor(construct, artifactName)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
