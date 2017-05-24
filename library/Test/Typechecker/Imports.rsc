module Test::Typechecker::Imports

import Syntax::Abstract::Glagol;
import Typechecker::Imports;
import Typechecker::Env;

test bool checkImportsShouldReturnNoErrors() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))) == 
    
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService"),
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer"),
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity"), 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|)))));


test bool checkImportsShouldReturnAlreadyImportedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], 
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity"), 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|)))) == 
    
    addError(|tmp:///|, "\"User\" has already been imported",
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService"),
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer"),
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity"), 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))))));


test bool checkImportsShouldReturnAlreadyImportedErrorUsingAlias() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "User"),
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], addToAST([
    	file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))) == 
    
    addImported(\import("User", namespace("Test", namespace("Entity")), "User"),
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer"),
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService"), 
    addError(|tmp:///|, "\"User\" has already been imported", 
	    addToAST([
	    	file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
	        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
	        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
	    ], newEnv(|tmp:///|))))));

test bool checkImportsShouldReturnNotDefinedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity"),
        \import("Customer", namespace("Test", namespace("Entity")), "Customer"),
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")
    ], addToAST(file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), newEnv(|tmp:///|))) == 
    addErrors([<|tmp:///|, "Test::Entity::Customer is not defined">, <|tmp:///|, "Test::Service::CustomerService is not defined">],
	    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity"),
	    	addToAST(file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), newEnv(|tmp:///|)))
	);
