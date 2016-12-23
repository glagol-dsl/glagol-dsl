module Test::Parser::Util::Injections

import Parser::ParseAST;
import Syntax::Abstract::Glagol;
import IO;

test bool canParseRepositoryInjection() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository("User"), "userRepository", {}, get(repository("User")))
        ]));
}

test bool canParseUtilRepositoryInjection() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository("User"), "userRepository", {}, get(repository("User")))
        ]));
}   

test bool canUseRepositorySelfie() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get selfie;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository("User"), "userRepository", {}, get(repository("User")))
        ]));
}

test bool canUseRepositorySelfieAsParamDefaultValue() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    public void make(repository\<User\> userRepository = get selfie) { }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            method(\public(), voidValue(), "make", [
                param(repository("User"), "userRepository", get(repository("User")))
            ], [])
        ]));
}

test bool canUseRepositoryAssocArtifactInExpression() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    UserCreator() {
          '        get repository\<User\>;
          '        get repository\<User\>.findOneById(1);
          '    }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            constructor([], [
                expression(get(repository("User"))),
                expression(invoke(get(repository("User")), "findOneById", [integer(1)]))
            ])
        ]));
}

test bool canCreateNewServiceAsAPropertyDefaultValue() 
{
    str code
        = "namespace Test;
          'service UserCreator {
          '    UserService userService = new UserService();
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(artifact("UserService"), "userService", {}, new("UserService", []))
        ]));
}
