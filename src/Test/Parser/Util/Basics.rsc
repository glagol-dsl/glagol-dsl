module Test::Parser::Util::Basics

import Syntax::Abstract::Glagol;
import Parser::ParseAST;

test bool shouldParseEmptyUtil()
{
    str code 
        = "namespace Test;
          'util UserCreator {}";
          
    return parseModule(code) == \module(namespace("Test"), [], util("UserCreator", []));
}

test bool shouldParseUtilUsingTheServiceKeyword()
{
    str code 
        = "namespace Test;
          'service UserCreator {}";
          
    return parseModule(code) == \module(namespace("Test"), [], util("UserCreator", []));
}
