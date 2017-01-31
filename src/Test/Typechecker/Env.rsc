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
