module Parser::Converter::Parameter

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::Expression;

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <ParameterDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue));

public Expression convertParameterDefaultVal((ParameterDefaultValue) `=<DefaultValue defaultValue>`)
    = convertExpression(defaultValue);
    
