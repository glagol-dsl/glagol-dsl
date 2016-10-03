module Parser::Converter::Parameter

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::Expression;
import Parser::Converter::DefaultValue;

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType)));
