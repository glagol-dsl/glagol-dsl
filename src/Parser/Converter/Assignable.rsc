module Parser::Converter::Assignable

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertAssignable(a: (Assignable) `<MemberName name>`) = variable("<name>")[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key))[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Expression prev>.<MemberName field>`) 
    = fieldAccess(convertExpression(prev), "<field>")[@src=a@\loc];
