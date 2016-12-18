module Transform::Glagol2PHP::Params

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Types;
import Transform::Glagol2PHP::Expressions;

public PhpParam toPhpParam(param(Type paramType, str name)) 
    = phpParam(name, phpNoExpr(), phpSomeName(toPhpTypeName(paramType)), false, false);
    
public PhpParam toPhpParam(param(Type paramType, str name, get(_))) 
    = phpParam(name, phpNoExpr(), phpSomeName(toPhpTypeName(paramType)), false, false);
    
public PhpParam toPhpParam(param(Type paramType, str name, Expression expr)) 
    = phpParam(name, phpSomeExpr(toPhpExpr(expr)), phpSomeName(toPhpTypeName(paramType)), false, false);
