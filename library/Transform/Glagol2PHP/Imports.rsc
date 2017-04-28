module Transform::Glagol2PHP::Imports

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol::Helpers;
import Exceptions::TransformExceptions;
import Config::Config;

public list[PhpStmt] toPhpUses(m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact), list[Declaration] ast, env) =
    [phpUse(
        {toPhpUse(i) | i <- imports + extractImports(m, ast, env)}
    )];

private list[Declaration] extractImports(
	m: \module(Declaration ns, list[Declaration] imports, a: entity(_, list[Declaration] ds)), 
	list[Declaration] ast, 
	env: <f, doctrine()>) =
	    [\import("Mapping", namespace("Doctrine", namespace("ORM")), "ORM")] +
        [\import("JsonSerializeTrait", 
            namespace("Glagol", 
                namespace("Bridge", 
                    namespace("Laravel", 
                        namespace("Entity")))), "JsonSerializeTrait")] +
        [\import("HydrateTrait", 
            namespace("Glagol", 
                namespace("Helper", 
                    namespace("Entity"))), "HydrateTrait")] +
	    commonImports(m, ast, env);
    
private list[Declaration] extractImports(
    m: \module(Declaration ns, list[Declaration] imports, a: repository(_, list[Declaration] ds)), 
    list[Declaration] ast, 
    env: <f, doctrine()>) =
        [\import("EntityRepository", namespace("Doctrine", namespace("ORM")), "EntityRepository")] +
        commonImports(m, ast, env);
    
private list[Declaration] extractImports(
    m: \module(Declaration ns, list[Declaration] imports, a: controller(_, _, _, list[Declaration] declarations)), 
    list[Declaration] ast, 
    env: <laravel(), orm>) =
        [\import("Controller", 
            namespace("Glagol", 
                namespace("Bridge", 
                    namespace("Laravel", 
                        namespace("Http", 
                            namespace("Controllers"))))), "AbstractController")] +
        commonImports(m, ast, env);

private default list[Declaration] extractImports(Declaration \module, list[Declaration] ast, env) = commonImports(\module, ast, env);

private list[Declaration] commonImports(
	m: \module(Declaration ns, list[Declaration] imports, Declaration artifact), 
	list[Declaration] ast, 
	env) =
	    (hasOverriding(artifact.declarations) ? 
	        [
	        	\import("Overrider", namespace("Glagol", namespace("Overriding")), "Overrider"),
	        	\import("Parameter", namespace("Glagol", namespace("Overriding")), "Parameter")
	        ] : []) +
	    (hasMapUsage(artifact) ? 
	        [
                \import("Map", namespace("Ds"), "Map"), 
                \import("Pair", namespace("Ds"), "Pair"), 
    	        \import("MapFactory", namespace("Glagol", namespace("Ds")), "MapFactory")
	        ] : []) +
	    (hasListUsage(artifact) ? 
	        [\import("Vector", namespace("Ds"), "Vector")] : []) +
	    [i | i <- findRepositoryDependencies(m, ast)]
	    ;

private list[Declaration] findRepositoryDependencies(\module(Declaration ns, list[Declaration] imports, Declaration artifact), list[Declaration] ast) {
	
	list[Declaration] repoImports = [];

	top-down visit (artifact) {
		case r: repository(str name): {
			if (!isImported(name, imports)) {
				// TODO specify location
				throw ArtifactNotImported("Entity by the name of \'<name>\' is not imported", (r@src?) ? r@src : |tmp:///|);
			}
			
			bool repositoryFound = false;
			Declaration importEntity;
			
			if ([L*, i: \import(str iName, Declaration iNs, name), R*] := imports) {
				top-down visit (ast) {
					case \module(Declaration rNs, [*LI, \import(iName, iNs, str rAs), RI*], repository(rAs, list[Declaration] rDs)): {
						repoImports += \import("<iName>Repository", rNs, "<iName>Repository");
						repositoryFound = true;
					}
				}
				importEntity = i;
			}
			
			if (!repositoryFound) {
				throw ArtifactNotDefined("Repository for \'<toString(importEntity)>\' not defined", (r@src?) ? r@src : |tmp:///|);
			}
		}
	}
	
	return repoImports;
}

private str toString(\import(str name, Declaration namespace, _)) = "<toString(namespace)>::<name>";
private str toString(namespace(str name)) = "<name>";
private str toString(namespace(str name, Declaration namespace)) = "<name>::<toString(namespace)>";

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as)) = 
	phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpSomeName(phpName(as)))
    when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as)) = 
	phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), phpNoName()) 
	when as == artifactName;
