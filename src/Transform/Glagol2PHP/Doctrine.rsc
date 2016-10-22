module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Properties;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

extend Transform::Glagol2PHP::Doctrine::Annotations;

public map[str, PhpScript] toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpStmt(namespace, imports, artifact)])) 
    when entity(_, _) := artifact || annotated(_, entity(_, _)) := artifact;

private PhpStmt toPhpStmt(Declaration namespace, list[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))}
        )] + [toPhpStmt(artifact)]
    );

@doc="Will attach php annotations to all annotated Glagol declarations"
private PhpStmt toPhpStmt(annotated(list[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpStmt(artifact), annotations);

@doc="Convert entity to a PHP class"
private PhpStmt toPhpStmt(entity(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations])[
        @phpAnnotations={phpAnnotation("ORM\\Entity")}
    ]);

@doc="Will apply annotations to all php class items that were converted from Glagol in-artefact declarations"
private PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration))
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration), annotations);
