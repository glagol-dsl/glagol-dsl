module Test::Parser::Entity::NamingConstraints

import Parser::ParseAST;
import Syntax::Abstract::Glagol;

test bool moduleNameCannotUsePreservedKeywords()
{
    bool success = false;
    
    str failCode 
        = "namespace true
        'entity Blah {}";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "namespace ThisIsOk_IGuess
        'entity Blah {}";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool moduleArtifactImportsShouldStartWithCapital()
{
    bool success = false;
    
    str failCode 
        = "namespace Example
          'import I18n::user;
          'entity Blah {}";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "namespace Example
          'import I18n::User;
          'entity Blah {}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool moduleArtifactImportsShouldNotContainUnderscores()
{
    bool success = false;
    
    str failCode 
        = "namespace Example
          'import I18n::User_Entity;
           'entity Blah {}";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "namespace Example
          'import I18n::UserEntity;
          'entity Blah {}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool artifactsShouldBeAlphabeticalStartingWithCapital()
{
    bool success = false;
    
    str failCodeLowerCaseFirst
        = "namespace Example
          'entity user {
          '}
          '";
    
    try parseModule(failCodeLowerCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "namespace Example
          'entity Underscored_Entity {
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "namespace Example
          'entity UserExampleEntity {
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool entityValuesShouldStartWithLowerCaseAndBeAlphaCharsOnly()
{
    bool success = false;
    
    str failCodeUpperCaseFirst
        = "namespace Example
          'entity User {
          '    int MyValue;
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "namespace Example
          'entity User {
          '    int my_Value;
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "namespace Example
          'entity User {
          '    int myValue;
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool methodsShouldStartWithLowerCaseAndBeAlphaCharsOnly()
{
    bool success = false;
    
    str failCodeUpperCaseFirst
        = "namespace Example
          'entity User {
          '    int BadFunctionName() = 4;
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "namespace Example
          'entity User {
          '    string bad_FunctionName() = \"bad\";
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "namespace Example
          'entity User {
          '    string goodFunctionName() = \"correct\";
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool parametersShouldStartWithLowerCaseAndBeAlphaCharsOnly()
{
    bool success = false;
    
    str failCodeUpperCaseFirst
        = "namespace Example
          'entity User {
          '    int badParameters(int BadExample) = 2;
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "namespace Example
          'entity User {
          '    int badParameters(int bad_Example) = 2;
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "namespace Example
          'entity User {
          '    bool goodParameters(int goodExample) = true;
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}
