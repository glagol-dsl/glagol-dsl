module Transform::Glagol2PHP::Statements

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Statements;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;
import IO;

extend Transform::Glagol2PHP::Doctrine::Annotations;

@doc="Will attach php annotations to all annotated Glagol declarations"
public PhpStmt toPhpStmt(annotated(list[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpStmt(artifact), annotations);

@doc="Will apply annotations to all php class items that were converted from Glagol in-artefact declarations"
public PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration))
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration), annotations);
