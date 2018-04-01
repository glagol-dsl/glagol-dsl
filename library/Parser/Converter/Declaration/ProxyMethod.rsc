module Parser::Converter::Declaration::ProxyMethod

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<Annotation+ annotations><ProxyMethod m>`, str proxyName, ParseEnv env) 
    = convertProxyMethod(m, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<ProxyMethod m>`, str proxyName, ParseEnv env) = convertProxyMethod(m, env);

public Declaration convertProxyMethod(
    a: (ProxyMethod) `<Type returnType><MemberName name> (<{AbstractParameter ","}* parameters>);`, ParseEnv env) 
    = method(\public()[@src=a@\loc], convertType(returnType, env), stringify(name), 
    	[convertParameter(p, env) | p <- parameters], [\return(adaptable()[@src=a@\loc])[@src=a@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];


