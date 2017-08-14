module Parser::Converter::When

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertWhen(w: (When) `when <Expression expr>`, ParseEnv env) = convertExpression(expr, env)[@src=w@\loc];
