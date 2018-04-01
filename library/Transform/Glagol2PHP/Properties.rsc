module Transform::Glagol2PHP::Properties

import Transform::Env;
import Transform::OriginAnnotator;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
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
