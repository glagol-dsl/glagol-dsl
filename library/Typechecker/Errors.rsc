module Typechecker::Errors

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;

private str toString(integer()) = "integer";
private str toString(float()) = "float";
private str toString(string()) = "string";
private str toString(voidValue()) = "void";
private str toString(boolean()) = "bool";
private str toString(\list(Type \type)) = "list of <toString(\type)>";
private str toString(artifact(Name name)) = "a <name.localName>";
private str toString(repository(Name name)) = "a <name.localName> repository";
private str toString(\map(Type key, Type v)) = "map (<toString(key)>: <toString(v)>)";
private str toString(selfie()) = "a selfie";
private str toString(unknownType()) = "an unknown type";

public str notImported(a:artifact(Name name)) = "\"<name.localName>\" not imported, but used in <a@src.path> on line <a@src.begin.line>";
public str notImported(r:repository(Name name)) = "\"<name.localName>\" not imported, but used for a repository in <r@src.path> on line <r@src.begin.line>";
public str notImported(r:repository(GlagolID name, _)) = "Entity \"<name>\" not imported in <r@src.path>";
public str notEntity(r:repository(GlagolID name, _)) = "\"<name>\" is not an entity in <r@src.path> on line <r@src.begin.line>";
public str notEntity(r:repository(Name name)) = "\"<name.localName>\" is not an entity in <r@src.path> on line <r@src.begin.line>";
public str notAllowed(Expression expr) = "This type of expression is not allowed in <expr@src.path> on line <expr@src.begin.line>";

public str typeMismatch(Type expected, Type actual) = 
    "Expected <toString(expected)>, but got <toString(actual)> on line <expected@src.begin.line>";
