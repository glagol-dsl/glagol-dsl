module Parser::Converter::Assignable

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;

public Expression convertAssignable((Assignable) `<MemberName name>`) = variable("<name>");
public Expression convertAssignable((Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key));
