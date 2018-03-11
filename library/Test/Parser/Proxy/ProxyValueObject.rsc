module Test::Parser::Proxy::ProxyValueObject

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import Exceptions::ParserExceptions;

test bool shouldParseEmptyProxyValueObject()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'value DateTime {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", [], proxyClass("\\DateTimeImmutable")));
}

test bool shouldParseEmptyProxyIlluminateHttpRequestValueObject()
{
    str code 
        = "namespace Testing
        'proxy \\Illuminate\\Http\\Request as
        'value Request {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("Request", [], proxyClass("\\Illuminate\\Http\\Request")));
}

test bool shouldThrowExceptionWhenParsingProxiedEntity()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'entity DateTime {}
        '";
        
    try {
    	parseModule(code);
	} catch ProxyNotAllowed(str msg, loc l): {
    	return true;
    }
        
    return false;
}


