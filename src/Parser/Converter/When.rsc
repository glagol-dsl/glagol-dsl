module Parser::Converter::When

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);
