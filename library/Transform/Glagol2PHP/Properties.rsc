module Transform::Glagol2PHP::Properties

import Transform::Env;
import Transform::OriginAnnotator;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private str toString(integer()) = "integer";
private str toString(float()) = "float";
private str toString(string()) = "string";
private str toString(voidValue()) = "void";
private str toString(boolean()) = "bool";
private str toString(\list(Type \type)) = "<toString(\type)>[]";
private str toString(\map(Type key, Type v)) = "Map";
private str toString(artifact(Name name)) = name.localName;
private str toString(repository(Name name)) = "<name.localName>Repository";

public PhpClassItem toPhpClassItem(d: property(valueType: fullName(str localName, Declaration namespace, str originalName), str name, emptyExpr()), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [phpProperty(name, origin(phpNoExpr(), d))])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType)),
    		phpAnnotation("column", (
    			"type": origin(phpAnnotationVal(phpString(toLowerCase(namespaceToString(getNamespace(env), "_") + "_" + originalName))), d, true)
    		))
    	}
    ], d) when isValueObject(valueType, env);
    
public PhpClassItem toPhpClassItem(d: property(Type valueType, str name, emptyExpr()), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, phpNoExpr()), d, true)])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", origin(phpAnnotationVal(toString(valueType)), valueType))
    	}
    ], d);

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, get(_)), TransformEnv env)
    = origin(phpProperty({origin(phpPrivate(), d)}, [origin(phpProperty(name, phpNoExpr()), d, true)])[
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
