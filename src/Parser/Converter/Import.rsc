module Parser::Converter::Import

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;

public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as))[@src=a@\loc];
    
public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>")[@src=a@\loc];

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";
