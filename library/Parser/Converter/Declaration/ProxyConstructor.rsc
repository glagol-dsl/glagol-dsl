module Parser::Converter::Declaration::ProxyConstructor

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Parameter;
import Parser::Converter::Expression;
import Parser::Converter::Statement;
import Parser::Converter::When;
import Parser::Converter::Type;

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<Annotation+ annotations><ProxyConstructor c>`, str proxyName, ParseEnv env) 
    = convertProxyConstructor(c, proxyName, env)[
    	@annotations = convertAnnotations(annotations, env)
    ][@src=a@\loc];

public Declaration convertProxyDeclaration(a: (ProxyDeclaration) `<ProxyConstructor c>`, str proxyName, ParseEnv env) = convertProxyConstructor(c, proxyName, env);

public Declaration convertProxyConstructor(
    a: (ProxyConstructor) `<ArtifactName name> (<{AbstractParameter ","}* parameters>);`, str proxyName, ParseEnv env) {
	
	if ("<name>" != proxyName) {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name", a@\loc);
	}
	
	return constructor([convertParameter(p, env) | p <- parameters], [\return(adaptable()[@src=a@\loc])[@src=a@\loc]], emptyExpr()[@src=a@\loc])[@src=a@\loc];    
}
