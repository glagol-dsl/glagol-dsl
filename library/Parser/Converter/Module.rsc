module Parser::Converter::Module

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;
import Parser::Env;

public Declaration buildAST(a: (Module) `namespace <Namespace n><Import* imports><AnnotatedArtifact annotatedArtifact>`) {
	list[Declaration] convertedImports = [convertImport(\import) | \import <- imports];
	Declaration ns = convertModuleNamespace(n);
    return \module(ns, convertedImports, convertAnnotatedArtifact(annotatedArtifact, newParseEnv(convertedImports, ns)))[@src=a@\loc];
}
