module Test::Transform::Glagol2PHP::Doctrine::Relations

import Transform::Glagol2PHP::Doctrine::Relations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

test bool oneToOneRelationShouldTransformToPhpProperty() =
    toPhpClassItem(relation(\one(), \one(), "User", "owner", {})) ==
    phpProperty({phpPrivate()}, [phpProperty("owner", phpNoExpr())]);

test bool oneToOneRelationShouldTransformToPhpPropertyCheckingAnnotations() =
    toPhpClassItem(relation(\one(), \one(), "User", "owner", {}))@phpAnnotations ==
    {phpAnnotation("ORM\\OneToOne", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("User")
        )))};

test bool oneToManyRelationShouldTransformToPhpPropertyCheckingAnnotations() =
    toPhpClassItem(relation(\one(), many(), "User", "owner", {}))@phpAnnotations ==
    {phpAnnotation("ORM\\OneToMany", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("User")
        )))};

test bool manyToManyRelationShouldTransformToPhpPropertyCheckingAnnotations() =
    toPhpClassItem(relation(many(), many(), "User", "owner", {}))@phpAnnotations ==
    {phpAnnotation("ORM\\ManyToMany", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("User")
        )))};

test bool manyToOneRelationShouldTransformToPhpPropertyCheckingAnnotations() =
    toPhpClassItem(relation(many(), \one(), "User", "owner", {}))@phpAnnotations ==
    {phpAnnotation("ORM\\ManyToOne", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("User")
        )))};
