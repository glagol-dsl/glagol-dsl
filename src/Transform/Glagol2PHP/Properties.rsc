module Transform::Glagol2PHP::Properties

import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(property(Type \valueType, str name, _)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())]);

public PhpClassItem toPhpClassItem(property(Type \valueType, str name, _, get(_))) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())]);
    
public PhpClassItem toPhpClassItem(property(Type \valueType, str name, _, Expression defaultValue)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))]);
