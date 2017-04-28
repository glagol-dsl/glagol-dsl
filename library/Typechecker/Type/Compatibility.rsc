module Typechecker::Type::Compatibility

import Syntax::Abstract::Glagol;

public bool areCompatible(integer(), integer()) = true;
public bool areCompatible(float(), float()) = true;
public bool areCompatible(boolean(), boolean()) = true;
public bool areCompatible(string(), string()) = true;
public bool areCompatible(\list(Type typeLhs), \list(Type typeRhs)) = areCompatible(typeLhs, typeRhs);

public bool areCompatible(Expression lhs, Expression rhs) = false;
