@doc="This is automatically generated file. Do not edit"
module Parser::Converter
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import String;
import List;
import Set;
import Exceptions::ParserExceptions;



public Declaration buildAST(a: (Module) `namespace <Namespace n><Import* imports><AnnotatedArtifact annotatedArtifact>`) {
	list[Declaration] convertedImports = [convertImport(\import) | \import <- imports];
    return \module(convertModuleNamespace(n), convertedImports, convertAnnotatedArtifact(annotatedArtifact, convertedImports))[@src=a@\loc];
}


public Expression convertParameterDefaultVal(a: (AssignDefaultValue) `=<DefaultValue defaultValue>`, Type onType) {

    Expression defaultValue = convertExpression(defaultValue);
    
    if (defaultValue == get(selfie())) {
        defaultValue = get(onType);
    }

    return defaultValue[@src=a@\loc];
}
    


public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Artifact artifact>`, list[Declaration] imports) = 
	convertArtifact(artifact, imports);
    
public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Annotation* annotations><Artifact artifact>`, list[Declaration] imports) = 
	convertArtifact(artifact, imports)[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertArtifact(a: (Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations])[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) {
	if (!isImported("<name>", imports)) {
		throw EntityNotImported("Repository cannot attach to entity \'<name>\': entity not imported", a@\loc);
	}
	
    return repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations])[@src=a@\loc];
}

public Declaration convertArtifact(a: (Artifact) `value <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	valueObject("<name>", [convertDeclaration(d, "<name>", "value") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `util <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `service <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];

public ControllerType convertControllerType(c: (ControllerType) `json-api`) = jsonApi()[@src=c@\loc];
public ControllerType convertControllerType(c: (ControllerType) `rest`) = jsonApi()[@src=c@\loc];

public Route convertRoute(r: (RoutePart) `<Identifier part>`) = routePart("<part>")[@src=r@\loc];
public Route convertRoute(r: (RoutePart) `<RoutePlaceholder placeholder>`) = 
	routeVar(substring("<placeholder>", 1, size("<placeholder>")))[@src=r@\loc];

public str createControllerName(loc file) {
	str name = substring(file.file, 0, size(file.file) - size(file.extension) - 1);
	
	if (/^[A-Z][a-zA-Z]+?Controller$/ !:= name) {
		throw IllegalControllerName("Controller file name <name> does not follow the pattern `^[A-Z][a-zA-Z]+?Controller$`", file);
	}
	
	return name;
}

public Route convertRoute((Route) `/<{RoutePart "/"}* routes>`) = route([convertRoute(r) | r <- routes]);

public Declaration convertArtifact(a: (Artifact) `<ControllerType controllerType>controller<Route r>{<Declaration* declarations>}`, list[Declaration] imports) = 
	controller(
		createControllerName(a@\loc),
		convertControllerType(controllerType), 
		convertRoute(r), 
		[convertDeclaration(d, "", "controller") | d <- declarations]
	)[@src=a@\loc];


public AssignOperator convertAssignOperator(a: (AssignOperator) `/=`) = divisionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `*=`) = productAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `-=`) = subtractionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `=`) = defaultAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `+=`) = additionAssign()[@src=a@\loc];


public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], emptyExpr())[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], emptyExpr())[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], emptyExpr())[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], emptyExpr())[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(\public()[@src=a@\loc], convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], convertWhen(when))[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(convertExpression(expr))[@src=expr@\loc]], convertWhen(when))[@src=a@\loc];
    
private Modifier convertModifier(a: (Modifier) `public`) = \public()[@src=a@\loc];
private Modifier convertModifier(a: (Modifier) `private`) = \private()[@src=a@\loc];

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _) = convertMethod(method);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Method method>`, _, _) 
    = convertMethod(method)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];



public Expression convertExpression(a: (Expression) `(<Expression expr>)`) = \bracket(convertExpression(expr))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<Expression lhs> * <Expression rhs>`) 
    = product(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> / <Expression rhs>`) 
    = division(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> + <Expression rhs>`) 
    = addition(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> - <Expression rhs>`) 
    = subtraction(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \>= <Expression rhs>`) 
    = greaterThanOrEq(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \<= <Expression rhs>`) 
    = lessThanOrEq(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \< <Expression rhs>`) 
    = lessThan(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \> <Expression rhs>`) 
    = greaterThan(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> == <Expression rhs>`) 
    = equals(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> != <Expression rhs>`) 
    = nonEquals(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> && <Expression rhs>`) 
    = and(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> || <Expression rhs>`) 
    = or(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> % <Expression rhs>`) 
    = remainder(convertExpression(lhs), convertExpression(rhs))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<StringQuoted s>`)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Boolean b>`)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `[<{Expression ","}* items>]`)
    = \list([convertExpression(i) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName varName>`)
    = variable("<varName>")[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `+<Expression expr>`) 
    = positive(convertExpression(expr))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `this`) = this()[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `<StringQuoted s>`)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DecimalIntegerLiteral number>`)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DeciFloatNumeral number>`)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<Boolean b>`)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `[<{DefaultValue ","}* items>]`)
    = \list([convertExpression(i) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `get <InstanceType t>`)
    = get(convertInstanceType(t))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Type convertInstanceType(a: (InstanceType) `<Type t>`) = convertType(t)[@src=a@\loc];
public Type convertInstanceType(a: (InstanceType) `selfie`) = selfie()[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) 
    = new("<name>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `get <Type t>`)
    = get(convertType(t))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName method>(<{Expression ","}* args>)`) 
    = invoke("<method>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }
    
    return invoke(convertExpression(prev), "<method>", [convertExpression(arg) | arg <- args])[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName field>`) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }

    return fieldAccess(convertExpression(prev), "<field>")[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `{<{MapPair ","}* pairs>}`) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p) )
)[@src=a@\loc];

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


public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`)  = 
    property(convertType(prop), "<name>", {}, emptyExpr())[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop))
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) = 
    property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop))
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) = 
    property(convertType(prop), "<name>", convertAccessProperties(accessProperties), emptyExpr())[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop))
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) = 
    property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop))
    ];

public list[Annotation] buildPropDefaultAnnotations(Type t) = 
    [annotation("column", [annotationMap(("type": annotationVal(t)))])]
    when t in [integer(), string(), boolean(), float()];
    
public default list[Annotation] buildPropDefaultAnnotations(Type t) = [];

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _) {
    Declaration property = convertProperty(prop);

    list[Annotation] pAnnotations = property@annotations? ? property@annotations : [];

    for (an <- convertAnnotations(annotations)) {
        if (annotation(f: /column|field/, [*Annotation L, annotationMap(m), *Annotation R]) := an, 
            pAnnotations[0]? && pAnnotations[0].arguments? && pAnnotations[0].arguments[0]?) {
            pAnnotations[0].arguments[0].\map += m;
        } else {
            pAnnotations += an;
        }
    }

    return property[
        @annotations = pAnnotations
    ][@src=a@\loc];
}
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _) = convertProperty(prop);


public Declaration convertDeclaration(d: (Declaration) `<Action action>`, _, a: /^(?!controller).*$/) {
	throw ActionNotAllowed("Action declarations not allowed in artifact type \'<a>\'", d@\loc);
}

public Declaration convertDeclaration((Declaration) `<Action action>`, _, _) = convertAction(action);

public Declaration convertAction(a: (Action) `<MemberName name>{<Statement* body>}`) = 
	action("<name>", [], [convertStmt(stmt) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name>=<Expression expr>;`) = 
	action("<name>", [], [\return(convertExpression(expr))]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>{<Statement* body>}`) = 
	action("<name>", convertParameters(params), [convertStmt(stmt) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>=<Expression expr>;`) = 
	action("<name>", convertParameters(params), [\return(convertExpression(expr))]);


public Declaration convertModuleNamespace(a: (Namespace) `<Name name>`) = namespace("<name>")[@src=a@\loc];
public Declaration convertModuleNamespace(a: (Namespace) `<Name name>::<Namespace n>`) 
    = namespace("<name>", convertModuleNamespace(n))[@src=a@\loc];


public Statement convertStmt(a: (Statement) `<Expression expr>;`) = expression(convertExpression(expr))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `;`) = emptyStmt()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(e))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `return;`) = \return(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `return <Expression expr>;`) = \return(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `persist <Expression expr>;`) = persist(convertExpression(expr))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `remove <Expression expr>;`) = remove(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `flush;`) = flush(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `flush <Expression expr>;`) = flush(convertExpression(expr))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `break ;`) = \break()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `break<Integer level>;`) = \break(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `continue ;`) = \continue()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `continue<Integer level>;`) = \continue(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>;`) = 
	declare(convertType(t), variable("<varName>")[@src=varName@\loc], emptyStmt()[@src=varName@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>=<Statement defValue>`) = 
	declare(convertType(t), variable("<varName>")[@src=varName@\loc], convertStmt(defValue))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>")[@src=var@\loc], convertStmt(body))[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>")[@src=var@\loc], convertStmt(body), [convertExpression(cond) | cond <- conds])[@src=a@\loc];


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


public RelationDir convertRelationDir(a: (RelationDir) `one`) = \one()[@src=a@\loc];
public RelationDir convertRelationDir(a: (RelationDir) `many`) = many()[@src=a@\loc];


// TODO enable only on entities
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Relation relation>`, _, str artifactType) 
    = convertRelation(relation, artifactType)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];

public Declaration convertDeclaration(a: (Declaration) `<Relation relation>`, _, str artifactType) = convertRelation(relation, artifactType);

public Declaration convertRelation(a: _, at: /^(?!entity).*$/) {
	throw RelationNotAllowed("Relations only allowed on entities", a@\loc);
}

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties))[@src=a@\loc];

public Declaration convertRelation(a: (Relation) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {})[@src=a@\loc];


public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty(a: (AccessProperty) `get`) = read()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `set`) = \set()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `add`) = add()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `clear`) = clear()[@src=a@\loc];
public AccessProperty convertAccessProperty(a: (AccessProperty) `reset`) = clear()[@src=a@\loc];


public str convertStringQuoted(string) = substring("<string>", 1, size("<string>") - 1);


public Type convertType(a: (Type) `int`) = integer()[@src=a@\loc];
public Type convertType(a: (Type) `float`) = float()[@src=a@\loc];
public Type convertType(a: (Type) `bool`) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `boolean`) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `void`) = voidValue()[@src=a@\loc];
public Type convertType(a: (Type) `string`) = string()[@src=a@\loc];
public Type convertType(a: (Type) `repository\<<ArtifactName name>\>`) = repository("<name>")[@src=a@\loc];
public Type convertType(a: (Type) `<Type t>[]`) = \list(convertType(t))[@src=a@\loc];
public Type convertType(a: (Type) `{<Type key>,<Type v>}`) = \map(convertType(key), convertType(v))[@src=a@\loc];
public Type convertType(a: (Type) `<ArtifactName name>`) = artifact("<name>")[@src=a@\loc];


public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);


public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as))[@src=a@\loc];
    
public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>")[@src=a@\loc];

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";


public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName,
    t: /repository|util/)
{
	t = t == "util" ? "util/service" : t;
    throw ConstructorNotAllowed("Constructor not allowed for <t> artifacts", a@\loc);
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName,
    _) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], emptyExpr())[@src=a@\loc];
}
    
public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName,
    _)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when))[@src=a@\loc];
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>);`, 
    str artifactName,
    _) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p) | p <- parameters], [], emptyExpr())[@src=a@\loc];
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, str artifactType) = 
	convertConstructor(construct, artifactName, artifactType);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, str artifactType) 
    = convertConstructor(construct, artifactName, artifactType)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];


public list[Declaration] convertParameters((AbstractParameters) `(<{AbstractParameter ","}* parameters>)`) = 
	[convertParameter(p) | p <- parameters];

public Declaration convertParameter((AbstractParameter) `<Parameter p>`) = convertParameter(p);
public Declaration convertParameter(a: (AbstractParameter) `<Annotation+ annotations><Parameter p>`) 
    = convertParameter(p)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name>`) = 
	param(convertType(paramType), "<name>", emptyExpr())[@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType)))[@src=a@\loc];


public Expression convertAssignable(a: (Assignable) `<MemberName name>`) = variable("<name>")[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key))[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Expression prev>.<MemberName field>`) 
    = fieldAccess(convertExpression(prev), "<field>")[@src=a@\loc];
