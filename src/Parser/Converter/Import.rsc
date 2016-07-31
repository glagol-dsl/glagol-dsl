module Parser::Converter::Import

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;

public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as));
    
public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>");

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";
