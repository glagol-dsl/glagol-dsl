module Parser::ParseAST

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
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
    
private Annotation convertAnnotation((Annotation) `@table(name: <Name name>)`) 
    = annotation(table("<name>"));

private Annotation convertAnnotation((Annotation) `@index(<Name name>, {<{Name ","}* fs>})`) 
    = annotation(index("<name>"), fields(["<f>" | f <- fs]));

private bool convertBoolean((Boolean) `true`) = true;
private bool convertBoolean((Boolean) `false`) = false;

private tuple[str key,str \value] convertAnnotationPair((AnnotationPair) `<AnnotationKey key> : <AnnotationValue v>`) 
    = <"<key>", "<v>">;

private Annotation convertAnnotation((Annotation) `@field(<{AnnotationPair ","}+ ps>)`)
    = annotation(field(), options(( key:\value | p <- ps, <str key, str \value> := convertAnnotationPair(p) )));

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
private Type convertType((Type) `bool`) = \bool();
private Type convertType((Type) `boolean`) = \bool();
private Type convertType((Type) `void`) = voidValue();
private Type convertType((Type) `string`) = string();
private Type convertType((Type) `<Type \type>[]`) = typedArray(convertType(\type));
private Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");
    
private set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

private AccessProperty convertAccessProperty((AccessProperty) `get`) = get();
private AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();

