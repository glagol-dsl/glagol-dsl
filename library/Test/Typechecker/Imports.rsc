module Test::Typechecker::Imports

import Syntax::Abstract::Glagol;
import Typechecker::Imports;
import Typechecker::Env;

test bool checkImportsShouldReturnNoErrors() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
    ], addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))) == 
    
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|)))));


test bool checkImportsShouldReturnAlreadyImportedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
    ], 
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|)))) == 
    
    addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot import User twice",
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addToAST([
        file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))))));


test bool checkImportsShouldReturnAlreadyImportedErrorUsingAlias() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
    ], addToAST([
    	file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
    ], newEnv(|tmp:///|))) == 
    
    addImported(\import("User", namespace("Test", namespace("Entity")), "User")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
    addImported(\import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)], 
    addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Cannot import User twice", 
	    addToAST([
	    	file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))),
	        file(|tmp:///Test/Entity/Customer.g|, \module(namespace("Test", namespace("Entity")), [], entity("Customer", []))),
	        file(|tmp:///Test/Service/CustomerService.g|, \module(namespace("Test", namespace("Service")), [], util("CustomerService", [])))
	    ], newEnv(|tmp:///|))))));

test bool checkImportsShouldReturnNotDefinedError() = 
    checkImports([
        \import("User", namespace("Test", namespace("Entity")), "UserEntity")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("Customer", namespace("Test", namespace("Entity")), "Customer")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)],
        \import("CustomerService", namespace("Test", namespace("Service")), "CustomerService")[@src=|tmp:///User.g|(0, 0, <20, 20>, <30, 30>)]
    ], addToAST(file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), newEnv(|tmp:///|))) == 
    addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Test::Service::CustomerService is not defined", 
    	addError(|tmp:///User.g|(0, 0, <20, 20>, <30, 30>), "Test::Entity::Customer is not defined", 
    		addImported(\import("User", namespace("Test", namespace("Entity")), "UserEntity"),
	    		addToAST(file(|tmp:///Test/Entity/User.g|, \module(namespace("Test", namespace("Entity")), [], entity("User", []))), newEnv(|tmp:///|)))
	));
