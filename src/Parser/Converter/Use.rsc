module Parser::Converter::Use

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), convertUseAlias(as));
    
public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseAlias as>;`)
    = use("<target>", "<artifactType>", internalUse(), convertUseAlias(as));
    
public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), "<target>");

public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType>;`)
    = use("<target>", "<artifactType>", internalUse(), "<target>");
    
private UseSource convertUseSource((UseSource) `from <Name src>`) = externalUse("<src>");

private str convertUseAlias((UseAlias) `as <ArtifactName as>`) = "<as>";
