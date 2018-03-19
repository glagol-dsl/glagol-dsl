module Test::Parser::Proxy::ProxyRequire

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import Exceptions::ParserExceptions;

test bool shouldParseProxyWithRequire()
{
    str code 
        = "namespace Testing
        'proxy \\DateTimeImmutable as
        'util DateTime {
        '	require \"glagol/dates\" \"3.0\";
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], util("DateTime", [
    	require("glagol/dates", "3.0")
    ], proxyClass("\\DateTimeImmutable")));
}
