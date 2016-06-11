module Parser::ParseAST

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import IO;

public Declaration parseModule(str code) = buildAST(parseCode(code));
public Declaration parseModule(loc file) = buildAST(parseFile(file));

public Declaration buildAST(start[Test] t) = buildAST(t.top);

public Declaration buildAST((Module) `module <Name name>;<Use* uses>`) = \module("<name>", {convertUse(use) | use <- uses});

public Declaration buildAST((Module) `module <Name name>;<Use* uses><Artifact artifact>`) 
    = \module("<name>", {convertUse(use) | use <- uses}, convertArtifact(artifact));

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseAlias as>;`)
    = use("<target>", "<artifactType>", internalUse(), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), "<target>");

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType>;`)
    = use("<target>", "<artifactType>", internalUse(), "<target>");
    
private UseSource convertUseSource((UseSource) `from <Name src>`) = externalUse("<src>");

private str convertUseAlias((UseAlias) `as <ArtifactName as>`) = "<as>";
 
private Declaration convertArtifact((Artifact) `entity <ArtifactName name> { }`) = entity("<name>");

private Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> { }`) 
    = entity("<name>", {convertAnnotation(annotation) | annotation <- annotations});
    
private Annotation convertAnnotation((Annotation) `@table(name: <Name name>)`) 
    = annotation(table("<name>"));

private Annotation convertAnnotation((Annotation) `@index(<Name name>, {<{Name ","}* fs>})`) 
    = annotation(index("<name>"), fields(["<f>" | f <- fs]));
