module Syntax::Abstract::Glagol::Helpers

import Syntax::Abstract::Glagol;
import List;
import IO;

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

public bool hasConstructors(list[Declaration] declarations) = 
	size([d | d <- declarations, isConstructor(d) || isAnnotated(d, isConstructor)]) > 0;

public list[Declaration] getConstructors(list[Declaration] declarations) = 
	[ c | d <- declarations, isConstructor(d) || isAnnotated(d, isConstructor), c := getConstructor(d)];

private list[Declaration] getMethodsByName(list[Declaration] declarations, str name) = 
	[ d | d <- declarations,
        isMethod(d) || isAnnotated(d, isMethod),
        m := getMethod(d),
        m.name == name
    ];

public map[str name, list[Declaration] methods] categorizeMethods(list[Declaration] declarations) = 
	(
        m.name: getMethodsByName(declarations, m.name) | 
        mi <- {ms | ms <- declarations, isMethod(ms) || isAnnotated(ms, isMethod)},
        m := getMethod(mi)
    );

public list[Declaration] getRelations(list[Declaration] declarations) = 
	[ d | d <- declarations, isRelation(d) || isAnnotated(d, isRelation)];

public Declaration getMethod(m: method(_, _, _, _, _, _)) = m;
public Declaration getMethod(m: method(_, _, _, _, _)) = m;
public Declaration getMethod(annotated(_, m: method(_, _, _, _, _, _))) = m;
public Declaration getMethod(annotated(_, m: method(_, _, _, _, _))) = m;

public Declaration getConstructor(c: constructor(_, _)) = c;
public Declaration getConstructor(c: constructor(_, _, _)) = c;
public Declaration getConstructor(annotated(_, c: constructor(_, _))) = c;
public Declaration getConstructor(annotated(_, c: constructor(_, _, _))) = c;

public bool hasOverriding(list[Declaration] declarations) =
    size(getConstructors(declarations)) > 1 || 
    (false | it ? true : size(ms[m]) > 1 | ms := categorizeMethods(declarations), m <- ms);
