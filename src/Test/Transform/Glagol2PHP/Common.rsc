module Test::Transform::Glagol2PHP::Common

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;

test bool shouldMakeStringFromNamespaceChainUsingDelimiter() 
    = "Some::Example::Namespace" == namespaceToString(namespace("Some", namespace("Example", namespace("Namespace"))), "::");

test bool shouldMakeStringFromNamespaceChainUsingAltDelimiter() 
    = "Another\\Example\\Namespace" == namespaceToString(namespace("Another", namespace("Example", namespace("Namespace"))), "\\");
