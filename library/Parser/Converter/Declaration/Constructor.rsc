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
    str artifactName, t: /repository|util/, ParseEnv env)
{
	t = t == "util" ? "util/service" : t;
    throw ConstructorNotAllowed("Constructor not allowed for <t> artifacts", a@\loc);
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName, _, ParseEnv env) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    } 
    
    return constructor([convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr())[@src=a@\loc];
}
    
public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName, _, ParseEnv env)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>);`, 
    str artifactName, _, ParseEnv env) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p, env) | p <- parameters], [], emptyExpr())[@src=a@\loc];
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, str artifactType, ParseEnv env) = 
	convertConstructor(construct, artifactName, artifactType, env);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, str artifactType, ParseEnv env) 
    = convertConstructor(construct, artifactName, artifactType, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];
