module Transform::Glagol2PHP::Imports

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol::Helpers;
import Exceptions::TransformExceptions;
import Config::Config;
import Transform::Env;
import Transform::OriginAnnotator;

public list[PhpStmt] toPhpUses(m: \module(Declaration namespace, list[Declaration] imports, Declaration artifact), list[Declaration] ast, TransformEnv env) =
    [origin(phpUse(
        {origin(toPhpUse(i, env), i) | i <- imports + extractImports(m, ast, env)}
    ), namespace)];

private list[Declaration] extractImports(
	m: \module(Declaration ns, list[Declaration] imports, a: entity(_, list[Declaration] ds)), 
	list[Declaration] ast, 
	TransformEnv env) =
	    [\import("Mapping", namespace("Doctrine", namespace("ORM")), "ORM")] +
        [\import("JsonSerializeTrait", 
            namespace("Glagol", 
                namespace("Bridge", 
                    namespace("Lumen",
                        namespace("Entity")))), "JsonSerializeTrait")] +
	    commonImports(m, ast, env) when usesDoctrine(env);
    
private list[Declaration] extractImports(
    m: \module(Declaration ns, list[Declaration] imports, a: repository(_, list[Declaration] ds)), 
    list[Declaration] ast, 
    TransformEnv env) =
        [\import("EntityRepository", namespace("Glagol", namespace("Bridge", namespace("Lumen", namespace("Entity")))), "EntityRepository")] +
        commonImports(m, ast, env) when usesDoctrine(env);
    
private list[Declaration] extractImports(
    m: \module(Declaration ns, list[Declaration] imports, a: controller(_, _, _, list[Declaration] declarations)), 
    list[Declaration] ast, 
    TransformEnv env) =
        [\import("Controller", 
            namespace("Glagol", 
                namespace("Bridge", 
                    namespace("Lumen",
                        namespace("Http", 
                            namespace("Controllers"))))), "AbstractController")] +
        commonImports(m, ast, env) when usesLumen(env);

private default list[Declaration] extractImports(Declaration \module, list[Declaration] ast, env) = commonImports(\module, ast, env);

private list[Declaration] commonImports(
	m: \module(Declaration ns, list[Declaration] imports, Declaration artifact), 
	list[Declaration] ast, 
	TransformEnv env) =
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
		case r: repository(Name n): {
			str name = n.localName;
			Declaration importEntity;
			
			if ([L*, i: \import(str iName, Declaration iNs, name), R*] := imports) {
				top-down visit (ast) {
					case \module(Declaration rNs, [*LI, \import(iName, iNs, str rAs), RI*], repository(rAs, list[Declaration] rDs)): {
						repoImports += \import("<iName>Repository", rNs, "<iName>Repository");
					}
					case \module(iNs, _, repository(iName, _)): {
						repoImports += \import("<iName>Repository", iNs, "<iName>Repository");
					}
				}
			}
		}
	}
	
	return repoImports;
}

private str toString(\import(str name, Declaration namespace, _)) = "<toString(namespace)>::<name>";
private str toString(namespace(str name)) = "<name>";
private str toString(namespace(str name, Declaration namespace)) = "<name>::<toString(namespace)>";

private str toString(proxyClass(str class)) = class;

private PhpUse toPhpUse(i: \import(str artifactName, Declaration namespace, str as), TransformEnv env) =
	phpUse(phpName(toString(getProxyClass(i, env))), phpSomeName(phpName(as)))
	when isProxy(i, env);

private default PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as), TransformEnv env) = 
	phpUse(phpName(namespaceToString(namespace, "\\") + "\\" + artifactName), toPhpAlias(as, artifactName));

private PhpOptionName toPhpAlias(str as, str artifactName) = phpSomeName(phpName(as)) when as != artifactName;
private PhpOptionName toPhpAlias(str as, str artifactName) = phpNoName() when as == artifactName;
