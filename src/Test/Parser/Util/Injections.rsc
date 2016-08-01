module Test::Parser::Util::Injections

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool canParseRepositoryInjection() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    inject repository\<User\> as userRepository;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            inject(assocRepository("User"), "userRepository")
        }));
}

test bool canParseRepositoryInjection() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    inject repository\<User\> as userRepository;
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            inject(assocRepository("User"), "userRepository")
        }));
}

test bool canUseRepositoryAssocArtifactInExpression() 
{
    str code
        = "module Test;
          'service UserCreator {
          '    UserCreator() {
          '        repository\<User\>;
          '        repository\<User\>.findOneById(1);
          '    }
          '}";
    
    return parseModule(code) ==
        \module(namespace("Test"), {}, util("UserCreator", {
            constructor([], [
                expression(assocArtifact(assocRepository("User"))),
                expression(invoke(assocArtifact(assocRepository("User")), "findOneById", [intLiteral(1)]))
            ])
        }));
}
