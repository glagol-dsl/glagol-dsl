module Transform::Glagol2PHP::Properties

import Transform::Env;
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

public PhpClassItem toPhpClassItem(d: property(Type valueType, str name, emptyExpr()), TransformEnv env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, get(_)), TransformEnv env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
    
public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, Expression defaultValue), TransformEnv env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue, env)))])[
    	@phpAnnotations=toPhpAnnotations(d, env) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
