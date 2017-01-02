module Test::Parser::Controller::Actions

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool parseControllerWithIndexActionWithoutParams() 
{
    str code 
        = "namespace Testing
        'json-api controller profile {
        '    index {}
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile")]), [
    	action("index", [], [])
    ]));
}


test bool parseControllerWithIndexActionWithParams() 
{
    str code 
        = "namespace Testing
        'json-api controller profile {
        '    index (int id) {}
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile")]), [
    	action("index", [param(integer(), "id")], [])
    ]));
}


test bool parseControllerWithIndexActionWithParamsAndStmts() 
{
    str code 
        = "namespace Testing
        'json-api controller profile {
        '    index (int id) {
        '        return new User(id);
        '    }
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile")]), [
    	action("index", [param(integer(), "id")], [
    		\return(new("User", [variable("id")]))
    	])
    ]));
}



test bool parseControllerWithIndexActionWithParamsAndStmtsUsingFunctionalStyle() 
{
    str code 
        = "namespace Testing
        'json-api controller profile {
        '    index (int id) = new User(id);
        '}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile")]), [
    	action("index", [param(integer(), "id")], [
    		\return(new("User", [variable("id")]))
    	])
    ]));
}

