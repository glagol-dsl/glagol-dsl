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
private PhpOptionName toPhpReturnType(integer()) = phpSomeName(phpName("int"));
private PhpOptionName toPhpReturnType(string()) = phpSomeName(phpName("string"));
private PhpOptionName toPhpReturnType(boolean()) = phpSomeName(phpName("boolean"));
private PhpOptionName toPhpReturnType(float()) = phpSomeName(phpName("float"));
private PhpOptionName toPhpReturnType(typedList(_)) = phpSomeName(phpName("Vector"));
private PhpOptionName toPhpReturnType(typedMap(_,_)) = phpSomeName(phpName("Map"));
private PhpOptionName toPhpReturnType(artifactType(str name)) = phpSomeName(phpName(name));
private PhpOptionName toPhpReturnType(repositoryType(str name)) = phpSomeName(phpName(name + "Repository"));

private PhpModifier toPhpModifier(\public()) = phpPublic();
private PhpModifier toPhpModifier(\private()) = phpPrivate();
