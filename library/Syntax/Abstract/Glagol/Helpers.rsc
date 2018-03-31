module Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import List;

public bool isProperty(property(_, _, _)) = true;
public default bool isProperty(value _) = false;

public bool isPropertyWithDefaultValue(property(_, _, d)) = emptyExpr() !:= d;

public bool isMethod(method(Modifier modifier, Type returnType, GlagolID name, list[Declaration] params, list[Statement] body, Expression when)) = true;
public default bool isMethod(value _) = false;

public bool isConstructor(constructor(list[Declaration] params, list[Statement] body, Expression when)) = true;
public default bool isConstructor(value _) = false;

public bool isEntity(entity(GlagolID name, list[Declaration] declarations)) = true;
public default bool isEntity(value _) = false;

public bool isValueObject(valueObject(GlagolID name, list[Declaration] declarations, Proxy proxy)) = true;
public default bool isValueObject(value _) = false;

public bool isRepository(repository(_, _)) = true;
public default bool isRepository(value _) = false;

public bool isController(controller(_, _, _, _)) = true;
public default bool isController(value _) = false;

public bool isIfThenElse(ifThenElse(Expression condition, Statement then, Statement \else)) = true;
public default bool isIfThenElse(value _) = false;

public bool isEmpty(emptyExpr()) = true;
public default bool isEmpty(value _) = false;

public bool isProxy(\module(Declaration ns, [], valueObject(GlagolID name, list[Declaration] declarations, proxyClass(str pr)))) = true;
public bool isProxy(\module(Declaration ns, [], util(GlagolID name, list[Declaration] declarations, proxyClass(str pr)))) = true;
public default bool isProxy(value _) = false;

public bool hasConstructors(list[Declaration] declarations) = size([d | d <- declarations, isConstructor(d)]) > 0;

public list[Declaration] getConstructors(list[Declaration] declarations) = [d | d <- declarations, isConstructor(d)];
public list[Declaration] getConstructors(\module(_, _, Declaration artifact)) = getConstructors(artifact.declarations);

private list[Declaration] getMethodsByName(list[Declaration] declarations, str name) = 
	[ d | d <- declarations,
        isMethod(d),
        d.name == name
    ];

public map[str name, list[Declaration] methods] categorizeMethods(list[Declaration] declarations) = 
	(
        name: getMethodsByName(declarations, name) | 
        name <- {ms.name | ms <- declarations, isMethod(ms)}
    );

public list[Declaration] getMethods(list[Declaration] ds) = [m | m: method(_, _, _, _, _, _) <- ds];
public list[Declaration] getMethods(\module(_, _, Declaration artifact)) = getMethods(artifact.declarations);
public default list[Declaration] getMethods(emptyDecl()) = [];
public list[Declaration] getPublicMethods(list[Declaration] ds) = [m | m: method(\public(), _, _, _, _, _) <- ds];

public bool hasOverriding(list[Declaration] declarations) =
    size(getConstructors(declarations)) > 1 || 
    (false | it ? true : size(ms[m]) > 1 | ms := categorizeMethods(declarations), m <- ms);

public bool hasMapUsage(Declaration artifact) { 
    top-down visit (artifact) {
        case \map(_): return true;
        case \map(_, _): return true;
    }
    return false;
}

public bool hasListUsage(Declaration artifact) { 
    top-down visit (artifact) {
        case \list(Type t): return true;
        case \list(list[Expression] values): return true;
    }
    return false;
}

public bool isImported(str \alias, list[Declaration] imports) = 
	(false | it ? true : as == \alias | \import(str artifactName, Declaration namespace, str as) <- imports);

public list[Declaration] getDIProperties(list[Declaration] declarations) =
	[p | p: property(_, _, get(_)) <- declarations];

public bool hasDependencies(list[Declaration] declarations) = (false | true | property(_, _, get(_)) <- declarations);

public list[Declaration] getActions(list[Declaration] declarations) = [d | d: action(_, _, _) <- declarations];

public list[Declaration] getControllerModules(list[Declaration] ast) = 
    [m | file(_, m: \module(_, _, controller(_, _, _, _))) <- ast];

public bool hasAnnotation(Declaration n, str name) = 
    (n@annotations?) ? (false | true | annotation(name, _) <- n@annotations) : false;
    
public str namespaceToString(Declaration ns) = namespaceToString(ns, "");
public str namespaceToString(namespace(str name), str d) = name;
public str namespaceToString(namespace(str name, Declaration subNamespace), str delimiter) = 
    name + delimiter + namespaceToString(subNamespace, delimiter);

public Declaration toNamespace(fullName(str localName, Declaration namespace, str originalName)) =
	\import(originalName, namespace, localName);

public str extractName(fullName(str localName, Declaration namespace, str originalName)) = localName;

public str toString(\public()) = "public";
public str toString(\private()) = "private";

public list[Declaration] requirements(list[Declaration] ast) = 
	[r | file(loc file, \module(Declaration ns, list[Declaration] is, Declaration artifact)) <- ast, r: require(str package, str version) <- declarations(artifact)];

private list[Declaration] declarations(util(GlagolID name, list[Declaration] declarations, proxyClass(str c))) = [d | d <- declarations];
private list[Declaration] declarations(valueObject(GlagolID name, list[Declaration] declarations, proxyClass(str c))) = [d | d <- declarations];
private default list[Declaration] declarations(Declaration d) = [];
