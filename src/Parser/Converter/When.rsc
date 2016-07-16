module Parser::Converter::When

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);
