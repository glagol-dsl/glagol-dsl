module Parser::Converter::Module

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;

public Declaration buildAST((Module) `namespace <Namespace n><Import* imports><Artifact artifact>`) {
	list[Declaration] convertedImports = [convertImport(\import) | \import <- imports];
    return \module(convertModuleNamespace(n), convertedImports, convertArtifact(artifact, convertedImports));
}