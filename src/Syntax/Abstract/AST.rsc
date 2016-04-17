module Syntax::Abstract::AST

data Declaration = \module(str name, set[Declaration] imports)
                 | \module(str name, set[Declaration] imports, Declaration artifact)
                 | importInternal(str target, str \artifactType)
                 | importInternal(str target, str \artifactType, str \alias)
                 | importExternal(str target, str \artifactType, str \module)
                 | importExternal(str target, str \artifactType, str \module, str \alias)
                 // artifacts
                 | entity(set[Declaration] annotations, str name, set[Declaration] declarations)
                 | entity(str name, set[Declaration] declarations)
                 | entityValue(set[Declaration] annotations, str \type, str name)
                 | entityValue(set[Declaration] annotations, str \type, str name, set[str] valueProperties)
                 | relation(str local, str foreign, str entity, str \alias)
                 | relation(str local, str foreign, str entity, str \alias, set[str] relProperties)
                 // annotations
                 | annoTable(str name)
                 | annoField(set[Expression] pairs)
                 | index(str name, set[str] columns)
                 ;

data Expression = annoPair(str key, str \value);

