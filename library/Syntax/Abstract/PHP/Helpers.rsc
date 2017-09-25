module Syntax::Abstract::PHP::Helpers

import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

public PhpExpr phpVar(str name) = phpVar(phpName(phpName(name)));

public PhpStmt phpDeclareStrict() = phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], []);

public PhpExpr phpNew(str name, list[PhpActualParameter] parameters) = phpNew(phpName(phpName(name)), parameters);

public PhpExpr phpCall(str name, list[PhpActualParameter] parameters) = phpCall(phpName(phpName(name)), parameters);

public PhpParam phpParam(str paramName) = phpParam(paramName, phpNoExpr(), phpNoName(), false, false);

public PhpOptionName toPhpReturnType(voidValue()) = phpNoName();
public PhpOptionName toPhpReturnType(integer()) = phpSomeName(phpName("int"));
public PhpOptionName toPhpReturnType(string()) = phpSomeName(phpName("string"));
public PhpOptionName toPhpReturnType(boolean()) = phpSomeName(phpName("bool"));
public PhpOptionName toPhpReturnType(float()) = phpSomeName(phpName("float"));
public PhpOptionName toPhpReturnType(\list(_)) = phpSomeName(phpName("Vector"));
public PhpOptionName toPhpReturnType(\map(_,_)) = phpSomeName(phpName("Map"));
public PhpOptionName toPhpReturnType(artifact(Name name)) = phpSomeName(phpName(extractName(name)));
public PhpOptionName toPhpReturnType(repository(Name name)) = phpSomeName(phpName(extractName(name) + "Repository"));

public PhpOptionName makeOptional(phpSomeName(phpName(str \type))) = phpSomeName(phpName("?<\type>"));
