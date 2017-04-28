module Typechecker::Imports

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import List;

public TypeEnv checkImports(list[Declaration] imports, TypeEnv env) {
    if (size(imports) == 0) {
        return env;
    }
    
    if (<next: \import(GlagolID name, Declaration namespace, GlagolID as), list[Declaration] left> := pop(imports)) {
        if (isImported(next, env)) {
            env = addError(env.location, "\"<name>\" has already been imported", env);
        } else if (isInAST(next, env)) {
            env.imported[as] = next;
        } else {
            env = addError(env.location, "<namespaceToString(namespace, "::")>::<name> is not defined", env);
        }
        
        return checkImports(left, env);
    }
    
    return env;
}
