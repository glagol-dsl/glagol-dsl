module Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import List;

public bool isProperty(property(_, _, _)) = true;
public bool isProperty(property(_, _, _, _)) = true;
public default bool isProperty(_) = false;

public bool isAnnotated(annotated(_, _)) = true;
public bool isAnnotated(annotated(_, Declaration declaration), bool (Declaration) innerValidator) = innerValidator(declaration);
public default bool isAnnotated(_, _) = false;
public default bool isAnnotated(_) = false;

public bool isMethod(method(_, _, _, _, _)) = true;
public bool isMethod(method(_, _, _, _, _, _)) = true;
public bool isMethod(_) = false;

public bool isRelation(relation(_, _, _, _, _)) = true;
public bool isRelation(_) = false;

public bool isConstructor(constructor(_, _)) = true;
public bool isConstructor(constructor(_, _, _)) = true;
public bool isConstructor(_) = false;

public bool isEntity(entity(_, _)) = true;
public bool isEntity(annotated(_, Declaration d)) = isEntity(d);
public bool isEntity(_) = false;

public bool hasConstructors(list[Declaration] declarations) = size([d | d <- declarations, isConstructor(d)]) > 0;

public list[Declaration] getConstructors(list[Declaration] declarations) = [d | d <- declarations, isConstructor(d)];

private list[Declaration] getMethodsByName(list[Declaration] declarations, str name)
    = [m | m <- declarations, isMethod(m), name == m.name];

public map[str name, list[Declaration] methods] categorizeMethods(list[Declaration] declarations)
    = (m.name: getMethodsByName(declarations, m.name) | m <- {ms | ms <- declarations, isMethod(ms)});

public list[Declaration] getRelations(list[Declaration] declarations) = [d | d <- declarations, isRelation(d)];

public bool hasOverriding(list[Declaration] declarations) =
    size(getConstructors(declarations)) > 1 || 
    (false | it ? true : size(ms[m]) > 1 | ms := categorizeMethods(declarations), m <- ms);
