module Syntax::Abstract::AST

data Declaration 
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | use(str target, str \type, UseSource source, str as)
    | entity(str name)
    | entity(str name, set[Annotation] annotations)
    ;
    
data UseSource
    = externalUse(str \module)
    | internalUse()
    ;

data Annotation
    = annotation(Annotation kind)
    | annotation(Annotation kind, Annotation \data)
    | table(str name)
    | field()
    | index(str name)
    | options(map[str key, str \value] options)
    | fields(list[str] fields)
    ;
