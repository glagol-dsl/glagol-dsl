module Parser::Converter::Annotation

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import String;
import Parser::Converter::Boolean;
import Parser::Converter::Type;
import Parser::Converter::QuotedString;

public list[Annotation] convertAnnotations(annotations, ParseEnv env) = [convertAnnotation(a, env) | a <- annotations];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id>`, ParseEnv env) = annotation("<id>", [])[@src=a@\loc];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id><AnnotationArgs args>`, ParseEnv env)
    = annotation("<id>", convertAnnotationArgs(args, env))[@src=a@\loc];

public Annotation convertAnnotation(a: (Annotation) `@<Identifier id>=<AnnotationArg arg>`, ParseEnv env)
    = annotation("<id>", [convertAnnotationArg(arg, env)])[@src=a@\loc];

private list[Annotation] convertAnnotationArgs(a: (AnnotationArgs) `(<{AnnotationArg ","}+ args>)`, ParseEnv env)
    = [convertAnnotationArg(arg, env) | arg <- args];

private Annotation convertAnnotationArg(a: (AnnotationArg) `<StringQuoted stringVal>`, ParseEnv env)
    = annotationVal(convertStringQuoted(stringVal))[@src=a@\loc];
    
private Annotation convertAnnotationArg(a: (AnnotationArg) `<Boolean boolean>`, ParseEnv env)
    = annotationVal(convertBoolean(boolean))[@src=a@\loc];
    
private Annotation convertAnnotationArg(a: (AnnotationArg) `<DecimalIntegerLiteral number>`, ParseEnv env)
    = annotationVal(toInt("<number>"))[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `<DeciFloatNumeral number>`, ParseEnv env)
    = annotationVal(toReal("<number>"))[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `[<{AnnotationArg ","}+ listVal>]`, ParseEnv env)
    = annotationVal([convertAnnotationArg(arg, env) | arg <- listVal])[@src=a@\loc];

private Annotation convertAnnotationArg(a: (AnnotationArg) `{<{AnnotationPair ","}+ mapVal>}`, ParseEnv env)
    = annotationMap(( key:\value | p <- mapVal, <str key, Annotation \value> := convertAnnotationPair(p, env) ))[@src=a@\loc];

private Annotation convertAnnotationValue((AnnotationValue) `<AnnotationArg val>`, ParseEnv env) = convertAnnotationArg(val, env);
private Annotation convertAnnotationValue(a: (AnnotationValue) `primary`, ParseEnv env) = annotationValPrimary()[@src=a@\loc];
private Annotation convertAnnotationValue(a: (AnnotationValue) `<Type t>`, ParseEnv env) = annotationVal(convertType(t, env))[@src=a@\loc];

private tuple[str key, Annotation \value] convertAnnotationPair((AnnotationPair) `<AnnotationKey key> : <AnnotationValue v>`, ParseEnv env)
    = <"<key>", convertAnnotationValue(v, env)>;
