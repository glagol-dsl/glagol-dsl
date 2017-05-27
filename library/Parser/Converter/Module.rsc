module Parser::Converter::Module

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;
import Parser::Env;

public Declaration buildAST(a: (Module) `namespace <Namespace n><Import* imports><AnnotatedArtifact annotatedArtifact>`) {
	list[Declaration] convertedImports = [convertImport(\import) | \import <- imports];
    return \module(convertModuleNamespace(n), convertedImports, convertAnnotatedArtifact(annotatedArtifact, newParseEnv(convertedImports)))[@src=a@\loc];
}
