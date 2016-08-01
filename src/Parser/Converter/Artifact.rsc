module Parser::Converter::Artifact

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Declaration::Value;
import Parser::Converter::Declaration::Constructor;
import Parser::Converter::Declaration::Relation;
import Parser::Converter::Declaration::Method;
import Parser::Converter::Annotation;

public Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", {convertDeclaration(d, "<name>", "entity") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, entity("<name>", {convertDeclaration(d, "<name>", "entity") | d <- declarations}));

public Declaration convertArtifact((Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`)
    = repository("<name>", {convertDeclaration(d, "<name>", "repository") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> repository for <ArtifactName name> {<Declaration* declarations>}`)
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, repository("<name>", {convertDeclaration(d, "<name>", "repository") | d <- declarations}));

public Declaration convertArtifact((Artifact) `value <ArtifactName name> {<Declaration* declarations>}`)
    = valueObject("<name>", {convertDeclaration(d, "<name>", "value") | d <- declarations});
    
public Declaration convertArtifact((Artifact) `util <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", {convertDeclaration(d, "<name>", "util") | d <- declarations});
    
public Declaration convertArtifact((Artifact) `service <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", {convertDeclaration(d, "<name>", "util") | d <- declarations});
    
