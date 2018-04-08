module Transform::Glagol2PHP::Properties

import Transform::Env;
import Transform::OriginAnnotator;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Utils::String;
import String;

import IO;

private str toString(integer()) = "integer";
private str toString(float()) = "float";
private str toString(string()) = "string";
private str toString(voidValue()) = "void";
private str toString(boolean()) = "bool";
private str toString(\list(Type \type)) = "<toString(\type)>[]";
private str toString(\map(Type key, Type v)) = "Map";
private str toString(artifact(Name name)) = name.localName;
private str toString(repository(Name name)) = "<name.localName>Repository";

public PhpClassItem toPhpClassItem(d: property(valueType: artifact(f: fullName(str localName, Declaration namespace, str originalName)), str name, Expression e), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpNoExpr(), e)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType)),
    		phpAnnotation("ORM\\Column", phpAnnotationVal((
    			"type": origin(phpAnnotationVal(valueObjectTypeId(env, f)), d, true)
    		)))
    	}
    ], d) when isValueObject(valueType, env);
    

public PhpClassItem toPhpClassItem(d: property(valueType: artifact(f: fullName(str localName, Declaration namespace, str originalName)), str name, Expression e), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpNoExpr(), e)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType)),
    		phpAnnotation("ORM\\<assocType(d, env)>", phpAnnotationVal((
    			"targetEntity": phpAnnotationVal(localName),
    			"cascade": phpAnnotationVal("persist")
    		)))
    	}
    ], d) when isEntity(valueType, env) && isInEntity(env);
    
public PhpClassItem toPhpClassItem(d: property(\list(valueType: artifact(f: fullName(str localName, Declaration namespace, str originalName))), str name, Expression e), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpNoExpr(), e)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType)),
    		phpAnnotation("ORM\\<assocType(d, env)>", phpAnnotationVal((
    			"targetEntity": phpAnnotationVal(localName)
    		)))
    	}
    ], d) when isEntity(valueType, env) && isInEntity(env);

private str assocType(d: property(artifact(Name n), str name, Expression e), TransformEnv env) = "ManyToOne" when !hasAssocAnnotation(d);
private str assocType(d: property(\list(artifact(Name n)), str name, Expression e), TransformEnv env) = "OneToMany" when !hasAssocAnnotation(d);
private str assocType(d: property(Type t, str name, Expression e), TransformEnv env) = getAssocAnnotation(d) when hasAssocAnnotation(d);

private bool hasAssocAnnotation(Declaration d) = false when (d@annotations?);
private bool hasAssocAnnotation(Declaration d) = true when ([*l, annotation("manyToOne", list[Annotation] arguments), *r] := d@annotations);
private bool hasAssocAnnotation(Declaration d) = true when ([*l, annotation("oneToOne", list[Annotation] arguments), *r] := d@annotations);
private bool hasAssocAnnotation(Declaration d) = true when ([*l, annotation("oneToMany", list[Annotation] arguments), *r] := d@annotations);
private bool hasAssocAnnotation(Declaration d) = true when ([*l, annotation("manyToMany", list[Annotation] arguments), *r] := d@annotations);

private str hasAssocAnnotation(Declaration d) = "ManyToOne" when ([*l, annotation("manyToOne", list[Annotation] arguments), *r] := d@annotations);
private str hasAssocAnnotation(Declaration d) = "OneToOne" when ([*l, annotation("oneToOne", list[Annotation] arguments), *r] := d@annotations);
private str hasAssocAnnotation(Declaration d) = "OneToMany" when ([*l, annotation("oneToMany", list[Annotation] arguments), *r] := d@annotations);
private str hasAssocAnnotation(Declaration d) = "ManyToMany" when ([*l, annotation("manyToMany", list[Annotation] arguments), *r] := d@annotations);


private str valueObjectTypeId(TransformEnv env, fullName(str lname, Declaration ns, str name)) = 
	"datetime" 
	when isProxy(\import(name, ns, lname), env) && isPhpDateTime(getProxyClass(\import(name, ns, lname), env));
	
private default str valueObjectTypeId(TransformEnv env, fullName(str _, Declaration ns, str name)) = 
	toLowerCase(namespaceToString(ns, "_") + "_" + name);

private bool isPhpDateTime(proxyClass(str class)) = class == "\\DateTime";
private bool isPhpDateTime(proxyClass(str class)) = class == "\\DateTimeImmutable";
private default bool isPhpDateTime(Proxy proxy) = false;

public PhpClassItem toPhpClassItem(d: property(Type valueType, str name, e: emptyExpr()), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpNoExpr(), e)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType))
    	}
    ], d);

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, g: get(_)), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpNoExpr(), g)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType))
    	}
    ], d);
    
public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, Expression defaultValue), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, origin(phpSomeExpr(toPhpExpr(defaultValue, env)), defaultValue)), d)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType))
    	}
    ], d);
