module Exceptions::TransformExceptions

import Syntax::Abstract::Glagol;

data TransformException 
	= ArtifactNotImported(str msg, loc location)
	| ArtifactNotDefined(str msg, loc location)
	;
