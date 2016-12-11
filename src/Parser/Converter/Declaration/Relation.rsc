module Parser::Converter::Declaration::Relation

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::RelationDir;
import Parser::Converter::AccessProperty;

public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Relation relation>`, _, _) 
    = annotated([convertAnnotation(annotation) | annotation <- annotations], convertRelation(relation));
    
public Declaration convertDeclaration((Declaration) `<Relation relation>`, _, _) = convertRelation(relation);

public Declaration convertRelation((Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertRelation((Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});
