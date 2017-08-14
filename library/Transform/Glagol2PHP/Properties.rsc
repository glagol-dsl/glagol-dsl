module Transform::Glagol2PHP::Properties

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

public PhpClassItem toPhpClassItem(d: property(Type valueType, str name, emptyExpr()), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, get(_)), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
    
public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, Expression defaultValue), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
