module Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, _), env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];

public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, _, get(_)), env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())])[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];
    
public PhpClassItem toPhpClassItem(d: property(Type \valueType, str name, _, Expression defaultValue), env)
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))])[
    	@phpAnnotations=toPhpAnnotations(d, env)
    ];
