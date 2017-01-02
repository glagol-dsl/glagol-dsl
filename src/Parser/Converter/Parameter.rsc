module Parser::Converter::Parameter

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::Expression;
import Parser::Converter::DefaultValue;
import Parser::Converter::Annotation;

public Declaration convertParameter((AbstractParameter) `<Parameter p>`) = convertParameter(p);
public Declaration convertParameter(a: (AbstractParameter) `<Annotation+ annotations><Parameter p>`) 
    = convertParameter(p)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name>`) = 
	param(convertType(paramType), "<name>")[@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType)))[@src=a@\loc];
