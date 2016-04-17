module Syntax::Abstract::AST

data Module = \module(str name, set[Import] imports)
            ;

data Import = importInternal(str target, str \artifactType)
            | importInternal(str target, str \artifactType, str \alias)
            | importExternal(str target, str \artifactType, str \module)
            | importExternal(str target, str \artifactType, str \module, str \alias)
            ;