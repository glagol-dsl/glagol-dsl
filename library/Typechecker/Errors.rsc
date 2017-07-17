module Typechecker::Errors

import Typechecker::Type;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

public str notImported(a:artifact(Name name)) = "\"<name.localName>\" not imported, but used";
public str notImported(r:repository(Name name)) = "\"<name.localName>\" not imported, but used for a repository";
public str notImported(r:repository(GlagolID name, _)) = "Entity \"<name>\" not imported";
public str notEntity(r:repository(GlagolID name, _)) = "\"<name>\" is not an entity";
public str notEntity(r:repository(Name name)) = "\"<name.localName>\" is not an entity";
public str notAllowed(Expression expr) = "This type of expression is not allowed";

public str typeMismatch(Type expected, Type actual) = 
    "Expected <toString(expected)>, but got <toString(actual)>";
