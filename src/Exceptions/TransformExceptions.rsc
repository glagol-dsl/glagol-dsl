module Exceptions::TransformExceptions

import Syntax::Abstract::Glagol;

data TransformException 
	= ArtifactNotImported(str msg, loc at)
	| ArtifactNotDefined(str msg, loc at)
	;
