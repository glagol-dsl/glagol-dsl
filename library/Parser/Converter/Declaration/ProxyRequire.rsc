module Parser::Converter::Declaration::ProxyRequire

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<Annotation+ annotations><ProxyRequire r>`, str proxyName, ParseEnv env) 
    = convertProxyMethod(r, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<ProxyRequire r>`, str proxyName, ParseEnv env) = convertProxyRequire(r, env);

public Declaration convertProxyRequire(
    a: (ProxyRequire) `require<StringQuoted package><StringQuoted version>;`, ParseEnv env) 
    = require(convertStringQuoted(package), convertStringQuoted(version))[@src=a@\loc];
	
