module Parser::Converter::Module

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::ModuleNamespace;

public Declaration buildAST((Module) `namespace <Namespace n>;<Import* imports><Artifact artifact>`) 
    = \module(convertModuleNamespace(n), [convertImport(\import) | \import <- imports], convertArtifact(artifact));
