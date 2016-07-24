module Parser::Converter::Assignable

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertAssignable((Assignable) `<MemberName name>`) = variable("<name>");
public Expression convertAssignable((Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key));
public Expression convertAssignable((Assignable) `<Expression prev>.<MemberName field>`) 
    = fieldAccess(convertExpression(prev), "<field>");
