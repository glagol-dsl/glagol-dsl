module Parser::Converter::Name

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Env;

public Name createName(str localName, ParseEnv env) = createName(localName, getImported(localName, env)) when isImported(localName, env);
public Name createName(str localName, ParseEnv env) = local(localName) when !isImported(localName, env);
public Name createName(str localName, \import(GlagolID originalName, Declaration namespace, _)) = external(localName, namespace, originalName);

