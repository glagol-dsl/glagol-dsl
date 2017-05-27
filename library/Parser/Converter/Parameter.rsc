module Parser::Converter::Parameter

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::Expression;
import Parser::Converter::DefaultValue;
import Parser::Converter::Annotation;

public list[Declaration] convertParameters((AbstractParameters) `(<{AbstractParameter ","}* parameters>)`, ParseEnv env) =
	[convertParameter(p, env) | p <- parameters];

public Declaration convertParameter((AbstractParameter) `<Parameter p>`, ParseEnv env) = convertParameter(p, env);
public Declaration convertParameter(a: (AbstractParameter) `<Annotation+ annotations><Parameter p>`, ParseEnv env)
    = convertParameter(p, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name>`, ParseEnv env) =
	param(convertType(paramType, env), "<name>", emptyExpr())[@src=a@\loc];

public Declaration convertParameter(a: (Parameter) `<Type paramType> <MemberName name> <AssignDefaultValue defaultValue>`, ParseEnv env)
    = param(convertType(paramType, env), "<name>", convertParameterDefaultVal(defaultValue, convertType(paramType, env), env))[@src=a@\loc];
