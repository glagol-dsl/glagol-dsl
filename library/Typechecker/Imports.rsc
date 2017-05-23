module Typechecker::Imports

import Typechecker::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import IO;
import List;

public TypeEnv checkImports(list[Declaration] imports, TypeEnv env) = checkImports(imports, [], env);

public TypeEnv checkImports(list[Declaration] imports, list[str] imported, TypeEnv env) {
    if (size(imports) == 0) {
        return env;
    }

    if (<next: \import(GlagolID name, Declaration namespace, GlagolID as), list[Declaration] left> := pop(imports)) {
    	str hash = stringify(next);
        if (isImported(next, env) || hash in imported) {
            env = addError(env.location, "\"<name>\" has already been imported", env);
        } else if (isInAST(next, env)) {
            env.imported[as] = head(findArtifact(next, env));
            imported += hash;
        } else {
            env = addError(env.location, "<namespaceToString(namespace, "::")>::<name> is not defined", env);
        }
        
        return checkImports(left, imported, env);
    }
    
    return env;
}

private str stringify(\import(str artifactName, Declaration namespace, str as)) = namespaceToString(namespace, "+") + "+<artifactName>";
