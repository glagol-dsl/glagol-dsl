module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

extend Transform::Glagol2PHP::Doctrine::Annotations;

private str NS_DL = "\\";
private str ORM_AS = "ORM";

public PhpScript toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = phpScript([toPhpStmt(namespace, imports, artifact)]) 
    when entity(_, _) := artifact || annotated(_, entity(_, _)) := artifact;

private PhpStmt toPhpStmt(Declaration namespace, set[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, NS_DL))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName(ORM_AS)))}
        )] + [toPhpStmt(artifact)]
    );

// imports
private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpSomeName(phpName(as))) when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpNoName()) when as == artifactName;

// annotated declarations
private PhpStmt toPhpStmt(annotated(set[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpStmt(artifact), annotations);

// entities
private PhpStmt toPhpStmt(entity(str name, set[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations])[
        @phpAnnotations={phpAnnotation("Entity")}
    ]);

private PhpClassItem toPhpClassItem(annotated(set[Annotation] annotations, Declaration declaration))
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration), annotations);

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())]);

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _, Expression defaultValue)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))]);
