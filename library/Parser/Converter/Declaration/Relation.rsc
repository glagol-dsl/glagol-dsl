module Parser::Converter::Declaration::Relation

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::RelationDir;
import Parser::Converter::AccessProperty;

// TODO enable only on entities
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Relation relation>`, _, str artifactType, ParseEnv env)
    = convertRelation(relation, artifactType)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertDeclaration(a: (Declaration) `<Relation relation>`, _, str artifactType, _) = convertRelation(relation, artifactType);

public Declaration convertRelation(a: _, at: /^(?!entity).*$/) {
	throw RelationNotAllowed("Relations only allowed on entities", a@\loc);
}

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties))[@src=a@\loc];

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {})[@src=a@\loc];
