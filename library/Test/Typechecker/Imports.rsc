module Test::Typechecker::Imports

import Syntax::Abstract::Glagol;
import Typechecker::Imports;
import Typechecker::Env;

test bool checkImportsShouldReturnNoErrors() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], <|tmp:///|, (), (), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], []>) == 
    <|tmp:///|, (), (
        "UserEntity": \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        "Customer": \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        "CustomerService": \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], []>;


test bool checkImportsShouldReturnAlreadyImportedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], <|tmp:///|, (), (
        "UserEntity": \import("User", namespace("Test", namespace("Entity")), "UserEntity")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], []>) == 
    <|tmp:///|, (), (
        "UserEntity": \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        "Customer": \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        "CustomerService": \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], [
        <|tmp:///|, "\"User\" has already been imported">
    ]>;


test bool checkImportsShouldReturnAlreadyImportedErrorUsingAlias() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], <|tmp:///|, (), (
        "User": \import("User", namespace("Test", namespace("Entity")), "User")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], []>) == 
    <|tmp:///|, (), (
        "User": \import("User", namespace("Test", namespace("Entity")), "User"),
        "Customer": \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        "CustomerService": \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], [
        <|tmp:///|, "\"User\" has already been imported">
    ]>;

test bool checkImportsShouldReturnNotDefinedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], <|tmp:///|, (), (), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", [])))
    ], []>) == 
    <|tmp:///|, (), (
        "UserEntity": \import("User", namespace("Test", namespace("Entity")), "UserEntity")
    ), [
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", [])))
    ], [
        <|tmp:///|, "Test::Entity::Customer is not defined">,
        <|tmp:///|, "Test::Service::CustomerService is not defined">
    ]>;
    