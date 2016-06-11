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

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource? src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", internalUse(), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias? as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), "<target>");

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource? src> <UseAlias? as>;`)
    = use("<target>", "<artifactType>", internalUse(), "<target>");
    
private UseSource convertUseSource((UseSource) `from <Name src>`) = externalUse("<src>");

private str convertUseAlias((UseAlias) `as <ArtifactName as>`) = "<as>";
