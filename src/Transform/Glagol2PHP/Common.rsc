module Transform::Glagol2PHP::Common

import Syntax::Abstract::Glagol;

public str namespaceToString(namespace(str name), _) = name;
public str namespaceToString(namespace(str name, Declaration subNamespace), str delimiter) 
    = name + delimiter + namespaceToString(subNamespace, delimiter);
