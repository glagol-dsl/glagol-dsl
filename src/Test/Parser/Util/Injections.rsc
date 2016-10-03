module Test::Parser::Util::Injections

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool canParseRepositoryInjection() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            property(repositoryType("User"), "userRepository", {}, get(repositoryType("User")))
        }));
}

test bool canParseRepositoryInjection() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get repository\<User\>;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            property(repositoryType("User"), "userRepository", {}, get(repositoryType("User")))
        }));
}   

test bool canUseRepositorySelfie() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    repository\<User\> userRepository = get selfie;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            property(repositoryType("User"), "userRepository", {}, get(repositoryType("User")))
        }));
}

test bool canUseRepositorySelfieAsParamDefaultValue() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    public void make(repository\<User\> userRepository = get selfie) { }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            method(\public(), voidValue(), "make", [
                param(repositoryType("User"), "userRepository", get(repositoryType("User")))
            ], [])
        }));
}

test bool canUseRepositoryAssocArtifactInExpression() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    UserCreator() {
          '        get repository\<User\>;
          '        get repository\<User\>.findOneById(1);
          '    }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            constructor([], [
                expression(get(repositoryType("User"))),
                expression(invoke(get(repositoryType("User")), "findOneById", [intLiteral(1)]))
            ])
        }));
}
