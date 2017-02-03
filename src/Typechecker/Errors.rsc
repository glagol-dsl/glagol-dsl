module Typechecker::Errors

import Syntax::Abstract::Glagol;

public str notImported(a:artifact(GlagolID name)) = "\"<name>\" not imported, but used in <a@src.path> on line <a@src.begin.line>";
public str notImported(r:repository(GlagolID name)) = "\"<name>\" not imported, but used for a repository in <r@src.path> on line <r@src.begin.line>";
public str notImported(r:repository(GlagolID name, _)) = "Entity \"<name>\" not imported in <r@src.path>";