module Test::Parser::Controller::Basics

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool controllerDeclaration() 
{
    str code 
        = "namespace Testing
        'json-api controller profile {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile")]), []));
}

test bool controllerDeclarationWithRouteVars() 
{
    str code 
        = "namespace Testing
        'json-api controller profile/:blahblah {}
        '";
        
    return parseModule(code) == \module(namespace("Testing"), [], controller(jsonApi(), route([routePart("profile"), routeVar("blahblah")]), []));
}

test bool controllerDeclarationShouldFailWhenRouteHasWhitespaces() 
{
    str code 
        = "namespace Testing
        'json-api controller profile /:blahblah {}
        '";
        
    try parseModule(code);
    catch e: return true;
    
    return false;
}

test bool controllerDeclarationShouldFailWhenRouteHasWhitespaces2() 
{
    str code 
        = "namespace Testing
        'json-api controller profile/: blahblah {}
        '";
        
    try parseModule(code);
    catch e: return true;
    
    return false;
}
