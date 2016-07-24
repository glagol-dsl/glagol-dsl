module Parser::Converter::Import

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public Declaration convertImport((Import) `import <ImportNamespace* namespace><ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", [convertImportNamespace(n) | n <- namespace], convertImportAlias(as));
    
public Declaration convertImport((Import) `import <ImportNamespace* namespace><ArtifactName artifact>;`)
    = \import("<artifact>", [convertImportNamespace(n) | n <- namespace], "<artifact>");

private str convertImportNamespace((ImportNamespace) `<ArtifactName part>::`) = "<part>";
private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";
