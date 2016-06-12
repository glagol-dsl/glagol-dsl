module Syntax::Abstract::AST

data Declaration 
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | use(str target, str \type, UseSource source, str as)
    | annotated(set[Annotation] annotations, Declaration declaration)
    | entity(str name, set[Declaration] declarations)
    | \value(Type \valueType, str name, set[AccessProperty] valueProperties)
    | relation(RelationDir l, RelationDir r, str name, str as, set[AccessProperty] valueProperties)
    ;

data RelationDir
    = \one() 
    | many()
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
    | options(map[str key, Annotation \value] options)
    | fields(list[str] fields)
    | optionValue(str strValue)
    | optionValue(bool boolValue)
    | optionValue(int intValue)
    | optionValue(Type \typeValue)
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
    | add()
    | clear()
    ;
