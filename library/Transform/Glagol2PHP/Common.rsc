module Transform::Glagol2PHP::Common

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;

private str EXT = "php";
// TODO Check behaviour under windows
private str DS = "/";

public str makeFilename(Declaration namespace, entity(str name, _)) = 
	namespaceToDir(namespace) + name + ".<EXT>";

public str makeFilename(Declaration namespace, util(str name, _, Proxy pr)) = 
	namespaceToDir(namespace) + name + ".<EXT>";
	
public str makeFilename(Declaration namespace, valueObject(str name, _, notProxy())) = 
	namespaceToDir(namespace) + name + ".<EXT>";

public str makeFilename(Declaration namespace, repository(str name, _)) = 
	namespaceToDir(namespace) + name + "Repository.<EXT>";

public str makeFilename(Declaration namespace, controller(str name, _, _, _)) = 
	namespaceToDir(namespace) + name + ".<EXT>";

private str namespaceToDir(namespace(str name)) = name + DS;
private str namespaceToDir(namespace(str name, Declaration sub)) = name + DS + namespaceToDir(sub);
