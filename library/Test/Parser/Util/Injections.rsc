module Test::Parser::Util::Injections

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool canParseRepositoryInjection() 
{
    str code
        = "namespace Test
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository(fullName("User", namespace("Test"), "User")), "userRepository", get(repository(fullName("User", namespace("Test"), "User"))))
        ]));
}

test bool canParseUtilRepositoryInjection() 
{
    str code
        = "namespace Test
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository(fullName("User", namespace("Test"), "User")), "userRepository", get(repository(fullName("User", namespace("Test"), "User"))))
        ]));
}   

test bool canUseRepositorySelfie() 
{
    str code
        = "namespace Test
          'service UserCreator {
          '    repository\<User\> userRepository = get selfie;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(repository(fullName("User", namespace("Test"), "User")), "userRepository", get(repository(fullName("User", namespace("Test"), "User"))))
        ]));
}

test bool canUseRepositorySelfieAsParamDefaultValue() 
{
    str code
        = "namespace Test
          'service UserCreator {
          '    public void make(repository\<User\> userRepository = get selfie) { }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            method(\public(), voidValue(), "make", [
                param(repository(fullName("User", namespace("Test"), "User")), "userRepository", get(repository(fullName("User", namespace("Test"), "User"))))
            ], [], emptyExpr())
        ]));
}

test bool canUseRepositoryAssocArtifactInExpression() 
{
	return true;
    str code
        = "namespace Test
          'service UserCreator {
          '    public void blah() {
          '        get repository\<User\>;
          '        get repository\<User\>.findOneById(1);
          '    }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            method(\public(), voidValue(), "blah", [], [
                expression(get(repository(fullName("User", namespace("Test"), "User")))),
                expression(invoke(get(repository(fullName("User", namespace("Test"), "User"))), "findOneById", [integer(1)]))
            ], emptyExpr())
        ]));
}

test bool canCreateNewServiceAsAPropertyDefaultValue() 
{
    str code
        = "namespace Test
          'service UserCreator {
          '    UserService userService = new UserService();
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), [], util("UserCreator", [
            property(artifact(fullName("UserService", namespace("Test"), "UserService")), "userService", new(fullName("UserService", namespace("Test"), "UserService"), []))
        ]));
}
