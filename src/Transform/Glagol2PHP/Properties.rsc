module Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private str toString(float()) = "float";
private str toString(string()) = "string";
private str toString(voidValue()) = "void";
private str toString(boolean()) = "bool";
private str toString(integer()) = "integer";
private str toString(typedList(Type \type)) = "<toString(\type)>[]";
private str toString(typedMap(Type key, Type v)) = "Map";
private str toString(artifactType(str name)) = name;
private str toString(repositoryType(str name)) = "<name>Repository";

public PhpClassItem toPhpClassItem(d: property(Type valueType, str name, _), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, _, get(_)), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
    
public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, _, Expression defaultValue), env, context)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))])[
    	@phpAnnotations=toPhpAnnotations(d, env, context) + {
    		phpAnnotation("var", phpAnnotationVal(toString(valueType)))
    	}
    ];
