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

test bool shouldParseProxyValueObjectWithAMethod()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'value DateTime {
        '    string format();
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", [
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")));
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
