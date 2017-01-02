module Parser::Converter::Declaration::Relation

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::RelationDir;
import Parser::Converter::AccessProperty;

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Relation relation>`, _, _) 
    = convertRelation(relation)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];

public Declaration convertDeclaration(a: (Declaration) `<Relation relation>`, _, _) = convertRelation(relation);

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties))[@src=a@\loc];

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {})[@src=a@\loc];
