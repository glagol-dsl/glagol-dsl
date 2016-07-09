module Parser::ParseAST

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import String;
import IO;

public Declaration parseModule(str code) = buildAST(parseCode(code));
public Declaration parseModule(loc file) = buildAST(parseFile(file));

public Declaration buildAST(start[Test] t) = buildAST(t.top);

public Declaration buildAST((Module) `module <Name name>;<Use* uses>`) = \module("<name>", {convertUse(use) | use <- uses});

public Declaration buildAST((Module) `module <Name name>;<Use* uses><Artifact artifact>`) 
    = \module("<name>", {convertUse(use) | use <- uses}, convertArtifact(artifact));

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseAlias as>;`)
    = use("<target>", "<artifactType>", internalUse(), convertUseAlias(as));
    
private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), "<target>");

private Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType>;`)
    = use("<target>", "<artifactType>", internalUse(), "<target>");
    
private UseSource convertUseSource((UseSource) `from <Name src>`) = externalUse("<src>");

private str convertUseAlias((UseAlias) `as <ArtifactName as>`) = "<as>";
 
private Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", {convertDeclaration(d) | d <- declarations});

private Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, entity("<name>", {convertDeclaration(d) | d <- declarations}));
    
private Annotation convertAnnotation((Annotation) `@<Identifier id>`) = annotation("<id>", []);

private Annotation convertAnnotation((Annotation) `@<Identifier id><AnnotationArgs args>`)
    = annotation("<id>", convertAnnotationArgs(args));

private list[Annotation] convertAnnotationArgs((AnnotationArgs) `(<{AnnotationArg ","}+ args>)`) 
    = [convertAnnotationArg(arg) | arg <- args];

private Annotation convertAnnotationArg((AnnotationArg) `<StringQuoted stringVal>`) 
    = annotationVal(convertStringQuoted(stringVal));
    
private Annotation convertAnnotationArg((AnnotationArg) `<Boolean boolean>`) 
    = annotationVal(convertBoolean(boolean));
    
private Annotation convertAnnotationArg((AnnotationArg) `<DecimalIntegerLiteral number>`) 
    = annotationVal(toInt("<number>"));

private Annotation convertAnnotationArg((AnnotationArg) `<DeciFloatNumeral number>`) 
    = annotationVal(toReal("<number>"));

private Annotation convertAnnotationArg((AnnotationArg) `[<{AnnotationArg ","}+ listVal>]`)
    = annotationVal([convertAnnotationArg(arg) | arg <- listVal]);

private Annotation convertAnnotationArg((AnnotationArg) `{<{AnnotationPair ","}+ mapVal>}`)
    = annotationMap(( key:\value | p <- mapVal, <str key, Annotation \value> := convertAnnotationPair(p) ));

private Annotation convertAnnotationValue((AnnotationValue) `<AnnotationArg val>`) = convertAnnotationArg(val);
private Annotation convertAnnotationValue((AnnotationValue) `primary`) = annotationValPrimary();
private Annotation convertAnnotationValue((AnnotationValue) `<Type t>`) = annotationVal(convertType(t));

private tuple[str key, Annotation \value] convertAnnotationPair((AnnotationPair) `<AnnotationKey key> : <AnnotationValue v>`) 
    = <"<key>", convertAnnotationValue(v)>;

private Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name>;`) 
    = \value(convertType(valueType), "<name>");
    
private Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name><AccessProperties accessProperties>;`) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
private Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name>;`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
private Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name><AccessProperties accessProperties>;`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));
    
private Type convertType((Type) `int`) = integer();
private Type convertType((Type) `float`) = float();
private Type convertType((Type) `bool`) = boolean();
private Type convertType((Type) `boolean`) = boolean();
private Type convertType((Type) `void`) = voidValue();
private Type convertType((Type) `string`) = string();
private Type convertType((Type) `<Type \type>[]`) = typedArray(convertType(\type));
private Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");
    
private set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

private AccessProperty convertAccessProperty((AccessProperty) `get`) = get();
private AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();
private AccessProperty convertAccessProperty((AccessProperty) `add`) = add();
private AccessProperty convertAccessProperty((AccessProperty) `clear`) = clear();
private AccessProperty convertAccessProperty((AccessProperty) `reset`) = clear();

private RelationDir convertRelationDir((RelationDir) `one`) = \one();
private RelationDir convertRelationDir((RelationDir) `many`) = many();

private Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

private Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});

private Declaration convertDeclaration((Declaration) `construct (<{Parameter ","}* parameters>) { }`) 
    = constructor([convertParameter(p) | p <- parameters]);

private Declaration convertDeclaration((Declaration) `construct (<{Parameter ","}* parameters>);`) 
    = constructor([convertParameter(p) | p <- parameters]);

private Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

private Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <ParameterDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue));

private Expression convertParameterDefaultVal((ParameterDefaultValue) `=<DefaultValue defaultValue>`)
    = convertExpression(defaultValue);
    
private Expression convertExpression((DefaultValue) `"<StringCharacter* string>"`)
    = strLiteral("<string>");
    
private Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
private Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
private Expression convertExpression((DefaultValue) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
private Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = array([convertExpression(i) | i <- items]);
    
private str convertStringQuoted((StringQuoted) `"<StringCharacter* string>"`) = "<string>";

private bool convertBoolean((Boolean) `true`) = true;
private bool convertBoolean((Boolean) `false`) = false;
