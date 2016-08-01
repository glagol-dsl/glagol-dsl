@doc="This is automatically generated file. Do not edit"
module Parser::Converter
import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import String;
import Exceptions::ParserExceptions;



public Declaration buildAST((Module) `module <Namespace n>;<Import* imports>`) 
    = \module(convertModuleNamespace(n), {convertImport(\import) | \import <- imports});

public Declaration buildAST((Module) `module <Namespace n>;<Import* imports><Artifact artifact>`) 
    = \module(convertModuleNamespace(n), {convertImport(\import) | \import <- imports}, convertArtifact(artifact));


public Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", {convertDeclaration(d, "<name>", "entity") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, entity("<name>", {convertDeclaration(d, "<name>", "entity") | d <- declarations}));

public Declaration convertArtifact((Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`)
    = repository("<name>", {convertDeclaration(d, "<name>", "repository") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> repository for <ArtifactName name> {<Declaration* declarations>}`)
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, repository("<name>", {convertDeclaration(d, "<name>", "repository") | d <- declarations}));

public Declaration convertArtifact((Artifact) `value <ArtifactName name> {<Declaration* declarations>}`)
    = valueObject("<name>", {convertDeclaration(d, "<name>", "value") | d <- declarations});
    
public Declaration convertArtifact((Artifact) `util <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", {convertDeclaration(d, "<name>", "util") | d <- declarations});
    
public Declaration convertArtifact((Artifact) `service <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", {convertDeclaration(d, "<name>", "util") | d <- declarations});
    


public AssignOperator convertAssignOperator((AssignOperator) `/=`) = divisionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `*=`) = productAssign();
public AssignOperator convertAssignOperator((AssignOperator) `-=`) = subtractionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `=`) = defaultAssign();
public AssignOperator convertAssignOperator((AssignOperator) `+=`) = additionAssign();


public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, _, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, _, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> } <When when>;`, _, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> } <When when>;`, _, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr>;`, _, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr>;`, _, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr><When when>;`, _, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr><When when>;`, _, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));
    
private Modifier convertModifier((Modifier) `public`) = \public();
private Modifier convertModifier((Modifier) `private`) = \private();
    


public Expression convertExpression((Expression) `(<Expression expr>)`) = \bracket(convertExpression(expr));

public Expression convertExpression((Expression) `<Expression lhs> * <Expression rhs>`) 
    = product(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> / <Expression rhs>`) 
    = division(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> + <Expression rhs>`) 
    = addition(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> - <Expression rhs>`) 
    = subtraction(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \>= <Expression rhs>`) 
    = greaterThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \<= <Expression rhs>`) 
    = lessThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \< <Expression rhs>`) 
    = lessThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \> <Expression rhs>`) 
    = greaterThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> == <Expression rhs>`) 
    = equals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> != <Expression rhs>`) 
    = nonEquals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> && <Expression rhs>`) 
    = and(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> || <Expression rhs>`) 
    = or(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp));

public Expression convertExpression((Expression) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((Expression) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((Expression) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((Expression) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((Expression) `[<{Expression ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `<MemberName varName>`)
    = variable("<varName>");
    
public Expression convertExpression((Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr));

public Expression convertExpression((Expression) `this`) = this();

public Expression convertExpression((DefaultValue) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((DefaultValue) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `new <ArtifactName name>`) = new("<name>", []);
public Expression convertExpression((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args]);
    
public Expression convertExpression((Expression) `<MemberName method>(<{Expression ","}* args>)`) 
    = invoke("<method>", [convertExpression(arg) | arg <- args]);

public Expression convertExpression((Expression) `<AssocArtifact a>`) 
    = assocArtifact(convertAssocArtifact(a));
    
public Expression convertExpression((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator");
    }
    
    return invoke(convertExpression(prev), "<method>", [convertExpression(arg) | arg <- args]);
}

public Expression convertExpression((Expression) `<Expression prev>.<MemberName field>`) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator");
    }

    return fieldAccess(convertExpression(prev), "<field>");
}

public Expression convertExpression((Expression) `{<{MapPair ","}* pairs>}`) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p) )
);

private tuple[Expression key, Expression \value] convertMapPair((MapPair) `<Expression key>:<Expression v>`)
    = <convertExpression(key), convertExpression(v)>;

private bool isValidForAccessChain((Expression) `<MemberName varName>`) = true;
private bool isValidForAccessChain((Expression) `this`) = true;
private bool isValidForAccessChain((Expression) `<AssocArtifact assocArtifact>`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;


public Declaration convertDeclaration((Declaration) `<Type valueType><MemberName name>;`, _, _) 
    = \value(convertType(valueType), "<name>");
    
public Declaration convertDeclaration((Declaration) `<Type valueType><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type valueType><MemberName name>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type valueType><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));


private list[str] allowedArtifactTypes = ["repository", "util"];

public Declaration convertDeclaration((Declaration) `inject <ArtifactName artifact>as<MemberName as>;`, _, str artifactType) {
    
    if (artifactType notin allowedArtifactTypes) {
        throw IllegalMember("Injection is not allowed in \"<artifactType>\"");
    }
    
    return inject("<artifact>", "<as>");   
}

public Declaration convertDeclaration((Declaration) `inject <AssocArtifact assocArtifact>as<MemberName as>;`, _, str artifactType) {
    
    if (artifactType notin allowedArtifactTypes) {
        throw IllegalMember("Injection is not allowed in \"<artifactType>\"");
    }
    
    return inject(convertAssocArtifact(assocArtifact), "<as>");   
}

public AssocArtifact convertAssocArtifact((AssocArtifact) `repository\<<ArtifactName artifact>\>`)
    = assocRepository("<artifact>");


public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;


public Declaration convertModuleNamespace((Namespace) `<Name name>`) = namespace("<name>");
public Declaration convertModuleNamespace((Namespace) `<Name name>::<Namespace n>`) 
    = namespace("<name>", convertModuleNamespace(n));


public Statement convertStmt((Statement) `<Expression expr>;`) = expression(convertExpression(expr));
public Statement convertStmt((Statement) `;`) = emptyStmt();
public Statement convertStmt((Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts]);

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then));

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(e));

public Statement convertStmt((Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val));

public Statement convertStmt((Statement) `return;`) = \return(expression(emptyStmt()));
public Statement convertStmt((Statement) `return <Expression expr>;`) = \return(expression(convertExpression(expr)));

public Statement convertStmt((Statement) `break ;`) = \break();
public Statement convertStmt((Statement) `break<Integer level>;`) = \break(toInt("<level>"));

public Statement convertStmt((Statement) `continue ;`) = \continue();
public Statement convertStmt((Statement) `continue<Integer level>;`) = \continue(toInt("<level>"));

public Statement convertStmt((Statement) `<Type t> <MemberName varName>;`) = declare(convertType(t), variable("<varName>"));
public Statement convertStmt((Statement) `<Type t> <MemberName varName>=<Statement defValue>`) 
    = declare(convertType(t), variable("<varName>"), convertStmt(defValue));

public Statement convertStmt((Statement) `for (<Expression l>as<MemberName var>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>"), convertStmt(body));
    
public Statement convertStmt((Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>"), convertStmt(body), [convertExpression(cond) | cond <- conds]);


public Annotation convertAnnotation((Annotation) `@<Identifier id>`) = annotation("<id>", []);

public Annotation convertAnnotation((Annotation) `@<Identifier id><AnnotationArgs args>`)
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


public RelationDir convertRelationDir((RelationDir) `one`) = \one();
public RelationDir convertRelationDir((RelationDir) `many`) = many();


public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});


public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty((AccessProperty) `get`) = get();
public AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();
public AccessProperty convertAccessProperty((AccessProperty) `add`) = add();
public AccessProperty convertAccessProperty((AccessProperty) `clear`) = clear();
public AccessProperty convertAccessProperty((AccessProperty) `reset`) = clear();


public str convertStringQuoted((StringQuoted) `"<StringCharacter* string>"`) = "<string>";


public Type convertType((Type) `int`) = integer();
public Type convertType((Type) `float`) = float();
public Type convertType((Type) `bool`) = boolean();
public Type convertType((Type) `boolean`) = boolean();
public Type convertType((Type) `void`) = voidValue();
public Type convertType((Type) `string`) = string();
public Type convertType((Type) `<Type t>[]`) = typedList(convertType(t));
public Type convertType((Type) `{<Type key>,<Type v>}`) = typedMap(convertType(key), convertType(v));
public Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");


public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);


public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as));
    
public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>");

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";


public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName, _) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);
}
    
public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName, _)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
}

public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>);`, 
    str artifactName, _) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], []);
}


public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <ParameterDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue));

public Expression convertParameterDefaultVal((ParameterDefaultValue) `=<DefaultValue defaultValue>`)
    = convertExpression(defaultValue);
    


public Expression convertAssignable((Assignable) `<MemberName name>`) = variable("<name>");
public Expression convertAssignable((Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key));
public Expression convertAssignable((Assignable) `<Expression prev>.<MemberName field>`) 
    = fieldAccess(convertExpression(prev), "<field>");
