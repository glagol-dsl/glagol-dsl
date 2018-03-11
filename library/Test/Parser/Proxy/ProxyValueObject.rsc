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

test bool shouldParseProxyValueObjectWithAMethodAndConstructor()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'value DateTime {
        '	 DateTime(string now);
        '    string format();
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", [
    	constructor([param(string(), "now", emptyExpr())], [\return(adaptable())], emptyExpr()),
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")));
}

test bool shouldParseProxyValueObjectWithAMethodAndConstructorWithAnnotations()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'value DateTime {
        '	 @test
        '	 DateTime(string now);
        '    @test
        '	 string format();
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], valueObject("DateTime", [
    	constructor([param(string(), "now", emptyExpr())], [\return(adaptable())], emptyExpr()),
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")));
}

test bool shouldFailWhenInvalidConstructorNameIsUsedOnProxy()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'value DateTime {
        '	 DateTimeImmutable(string now);
        '    string format();
        '}
        '";
    
    try parseModule(code);
    catch IllegalConstructorName(_, _): return true;
    
    return false;
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
