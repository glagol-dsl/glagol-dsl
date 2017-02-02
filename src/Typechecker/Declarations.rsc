module Typechecker::Declarations

import Typechecker::Env;
import Typechecker::Property;
import Syntax::Abstract::Glagol;

public TypeEnv checkDeclarations(list[Declaration] declarations, entity(GlagolID name, _), TypeEnv env) {
    for (declaration <- declarations) {
        switch (declaration) {
            case property(_, _, _, _): env = addDefinition(declaration, checkProperty(declaration, env));
        }
    }
    
    return env;
}

public TypeEnv checkDeclarations(list[Declaration] declarations, util(GlagolID name, _), TypeEnv env) = env;
public TypeEnv checkDeclarations(list[Declaration] declarations, valueObject(GlagolID name, _), TypeEnv env) = env;
public TypeEnv checkDeclarations(list[Declaration] declarations, repository(GlagolID name, _), TypeEnv env) = env;
public TypeEnv checkDeclarations(list[Declaration] declarations, controller(_, _, _, _), TypeEnv env) = env;
