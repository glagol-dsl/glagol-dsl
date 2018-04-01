module Test::Parser::Proxy::ProxyUtil

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import Exceptions::ParserExceptions;

test bool shouldParseEmptyProxyUtil()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'util DateTime {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], util("DateTime", [], proxyClass("\\DateTimeImmutable")));
}

test bool shouldParseProxyUtilWithAMethodAndConstructor()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'util DateTime {
        '	 DateTime(string now);
        '    string format();
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], util("DateTime", [
    	constructor([param(string(), "now", emptyExpr())], [\return(adaptable())], emptyExpr()),
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")));
}

test bool shouldParseProxyUtilWithAMethodAndConstructorWithAnnotations()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'util DateTime {
        '	 @test
        '	 DateTime(string now);
        '    @test
        '	 string format();
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], util("DateTime", [
    	constructor([param(string(), "now", emptyExpr())], [\return(adaptable())], emptyExpr()),
    	method(\public(), string(), "format", [], [\return(adaptable())], emptyExpr())
    ], proxyClass("\\DateTimeImmutable")));
}

test bool shouldParseEmptyProxyIlluminateHttpRequestUtil()
{
    str code 
        = "namespace Testing
        'proxy \\Illuminate\\Http\\Request as
        'service Request {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], util("Request", [], proxyClass("\\Illuminate\\Http\\Request")));
}
