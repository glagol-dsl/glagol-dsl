module Transform::Glagol2PHP::Methods

import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(method(Modifier modifier, \Type returnType, str name, list[Declaration] params, list[Statement] body))
    = phpMethod(
        name, 
        {toPhpModifier(modifier)}, 
        false, 
        [toPhpParam(p) | p <- params], 
        [toPhpStmt(stmt) | stmt <- body], 
        toPhpReturnType(returnType)
    );

private PhpOptionName toPhpReturnType(voidValue()) = phpNoName();

private PhpModifier toPhpModifier(\public()) = phpPublic();
