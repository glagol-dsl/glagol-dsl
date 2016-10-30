module Transform::Glagol2PHP::Statements

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Expressions;
import Transform::Glagol2PHP::Doctrine::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;
import IO;

public PhpStmt toPhpStmt(annotated(list[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpStmt(artifact), annotations);

@doc="Will apply annotations to all php class items that were converted from Glagol in-artefact declarations"
public PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration))
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration), annotations);

public PhpStmt toPhpStmt(ifThen(Expression when, Statement body)) = phpIf(toPhpExpr(when), [toPhpStmt(body)], [], phpNoElse());

public PhpStmt toPhpStmt(block(list[Statement] body)) = phpBlock([toPhpStmt(stmt) | stmt <- body]);
