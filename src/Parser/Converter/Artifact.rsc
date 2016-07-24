module Parser::Converter::Artifact

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Declaration::Value;
import Parser::Converter::Declaration::Constructor;
import Parser::Converter::Declaration::Relation;
import Parser::Converter::Declaration::Method;
import Parser::Converter::Annotation;

public Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", {convertDeclaration(d, "<name>") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, entity("<name>", {convertDeclaration(d, "<name>") | d <- declarations}));

public Declaration convertArtifact((Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`)
    = repository("<name>", {convertDeclaration(d, "<name>") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> repository for <ArtifactName name> {<Declaration* declarations>}`)
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, repository("<name>", {convertDeclaration(d, "<name>") | d <- declarations}));
