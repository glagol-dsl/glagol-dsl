module Transform::Glagol2PHP::Common

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

private str EXT = "php";
// TODO Check behaviour under windows
private str DS = "/";

public str namespaceToString(namespace(str name), _) = name;
public str namespaceToString(namespace(str name, Declaration subNamespace), str delimiter) = 
	name + delimiter + namespaceToString(subNamespace, delimiter);

public str makeFilename(Declaration namespace, entity(str name, _)) = 
	namespaceToDir(namespace) + name + ".<EXT>";

public str makeFilename(Declaration namespace, util(str name, _)) = 
	namespaceToDir(namespace) + name + ".<EXT>";
	
public str makeFilename(Declaration namespace, valueObject(str name, _)) = 
	namespaceToDir(namespace) + name + ".<EXT>";

public str makeFilename(Declaration namespace, repository(str name, _)) = 
	namespaceToDir(namespace) + name + "Repository.<EXT>";

public str makeFilename(Declaration namespace, annotated(_, Declaration d)) = makeFilename(namespace, d);

private str namespaceToDir(namespace(str name)) = name + DS;
private str namespaceToDir(namespace(str name, Declaration sub)) = name + DS + namespaceToDir(sub);
