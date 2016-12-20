@doc="This is automatically generated file. Do not edit"
module Parser::Converter
import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import String;
import List;
import Set;
import Exceptions::ParserExceptions;



public Declaration buildAST((Module) `namespace <Namespace n>;<Import* imports><Artifact artifact>`) 
    = \module(convertModuleNamespace(n), [convertImport(\import) | \import <- imports], convertArtifact(artifact));


public Expression convertParameterDefaultVal((AssignDefaultValue) `=<DefaultValue defaultValue>`, Type onType) {

    Expression defaultValue = convertExpression(defaultValue);
    
    if (defaultValue == get(selfie())) {
        defaultValue = get(onType);
    }

    return defaultValue;
}
    


public Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations]);

public Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertArtifact((Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`)
    = repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations]);

public Declaration convertArtifact((Artifact) `<Annotation* annotations> repository for <ArtifactName name> {<Declaration* declarations>}`)
    = repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertArtifact((Artifact) `value <ArtifactName name> {<Declaration* declarations>}`)
    = valueObject("<name>", [convertDeclaration(d, "<name>", "value") | d <- declarations]);
    
public Declaration convertArtifact((Artifact) `<Annotation* annotations> value <ArtifactName name> {<Declaration* declarations>}`) 
    = valueObject("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ];
    
public Declaration convertArtifact((Artifact) `util <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations]);
    
public Declaration convertArtifact((Artifact) `<Annotation* annotations> util <ArtifactName name> {<Declaration* declarations>}`) 
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ];
    
public Declaration convertArtifact((Artifact) `service <ArtifactName name> {<Declaration* declarations>}`)
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations]);
    
public Declaration convertArtifact((Artifact) `<Annotation* annotations> service <ArtifactName name> {<Declaration* declarations>}`) 
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ];
    


public AssignOperator convertAssignOperator((AssignOperator) `/=`) = divisionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `*=`) = productAssign();
public AssignOperator convertAssignOperator((AssignOperator) `-=`) = subtractionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `=`) = defaultAssign();
public AssignOperator convertAssignOperator((AssignOperator) `+=`) = additionAssign();


public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))]);

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))]);

public Declaration convertMethod(
    (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))], convertWhen(when));

public Declaration convertMethod(
    (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))], convertWhen(when));
    
private Modifier convertModifier((Modifier) `public`) = \public();
private Modifier convertModifier((Modifier) `private`) = \private();

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _) = convertMethod(method);
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Method method>`, _, _) 
    = convertMethod(method)[
    	@annotations = convertAnnotations(annotations)
    ];



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
    
public Expression convertExpression((Expression) `<Expression lhs> % <Expression rhs>`) 
    = remainder(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp));

public Expression convertExpression((Expression) `<StringQuoted s>`)
    = string(convertStringQuoted(s));
    
public Expression convertExpression((Expression) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"));
    
public Expression convertExpression((Expression) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"));
    
public Expression convertExpression((Expression) `<Boolean b>`)
    = boolean(convertBoolean(b));
    
public Expression convertExpression((Expression) `[<{Expression ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `<MemberName varName>`)
    = variable("<varName>");
    
public Expression convertExpression((Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr));
    
public Expression convertExpression((Expression) `+<Expression expr>`) 
    = positive(convertExpression(expr));

public Expression convertExpression((Expression) `this`) = this();

public Expression convertExpression((DefaultValue) `<StringQuoted s>`)
    = string(convertStringQuoted(s));
    
public Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"));
    
public Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"));
    
public Expression convertExpression((DefaultValue) `<Boolean b>`)
    = boolean(convertBoolean(b));
    
public Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = \list([convertExpression(i) | i <- items]);
    
public Expression convertExpression((DefaultValue) `get <InstanceType t>`)
    = get(convertInstanceType(t));
    
public Expression convertExpression((DefaultValue) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args]);
    
public Type convertInstanceType((InstanceType) `<Type t>`) = convertType(t);
public Type convertInstanceType((InstanceType) `selfie`) = selfie();
    
public Expression convertExpression((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args]);
    
public Expression convertExpression((Expression) `get <Type t>`)
    = get(convertType(t));
    
public Expression convertExpression((Expression) `<MemberName method>(<{Expression ","}* args>)`) 
    = invoke("<method>", [convertExpression(arg) | arg <- args]);
    
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
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `get <Type t>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;


public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;


public Declaration convertProperty((Property) `<Type prop><MemberName name>;`) 
    = property(convertType(prop), "<name>", {});

public Declaration convertProperty((Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) 
    = property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)));
    
public Declaration convertProperty((Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertProperty((Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)));
    
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Property prop>`, _, _) 
    = convertProperty(prop)[
    	@annotations = convertAnnotations(annotations)
    ];
    
public Declaration convertDeclaration((Declaration) `<Property prop>`, _, _) = convertProperty(prop);


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

public Statement convertStmt((Statement) `return;`) = \return(emptyExpr());
public Statement convertStmt((Statement) `return <Expression expr>;`) = \return(convertExpression(expr));

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


public list[Annotation] convertAnnotations(annotations) = [convertAnnotation(a) | a <- annotations];

public Annotation convertAnnotation((Annotation) `@<Identifier id>`) = annotation("<id>", []);

public Annotation convertAnnotation((Annotation) `@<Identifier id><AnnotationArgs args>`)
    = annotation("<id>", convertAnnotationArgs(args));

public Annotation convertAnnotation((Annotation) `@<Identifier id>=<AnnotationArg arg>`)
    = annotation("<id>", [convertAnnotationArg(arg)]);

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


public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Relation relation>`, _, _) 
    = convertRelation(relation)[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertDeclaration((Declaration) `<Relation relation>`, _, _) = convertRelation(relation);

public Declaration convertRelation((Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertRelation((Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});


public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty((AccessProperty) `get`) = read();
public AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();
public AccessProperty convertAccessProperty((AccessProperty) `add`) = add();
public AccessProperty convertAccessProperty((AccessProperty) `clear`) = clear();
public AccessProperty convertAccessProperty((AccessProperty) `reset`) = clear();


public str convertStringQuoted(string) = substring("<string>", 1, size("<string>") - 1);


public Type convertType((Type) `int`) = integer();
public Type convertType((Type) `float`) = float();
public Type convertType((Type) `bool`) = boolean();
public Type convertType((Type) `boolean`) = boolean();
public Type convertType((Type) `void`) = voidValue();
public Type convertType((Type) `string`) = string();
public Type convertType((Type) `repository\<<ArtifactName name>\>`) = repositoryType("<name>");
public Type convertType((Type) `<Type t>[]`) = typedList(convertType(t));
public Type convertType((Type) `{<Type key>,<Type v>}`) = typedMap(convertType(key), convertType(v));
public Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");


public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);


public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as));
    
public Declaration convertImport((Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>");

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";


public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);
}
    
public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
}

public Declaration convertConstructor(
    (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>);`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], []);
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, _) = convertConstructor(construct, artifactName);
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, _) 
    = convertConstructor(construct, artifactName)[
    	@annotations = convertAnnotations(annotations)
    ];


public Declaration convertParameter((AbstractParameter) `<Parameter p>`) = convertParameter(p);
public Declaration convertParameter((AbstractParameter) `<Annotation+ annotations><Parameter p>`) 
    = convertParameter(p)[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType)));


public Expression convertAssignable((Assignable) `<MemberName name>`) = variable("<name>");
public Expression convertAssignable((Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key));
public Expression convertAssignable((Assignable) `<Expression prev>.<MemberName field>`) 
    = fieldAccess(convertExpression(prev), "<field>");
