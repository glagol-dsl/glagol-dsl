module Parser::Converter::Annotation

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::Type;
import Parser::Converter::QuotedString;

public list[Annotation] convertAnnotations(annotations) = [convertAnnotation(a) | a <- annotations];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id>`) = annotation("<id>", [])[@src=a@\loc];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id><AnnotationArgs args>`)
    = annotation("<id>", convertAnnotationArgs(args))[@src=a@\loc];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id>=<AnnotationArg arg>`)
    = annotation("<id>", [convertAnnotationArg(arg)])[@src=a@\loc];

private list[Annotation] convertAnnotationArgs(a: (AnnotationArgs) `(<{AnnotationArg ","}+ args>)`) 
    = [convertAnnotationArg(arg) | arg <- args];

private Annotation convertAnnotationArg(a: (AnnotationArg) `<StringQuoted stringVal>`) 
    = annotationVal(convertStringQuoted(stringVal))[@src=a@\loc];
    
private Annotation convertAnnotationArg(a: (AnnotationArg) `<Boolean boolean>`) 
    = annotationVal(convertBoolean(boolean))[@src=a@\loc];
    
private Annotation convertAnnotationArg(a: (AnnotationArg) `<DecimalIntegerLiteral number>`) 
    = annotationVal(toInt("<number>"))[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `<DeciFloatNumeral number>`) 
    = annotationVal(toReal("<number>"))[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `[<{AnnotationArg ","}+ listVal>]`)
    = annotationVal([convertAnnotationArg(arg) | arg <- listVal])[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `{<{AnnotationPair ","}+ mapVal>}`)
    = annotationMap(( key:\value | p <- mapVal, <str key, Annotation \value> := convertAnnotationPair(p) ))[@src=a@\loc];

private Annotation convertAnnotationValue((AnnotationValue) `<AnnotationArg val>`) = convertAnnotationArg(val);
private Annotation convertAnnotationValue(a: (AnnotationValue) `primary`) = annotationValPrimary()[@src=a@\loc];
private Annotation convertAnnotationValue(a: (AnnotationValue) `<Type t>`) = annotationVal(convertType(t))[@src=a@\loc];

private tuple[str key, Annotation \value] convertAnnotationPair((AnnotationPair) `<AnnotationKey key> : <AnnotationValue v>`) 
    = <"<key>", convertAnnotationValue(v)>;
