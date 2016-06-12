module Syntax::Abstract::AST

data Declaration 
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | use(str target, str \type, UseSource source, str as)
    | annotated(set[Annotation] annotations, Declaration declaration)
    | entity(str name, set[Declaration] declarations)
    | \value(Type \valueType, str name, set[AccessProperty] valueProperties)
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

data Type
    = integer()
    | float()
    | string()
    | voidValue()
    | \bool()
    | typedArray(Type \type)
    | artifactType(str name)
    ;
    
data AccessProperty
    = get()
    | \set()
    ;
