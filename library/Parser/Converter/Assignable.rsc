module Parser::Converter::Assignable

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;
import Parser::Converter::Symbol;

public Expression convertAssignable(a: (Assignable) `<MemberName name>`, ParseEnv env) = variable("<name>")[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Assignable variable>[<Expression key>]`, ParseEnv env)
    = arrayAccess(convertAssignable(variable, env), convertExpression(key, env))[@src=a@\loc];
public Expression convertAssignable(a: (Assignable) `<Expression prev>.<MemberName field>`, ParseEnv env)
    = fieldAccess(convertExpression(prev, env), convertSymbol(field))[@src=a@\loc];
