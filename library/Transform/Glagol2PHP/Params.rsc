module Transform::Glagol2PHP::Params

import Transform::Env;
import Transform::OriginAnnotator;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Types;
import Transform::Glagol2PHP::Expressions;

public PhpParam toPhpParam(p: param(Type paramType, str name, emptyExpr())) 
    = origin(phpParam(name, phpNoExpr(), origin(phpSomeName(toPhpTypeName(paramType)), paramType), false, false), p);
    
public PhpParam toPhpParam(p: param(Type paramType, str name, get(_))) 
    = origin(phpParam(name, phpNoExpr(), origin(phpSomeName(toPhpTypeName(paramType)), paramType), false, false), p);
    
public PhpParam toPhpParam(p: param(Type paramType, str name, Expression expr)) 
    = origin(
    	phpParam(
    		name, 
    		origin(phpSomeExpr(toPhpExpr(expr, newTransformEnv())), expr), 
    		origin(phpSomeName(toPhpTypeName(paramType)), paramType), 
    		false, false
		), p
	);
