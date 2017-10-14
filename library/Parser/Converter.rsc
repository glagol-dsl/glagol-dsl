@doc="This is automatically generated file. Do not edit"
module Parser::Converter
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import Parser::Env;
import ParseTree;
import String;
import List;
import Set;
import Exceptions::ParserExceptions;
import IO;



public Declaration buildAST(a: (Module) `namespace <Namespace n><Import* imports><AnnotatedArtifact annotatedArtifact>`) {
	list[Declaration] convertedImports = [convertImport(\import) | \import <- imports];
	Declaration ns = convertModuleNamespace(n);
    return \module(ns, convertedImports, convertAnnotatedArtifact(annotatedArtifact, newParseEnv(convertedImports, ns)))[@src=a@\loc];
}


public Expression convertParameterDefaultVal(a: (AssignDefaultValue) `=<DefaultValue defaultValue>`, Type onType, ParseEnv env) {

    Expression defaultValue = convertExpression(defaultValue, env);
    
    if (defaultValue == get(selfie())) {
        defaultValue = get(onType);
    }

    return defaultValue[@src=a@\loc];
}
    


public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Artifact artifact>`, ParseEnv env) = 
	convertArtifact(artifact, env);
    
public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Annotation* annotations><Artifact artifact>`, ParseEnv env) = 
	convertArtifact(artifact, env)[
    	@annotations = convertAnnotations(annotations, env)
    ];

public Declaration convertArtifact(a: (Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	entity("<name>", [convertDeclaration(d, "<name>", "entity", env) | d <- declarations])[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) =
	repository("<name>", [convertDeclaration(d, "<name>", "repository", env) | d <- declarations] + defaultRepositoryMethod("<name>", a@\loc, env))[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `value <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	valueObject("<name>", [convertDeclaration(d, "<name>", "value", env) | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `util <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	util("<name>", [convertDeclaration(d, "<name>", "util", env) | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `service <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	util("<name>", [convertDeclaration(d, "<name>", "util", env) | d <- declarations])[@src=a@\loc];

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

public Route convertRoute(ro: (Route) `/<{RoutePart "/"}* routes>`) = route([convertRoute(r) | r <- routes])[@src=ro@\loc];

public Declaration convertArtifact(a: (Artifact) `<ControllerType controllerType>controller<Route r>{<Declaration* declarations>}`, ParseEnv env) = 
	controller(
		createControllerName(a@\loc),
		convertControllerType(controllerType), 
		convertRoute(r), 
		[convertDeclaration(d, "", "controller", env) | d <- declarations]
	)[@src=a@\loc];

private list[Declaration] defaultRepositoryMethod(str name, loc src, ParseEnv env) = [
	method(\public()[@src=src], artifact(createName(name, env)[@src=src])[@src=src], "find", [
		param(integer()[@src=src], "id", emptyExpr()[@src=src])[@src=src]
	], [\return(new(createName(name, env)[@src=src], [])[@src=src])[@src=src]], emptyExpr()[@src=src])[@src=src],
	method(\public()[@src=src], \list(artifact(createName(name, env)[@src=src])[@src=src])[@src=src], "findAll", [], 
		[\return(\list([])[@src=src])[@src=src]], emptyExpr()[@src=src])[@src=src]
];


public AssignOperator convertAssignOperator(a: (AssignOperator) `/=`) = divisionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `*=`) = productAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `-=`) = subtractionAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `=`) = defaultAssign()[@src=a@\loc];
public AssignOperator convertAssignOperator(a: (AssignOperator) `+=`) = additionAssign()[@src=a@\loc];


public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> } <When when>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
    
public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], convertWhen(when, env))[@src=a@\loc];

public Declaration convertMethod(
    a: (Method) `<Modifier modifier><Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>) = <Expression expr><When when>;`, ParseEnv env) 
    = method(convertModifier(modifier), convertType(returnType, env), "<name>", [convertParameter(p, env) | p <- parameters], [\return(convertExpression(expr, env))[@src=expr@\loc]], convertWhen(when, env))[@src=a@\loc];
    
private Modifier convertModifier(a: (Modifier) `public`) = \public()[@src=a@\loc];
private Modifier convertModifier(a: (Modifier) `private`) = \private()[@src=a@\loc];

public Declaration convertDeclaration((Declaration) `<Method method>`, _, _, ParseEnv env) = convertMethod(method, env);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Method method>`, _, _, ParseEnv env) 
    = convertMethod(method, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];



public str convertStringQuoted(string) = substring("<string>", 1, size("<string>") - 1);


public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;


public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`, ParseEnv env)  =
    property(convertType(prop, env), "<name>", emptyExpr()[@src=a@\loc])[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop, env))
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`, ParseEnv env) =
    property(convertType(prop, env), "<name>", convertParameterDefaultVal(defVal, convertType(prop, env), env))[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop, env))
    ];

public list[Annotation] buildPropDefaultAnnotations(Type t) = 
    [annotation("column", [annotationMap(("type": annotationVal(t)))])]
    when t in [integer(), string(), boolean(), float()];
    
public default list[Annotation] buildPropDefaultAnnotations(Type t) = [];

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _, ParseEnv env) {
    Declaration property = convertProperty(prop, env);

    list[Annotation] pAnnotations = property@annotations? ? property@annotations : [];

    for (an <- convertAnnotations(annotations, env)) {
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
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _, ParseEnv env) = convertProperty(prop, env);


public Declaration convertModuleNamespace(a: (Namespace) `<Name name>`) = namespace("<name>")[@src=a@\loc];
public Declaration convertModuleNamespace(a: (Namespace) `<Name name>::<Namespace n>`) 
    = namespace("<name>", convertModuleNamespace(n))[@src=a@\loc];


public Statement convertStmt(a: (Statement) `<Expression expr>;`, ParseEnv env) = expression(convertExpression(expr, env))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `;`, ParseEnv env) = emptyStmt()[@src=a@\loc];
public Statement convertStmt(a: (Statement) `{<Statement* stmts>}`, ParseEnv env) = block([convertStmt(stmt, env) | stmt <- stmts])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then>`, ParseEnv env)
    = ifThen(convertExpression(condition, env), convertStmt(then, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`, ParseEnv env)
    = ifThenElse(convertExpression(condition, env), convertStmt(then, env), convertStmt(e, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Assignable assignable><AssignOperator operator><Statement val>`, ParseEnv env)
    = assign(convertAssignable(assignable, env), convertAssignOperator(operator), convertStmt(val, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `return;`, ParseEnv env) = \return(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `return <Expression expr>;`, ParseEnv env) = \return(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `persist <Expression expr>;`, ParseEnv env) = persist(convertExpression(expr, env))[@src=a@\loc];
public Statement convertStmt(a: (Statement) `remove <Expression expr>;`, ParseEnv env) = remove(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `flush;`, ParseEnv env) = flush(emptyExpr()[@src=a@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `flush <Expression expr>;`, ParseEnv env) = flush(convertExpression(expr, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `break ;`, ParseEnv env) = \break(1)[@src=a@\loc];
public Statement convertStmt(a: (Statement) `break<Integer level>;`, ParseEnv env) = \break(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `continue ;`, ParseEnv env) = \continue(1)[@src=a@\loc];
public Statement convertStmt(a: (Statement) `continue<Integer level>;`, ParseEnv env) = \continue(toInt("<level>"))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>;`, ParseEnv env) =
	declare(convertType(t, env), variable("<varName>")[@src=varName@\loc], emptyStmt()[@src=varName@\loc])[@src=a@\loc];
public Statement convertStmt(a: (Statement) `<Type t> <MemberName varName>=<Statement defValue>`, ParseEnv env) =
	declare(convertType(t, env), variable("<varName>")[@src=varName@\loc], convertStmt(defValue, env))[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), emptyExpr()[@src=a@\loc], variable("<var>")[@src=var@\loc], convertStmt(body, env), [])[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), emptyExpr()[@src=a@\loc], variable("<var>")[@src=var@\loc], convertStmt(body, env), [convertExpression(cond, env) | cond <- conds])[@src=a@\loc];

public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName key>:<MemberName var>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), variable("<key>")[@src=key@\loc], variable("<var>")[@src=var@\loc], convertStmt(body, env), [])[@src=a@\loc];
    
public Statement convertStmt(a: (Statement) `for (<Expression l>as<MemberName key>:<MemberName var>, <{Expression ","}+ conds>)<Statement body>`, ParseEnv env)
    = foreach(convertExpression(l, env), variable("<key>")[@src=key@\loc], variable("<var>")[@src=var@\loc], convertStmt(body, env), [convertExpression(cond, env) | cond <- conds])[@src=a@\loc];
    


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


public Symbol convertSymbol(m: (MemberName) `<MemberName field>`) = symbol("<field>")[@src=m@\loc];


public Expression convertExpression(a: (Expression) `(<Expression expr>)`, ParseEnv env) = \bracket(convertExpression(expr, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<Expression lhs> * <Expression rhs>`, ParseEnv env)
    = product(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> / <Expression rhs>`, ParseEnv env)
    = division(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> + <Expression rhs>`, ParseEnv env)
    = addition(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> - <Expression rhs>`, ParseEnv env)
    = subtraction(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \>= <Expression rhs>`, ParseEnv env)
    = greaterThanOrEq(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \<= <Expression rhs>`, ParseEnv env)
    = lessThanOrEq(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \< <Expression rhs>`, ParseEnv env)
    = lessThan(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> \> <Expression rhs>`, ParseEnv env)
    = greaterThan(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> == <Expression rhs>`, ParseEnv env)
    = equals(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> != <Expression rhs>`, ParseEnv env)
    = nonEquals(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> && <Expression rhs>`, ParseEnv env)
    = and(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> || <Expression rhs>`, ParseEnv env)
    = or(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression lhs> % <Expression rhs>`, ParseEnv env)
    = remainder(convertExpression(lhs, env), convertExpression(rhs, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`, ParseEnv env)
    = ifThenElse(convertExpression(condition, env), convertExpression(thenExp, env), convertExpression(elseExp, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `<StringQuoted s>`, ParseEnv env)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DecimalIntegerLiteral number>`, ParseEnv env)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<DeciFloatNumeral number>`, ParseEnv env)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Boolean b>`, ParseEnv env)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `[<{Expression ","}* items>]`, ParseEnv env)
    = \list([convertExpression(i, env) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName varName>`, ParseEnv env)
    = variable("<varName>")[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `-<Expression expr>`, ParseEnv env)
    = negative(convertExpression(expr, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `+<Expression expr>`, ParseEnv env)
    = positive(convertExpression(expr, env))[@src=a@\loc];

public Expression convertExpression(a: (Expression) `this`, ParseEnv env) = this()[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `<StringQuoted s>`, ParseEnv env)
    = string(convertStringQuoted(s))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DecimalIntegerLiteral number>`, ParseEnv env)
    = integer(toInt("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<DeciFloatNumeral number>`, ParseEnv env)
    = float(toReal("<number>"))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `<Boolean b>`, ParseEnv env)
    = boolean(convertBoolean(b))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `[<{DefaultValue ","}* items>]`, ParseEnv env)
    = \list([convertExpression(i, env) | i <- items])[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `get <InstanceType t>`, ParseEnv env)
    = get(convertInstanceType(t, env))[@src=a@\loc];
    
public Expression convertExpression(a: (DefaultValue) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env)
    = new(createName("<name>", env)[@src=name@\loc], [convertExpression(arg, env) | arg <- args])[@src=a@\loc];

public Expression convertExpression(a: (DefaultValue) `{<{MapPair ","}* pairs>}`, ParseEnv env) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p, env) )
)[@src=a@\loc];

public Type convertInstanceType(a: (InstanceType) `<Type t>`, ParseEnv env) = convertType(t, env)[@src=a@\loc];
public Type convertInstanceType(a: (InstanceType) `selfie`, ParseEnv env) = selfie()[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env)
    = new(createName("<name>", env)[@src=name@\loc], [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
    
// public Expression convertExpression(a: (Expression) `get <Type t>`, ParseEnv env) = get(convertType(t, env))[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<MemberName method>(<{Expression ","}* args>)`, ParseEnv env)
    = invoke(convertSymbol(method), [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
    
public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`, ParseEnv env) {
    
    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }
    
    return invoke(convertExpression(true, prev, env), convertSymbol(method), [convertExpression(arg, env) | arg <- args])[@src=a@\loc];
}

public Expression convertExpression(brackets: true, e: (Expression) `new <ArtifactName name>(<{Expression ","}* args>)`, ParseEnv env) = 
	\bracket(convertExpression(e, env))[@src = e@\loc];
	
public Expression convertExpression(brackets: true, e, ParseEnv env) = convertExpression(e, env);

public Expression convertExpression(a: (Expression) `<Expression prev>.<MemberName field>`, ParseEnv env) {

    if (!isValidForAccessChain(prev)) {
        throw IllegalObjectOperator("Invalid expression followed by object operator", a@\loc);
    }

    return fieldAccess(convertExpression(true, prev, env), convertSymbol(field))[@src=a@\loc];
}

public Expression convertExpression(a: (Expression) `{<{MapPair ","}* pairs>}`, ParseEnv env) = \map(
    ( key: v | p <- pairs, <Expression key, Expression v> := convertMapPair(p, env) )
)[@src=a@\loc];

private tuple[Expression key, Expression \value] convertMapPair((MapPair) `<Expression key>:<Expression v>`, ParseEnv env)
    = <convertExpression(key, env), convertExpression(v, env)>;

public Expression convertExpression(a: (Expression) `(<Type t>)<Expression expr>`, ParseEnv env) = 
	cast(convertType(t, env), convertExpression(expr, env))[@src=a@\loc];

private bool isValidForAccessChain((Expression) `<MemberName varName>`) = true;
private bool isValidForAccessChain((Expression) `this`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
//private bool isValidForAccessChain((Expression) `get <Type t>`) = true;
private bool isValidForAccessChain((Expression) `new <ArtifactName name>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName method>(<{Expression ","}* args>)`) = true;
private bool isValidForAccessChain((Expression) `<Expression prev>.<MemberName field>`) = true;
private default bool isValidForAccessChain(_) = false;


public Type convertType(a: (Type) `int`, ParseEnv env) = integer()[@src=a@\loc];
public Type convertType(a: (Type) `float`, ParseEnv env) = float()[@src=a@\loc];
public Type convertType(a: (Type) `bool`, ParseEnv env) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `boolean`, ParseEnv env) = boolean()[@src=a@\loc];
public Type convertType(a: (Type) `void`, ParseEnv env) = voidValue()[@src=a@\loc];
public Type convertType(a: (Type) `string`, ParseEnv env) = string()[@src=a@\loc];
public Type convertType(a: (Type) `repository\<<ArtifactName name>\>`, ParseEnv env) = repository(createName("<name>", env)[@src=name@\loc])[@src=a@\loc];
public Type convertType(a: (Type) `<Type t>[]`, ParseEnv env) = \list(convertType(t, env))[@src=a@\loc];
public Type convertType(a: (Type) `{<Type key>,<Type v>}`, ParseEnv env) = \map(convertType(key, env), convertType(v, env))[@src=a@\loc];
public Type convertType(a: (Type) `<ArtifactName name>`, ParseEnv env) = artifact(createName("<name>", env)[@src=name@\loc])[@src=a@\loc];


public Expression convertWhen(w: (When) `when <Expression expr>`, ParseEnv env) = convertExpression(expr, env)[@src=w@\loc];


public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact><ImportAlias as>;`)
    = \import("<artifact>", convertModuleNamespace(n), convertImportAlias(as))[@src=a@\loc];
    
public Declaration convertImport(a: (Import) `import <Namespace n>::<ArtifactName artifact>;`)
    = \import("<artifact>", convertModuleNamespace(n), "<artifact>")[@src=a@\loc];

private str convertImportAlias((ImportAlias) `as <ArtifactName as>`) = "<as>";


public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName, t: /repository|util/, ParseEnv env)
{
	t = t == "util" ? "util/service" : t;
    throw ConstructorNotAllowed("Constructor not allowed for <t> artifacts", a@\loc);
}

public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName, _, ParseEnv env) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    } 
    
    return constructor([convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], emptyExpr()[@src=a@\loc])[@src=a@\loc];
}
    
public Declaration convertConstructor(
    a: (Constructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName, _, ParseEnv env)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
    }
    
    return constructor([convertParameter(p, env) | p <- parameters], [convertStmt(stmt, env) | stmt <- body], convertWhen(when, env))[@src=a@\loc];
}

public Declaration convertDeclaration((Declaration) `<Constructor construct>`, str artifactName, str artifactType, ParseEnv env) = 
	convertConstructor(construct, artifactName, artifactType, env);
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Constructor construct>`, str artifactName, str artifactType, ParseEnv env) 
    = convertConstructor(construct, artifactName, artifactType, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];


public list[Declaration] convertParameters((AbstractParameters) `(<{AbstractParameter ","}* parameters>)`, ParseEnv env) =
	[convertParameter(p, env) | p <- parameters];

public Declaration convertParameter((AbstractParameter) `<Parameter p>`, ParseEnv env) = convertParameter(p, env);
public Declaration convertParameter(a: (AbstractParameter) `<Annotation+ annotations><Parameter p>`, ParseEnv env)
    = convertParameter(p, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name>`, ParseEnv env) =
	param(convertType(paramType, env), "<name>", emptyExpr()[@src=a@\loc])[@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`, ParseEnv env)
    = param(convertType(paramType, env), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType, env), env))[@src=a@\loc];


public Expression convertAssignable(a: (Assignable) `<MemberName name>`, ParseEnv env) = variable("<name>")[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Assignable variable>[<Expression key>]`, ParseEnv env)
    = arrayAccess(convertAssignable(variable, env), convertExpression(key, env))[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Expression prev>.<MemberName field>`, ParseEnv env)
    = fieldAccess(convertExpression(prev, env), convertSymbol(field))[@src=a@\loc];


public Name createName(str localName, ParseEnv env) = createName(localName, getImported(localName, env)) when isImported(localName, env);

public Name createName(str localName, ParseEnv env) = fullName(localName, getNamespace(env), localName);

public Name createName(str localName, \import(GlagolID originalName, Declaration namespace, _)) = fullName(localName, namespace, originalName);


public Declaration convertDeclaration(d: (Declaration) `<Action action>`, _, a: /^(?!controller).*$/, _) {
	throw ActionNotAllowed("Action declarations not allowed in artifact type \'<a>\'", d@\loc);
}

// TODO actions with annotations?
public Declaration convertDeclaration((Declaration) `<Action action>`, _, _, ParseEnv env) = convertAction(action, env);

public Declaration convertAction(a: (Action) `<MemberName name>{<Statement* body>}`, ParseEnv env) = 
	action("<name>", [], [convertStmt(stmt, env) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name>=<Expression expr>;`, ParseEnv env) = 
	action("<name>", [], [\return(convertExpression(expr, env))]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>{<Statement* body>}`, ParseEnv env) = 
	action("<name>", convertParameters(params, env), [convertStmt(stmt, env) | stmt <- body]);

public Declaration convertAction(a: (Action) `<MemberName name><AbstractParameters params>=<Expression expr>;`, ParseEnv env) = 
	action("<name>", convertParameters(params, env), [\return(convertExpression(expr, env))]);
