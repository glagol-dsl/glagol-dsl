module Test::Compiler::Composer::Dependencies::ORM

import Compiler::Composer::Dependencies::ORM;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;

test bool shouldReturnDoctrineSpecificDependencies() = 
    getORMDependencies(doctrine()) == ();
    
test bool shouldReturnAnyORMDependencies() = 
    getORMDependencies(anyORM()) == ();
