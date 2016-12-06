module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Doctrine::Annotations;
import Transform::Glagol2PHP::Doctrine::Relations;
import Transform::Glagol2PHP::Utils;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;
import IO;

public map[str, PhpScript] toPHPScript(<Framework f, doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpNamespace(namespace, imports, artifact)]));

private PhpStmt toPhpNamespace(Declaration namespace, list[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + 
            (isEntity(artifact) ? {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))} : {})
        )] + [toPhpClassDef(artifact)]
    );
    
private PhpStmt toPhpClassDef(annotated(list[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpClassDef(artifact), annotations);
    
@doc="Convert entity to a PHP class"
private PhpStmt toPhpClassDef(entity(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], toPhpClassItems(declarations))[
        @phpAnnotations={phpAnnotation("ORM\\Entity")}
    ]);

@doc="Will apply annotations to all php class items that were converted from Glagol in-artefact declarations"
private PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration))
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration), annotations);
