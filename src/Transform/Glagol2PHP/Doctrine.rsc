module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

private str NS_DL = "\\";

public PhpScript toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = phpScript([toPhpStmt(namespace, imports, artifact)]) 
    when entity(_, _) := artifact || annotated(_, entity(_, _)) := artifact;

private PhpStmt toPhpStmt(Declaration namespace, set[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, NS_DL))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))}
        )] + [toPhpStmt(artifact)]
    );

// imports
private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpSomeName(phpName(as))) when as != artifactName;

private PhpUse toPhpUse(\import(str artifactName, Declaration namespace, str as))
    = phpUse(phpName(namespaceToString(namespace, NS_DL) + NS_DL + artifactName), phpNoName()) when as == artifactName;

// annotated declarations
private PhpStmt toPhpStmt(annotated(set[Annotation] annotations, Declaration artifact)) = toPhpStmt(artifact, annotations);

private set[PhpAnnotation] toDoctrineAnnotations(set[Annotation] annotations)
    = {toDoctrineAnnotation(a) | a <- annotations};

private PhpAnnotation toDoctrineAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toDoctrineAnnotationKey(annotationName)) when size(arguments) == 0;

private PhpAnnotation toDoctrineAnnotation(annotation(str annotationName, list[Annotation] arguments))
    = phpAnnotation(toDoctrineAnnotationKey(annotationName), toDoctrineAnnotationArgs(arguments, annotationName)) 
    when size(arguments) > 0;

private map[str,value] toDoctrineAnnotationArgs(list[Annotation] arguments, "table")
    = ("name": arguments[0]);

private str toDoctrineAnnotationKey("table") = "Table";

// entities
private PhpStmt toPhpStmt(entity(str name, set[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations])[
        @phpAnnotations={phpAnnotation("Entity")}
    ]);
    
private PhpStmt toPhpStmt(entity(str name, set[Declaration] declarations), set[Annotation] annotations)
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations])[
        @phpAnnotations=toDoctrineAnnotations(annotations) + {phpAnnotation("Entity")}
    ]);

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpNoExpr())]);

private PhpClassItem toPhpClassItem(property(Type \valueType, str name, _, Expression defaultValue)) 
    = phpProperty({phpPrivate()}, [phpProperty(name, phpSomeExpr(toPhpExpr(defaultValue)))]);
