module Parser::Converter::DefaultValue

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Expression;

public Expression convertParameterDefaultVal((AssignDefaultValue) `=<DefaultValue defaultValue>`)
    = convertExpression(defaultValue);
    
