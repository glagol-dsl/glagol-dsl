module Parser::Converter::Declaration::Inject

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Exceptions::ParserExceptions;

public Declaration convertDeclaration((Declaration) `inject <ArtifactName artifact>as<MemberName as>;`, _, str artifactType) {
    
    if (artifactType != "repository") {
        throw IllegalMember("Injection is not allowed in \"<artifactType>\"");
    }
    
    return inject("<artifact>", "<as>");   
}
