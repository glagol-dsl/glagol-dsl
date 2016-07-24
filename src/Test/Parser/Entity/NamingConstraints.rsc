module Test::Parser::Entity::NamingConstraints

import Parser::ParseAST;
import Syntax::Abstract::AST;

test bool moduleNameCannotUsePreservedKeywords()
{
    bool success = false;
    
    str failCode 
        = "module true;";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "module ThisIsOk_IGuess;";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool moduleArtifactImportsShouldStartWithCapital()
{
    bool success = false;
    
    str failCode 
        = "module Example;
          'import I18n::user;";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "module Example;
          'import I18n::User;
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool moduleArtifactImportsShouldNotContainUnderscores()
{
    bool success = false;
    
    str failCode 
        = "module Example;
          'import I18n::User_Entity;";
    
    try parseModule(failCode);
    catch e: success = true;
    
    str successCode 
        = "module Example;
          'import I18n::UserEntity;
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool artifactsShouldBeAlphabeticalStartingWithCapital()
{
    bool success = false;
    
    str failCodeLowerCaseFirst
        = "module Example;
          'entity user {
          '}
          '";
    
    try parseModule(failCodeLowerCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "module Example;
          'entity Underscored_Entity {
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "module Example;
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
        = "module Example;
          'entity User {
          '    value int MyValue with {get, set};
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "module Example;
          'entity User {
          '    value int my_Value with {get, set};
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "module Example;
          'entity User {
          '    value int myValue with {get, set};
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}

test bool entityRelationsShouldStartWithLowerCaseAndBeAlphaCharsOnly()
{
    bool success = false;
    
    str failCodeLowerCaseFirst
        = "module Example;
          'entity User {
          '    relation one:one language as userLanguage;
          '}
          '";
    
    try parseModule(failCodeLowerCaseFirst);
    catch e: success = true;
    
    str failCodeUpperCaseAlias 
        = "module Example;
          'entity User {
          '    relation one:one Language as UserLanguage;
          '}
          '";
    
    try {
        parseModule(failCodeUpperCaseAlias);
        success = false;
    } catch e: success = true;
    
    str failCodeUnderscore
        = "module Example;
          'entity User {
          '    relation one:one User_Language as userLanguage;
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str failCodeUnderscoreAlias 
        = "module Example;
          'entity User {
          '    relation one:one Language as user_language;
          '}
          '";
    
    try {
        parseModule(failCodeUnderscoreAlias);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "module Example;
          'entity User {
          '    relation one:one Language as userLanguage;
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
        = "module Example;
          'entity User {
          '    int BadFunctionName() = 4;
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "module Example;
          'entity User {
          '    string bad_FunctionName() = \"bad\";
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "module Example;
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
        = "module Example;
          'entity User {
          '    int badParameters(int BadExample) = 2;
          '}
          '";
    
    try parseModule(failCodeUpperCaseFirst);
    catch e: success = true;
    
    str failCodeUnderscore 
        = "module Example;
          'entity User {
          '    int badParameters(int bad_Example) = 2;
          '}
          '";
    
    try {
        parseModule(failCodeUnderscore);
        success = false;
    } catch e: success = true;
    
    str successCode 
        = "module Example;
          'entity User {
          '    bool goodParameters(int goodExample) = true;
          '}
          '";
    
    try parseModule(successCode);
    catch e: success = false;
    
    return success;
}
