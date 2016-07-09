module Syntax::Abstract::AST

data Declaration 
    = \module(str name, set[Declaration] imports)
    | \module(str name, set[Declaration] imports, Declaration artifact)
    | use(str target, str \type, UseSource source, str as)
    | annotated(set[Annotation] annotations, Declaration declaration)
    | entity(str name, set[Declaration] declarations)
    | \value(Type \valueType, str name, set[AccessProperty] valueProperties)
    | relation(RelationDir l, RelationDir r, str name, str as, set[AccessProperty] valueProperties)
    | constructor(list[Declaration] params)
    | param(Type paramType, str name)
    | param(Type paramType, str name, Expression defaultValue)
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
    = annotation(str annotationName, list[Annotation] arguments)
    | annotationMap(map[str key, Annotation \value] \map)
    | annotationVal(Annotation \value)
    | annotationVal(list[Annotation] listValue)
    | annotationVal(str strValue)
    | annotationVal(bool boolValue)
    | annotationVal(int intValue)
    | annotationVal(real floatValue)
    | annotationVal(Type \typeValue)
    | annotationValPrimary()
    ;

data Expression
    = intLiteral(int intValue)
    | floatLiteral(real floatValue)
    | strLiteral(str strValue)
    | boolLiteral(bool boolValue)
    | array(list[Expression] values)
    ;

data Type
    = integer()
    | float()
    | string()
    | voidValue()
    | boolean()
    | typedArray(Type \type)
    | artifactType(str name)
    ;
    
data AccessProperty
    = get()
    | \set()
    | add()
    | clear()
    ;
