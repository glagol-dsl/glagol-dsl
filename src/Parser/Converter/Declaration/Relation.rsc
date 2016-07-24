module Parser::Converter::Declaration::Relation

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::RelationDir;
import Parser::Converter::AccessProperty;

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});
