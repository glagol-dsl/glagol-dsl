module Parser::Converter::Declaration::Inject

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Exceptions::ParserExceptions;

private list[str] allowedArtifactTypes = ["repository", "util"];

public Declaration convertDeclaration((Declaration) `inject <ArtifactName artifact>as<MemberName as>;`, _, str artifactType) {
    
    if (artifactType notin allowedArtifactTypes) {
        throw IllegalMember("Injection is not allowed in \"<artifactType>\"");
    }
    
    return inject("<artifact>", "<as>");   
}

public Declaration convertDeclaration((Declaration) `inject <AssocArtifact assocArtifact>as<MemberName as>;`, _, str artifactType) {
    
    if (artifactType notin allowedArtifactTypes) {
        throw IllegalMember("Injection is not allowed in \"<artifactType>\"");
    }
    
    return inject(convertAssocArtifact(assocArtifact), "<as>");   
}

public AssocArtifact convertAssocArtifact((AssocArtifact) `repository\<<ArtifactName artifact>\>`)
    = assocRepository("<artifact>");
