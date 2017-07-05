module Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import List;
import IO;

public bool isProperty(property(_, _, _)) = true;
public default bool isProperty(_) = false;

public bool isPropertyWithDefaultValue(property(_, _, d)) = emptyExpr() !:= d;

public bool isMethod(method(_, _, _, _, _, _)) = true;
public bool isMethod(_) = false;

public bool isRelation(relation(_, _, _, _)) = true;
public bool isRelation(_) = false;

public bool isConstructor(constructor(_, _, _)) = true;
public bool isConstructor(_) = false;

public bool isEntity(entity(_, _)) = true;
public bool isEntity(_) = false;

public bool isRepository(repository(_, _)) = true;
public bool isRepository(_) = false;

public bool isController(controller(_, _, _, _)) = true;
public bool isController(_) = false;

public bool isIfThenElse(ifThenElse(Expression condition, Statement then, Statement \else)) = true;
public bool isIfThenElse(_) = false;

public bool isEmpty(emptyExpr()) = true;
public bool isEmpty(_) = false;

public bool hasConstructors(list[Declaration] declarations) = 
	size([d | d <- declarations, isConstructor(d)]) > 0;

public list[Declaration] getConstructors(list[Declaration] declarations) = 
	[ d | d <- declarations, isConstructor(d)];

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

public list[Declaration] getMethods(list[Declaration] ds) = [m | m: method(_, _, _, _, _) <- ds];
public list[Declaration] getPublicMethods(list[Declaration] ds) = [m | m: method(\public(), _, _, _, _) <- ds];

public list[Declaration] getRelations(list[Declaration] declarations) = 
	[ d | d <- declarations, isRelation(d)];

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
        case \list(_): return true;
        case \list(_): return true;
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
    
public str namespaceToString(namespace(str name), _) = name;
public str namespaceToString(namespace(str name, Declaration subNamespace), str delimiter) = 
    name + delimiter + namespaceToString(subNamespace, delimiter);

public Declaration toNamespace(external(str localName, Declaration namespace, str originalName)) =
	\import(originalName, namespace, localName);

public str extractName(external(str localName, Declaration namespace, str originalName)) = localName;
public str extractName(local(str localName)) = localName;

public str toString(\public()) = "public";
public str toString(\private()) = "private";
