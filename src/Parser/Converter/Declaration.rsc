module Parser::Converter::Declaration

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Exceptions::ParserExceptions;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::RelationDir;

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});

public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);
}
    
public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
}

public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>);`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], []);
}

public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name>;`, _) 
    = \value(convertType(valueType), "<name>");
    
public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));
    
