module Transform::Glagol2PHP::Params

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Types;

public PhpParam toPhpParam(param(Type paramType, str name)) 
    = phpParam(name, phpNoExpr(), phpSomeName(toPhpTypeName(paramType)), false);
