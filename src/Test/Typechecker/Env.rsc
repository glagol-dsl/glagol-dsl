module Test::Typechecker::Env

import Syntax::Abstract::Glagol;
import Typechecker::Env;

test bool shouldReturnTrueIfArtifactIsAlreadyImported() =
    isImported(\import("User", namespace("Test"), "User"), <|tmp:///|, (), ("User": \import("User", namespace("Test"), "User")), [], []>);
    
test bool shouldReturnTrueIfArtifactIsAlreadyImportedUsingAlias() =
    isImported(\import("User", namespace("Test"), "UserEntity"), <|tmp:///|, (), ("User": \import("User", namespace("Test"), "User")), [], []>);

test bool shouldReturnFalseIfArtifactIsNotImported() =
    !isImported(\import("User", namespace("Test"), "User"), <|tmp:///|, (), (), [], []>);

test bool shouldReturnTrueWhenArtifactIsInAST() = 
    isInAST(\import("User", namespace("Test"), "User"), <|tmp:///|, (), (), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", [])))
    ], []>);

test bool shouldReturnFalseWhenArtifactIsNotInAST() = 
    !isInAST(\import("UserBla", namespace("Test"), "User"), <|tmp:///|, (), (), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", [])))
    ], []>);

test bool shouldReturnFalseWhenArtifactHasDifferentNSInAST() = 
    !isInAST(\import("User", namespace("Testing"), "User"), <|tmp:///|, (), (), [
        file(|tmp:///Test/User.g|, \module(namespace("Test"), [], entity("User", [])))
    ], []>);

test bool shouldGiveErrorWhenAddingAlreadyDefinedPropertyToDefinitions() = 
    addDefinition(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <25, 25>, <30, 30>)], <|tmp:///User.g|, (
            "id": field(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], []>) == 
    <|tmp:///User.g|, (
        "id": field(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], [
        <|tmp:///User.g|(0, 0, <25, 25>, <30, 30>), 
            "Cannot redefine \"id\". Property with the same name already defined in /User.g on line 20.">
    ]>;

test bool shouldAddErrorToEnv() = addError(|tmp:///User.g|, "this is an error message", <|tmp:///User.g|, (), (), [], []>) == <|tmp:///User.g|, (), (), [], [
    <|tmp:///User.g|, "this is an error message">
]>;

test bool shouldNotGiveErrorWhenAddingNonDefinedPropertyToDefinitions() = 
    addDefinition(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], <|tmp:///User.g|, (), (), [], []>) == 
    <|tmp:///User.g|, (
        "id": field(property(integer(), "id", {}, emptyExpr())[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)])
    ), (), [], []>;
