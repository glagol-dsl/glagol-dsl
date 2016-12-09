module Transform::Glagol2PHP::Doctrine::Relations

import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(relation(RelationDir l, RelationDir r, str name, str as, set[AccessProperty] valueProperties), env) 
    = phpProperty({phpPrivate()}, [phpProperty(as, phpNoExpr())])[@phpAnnotations={
        phpAnnotation("ORM\\<toStrDir(l, r)>", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("<name>")
        )))
    }];

private str toStrDir(\one(), \one()) = "OneToOne";
private str toStrDir(\one(), many()) = "OneToMany";
private str toStrDir(many(), \one()) = "ManyToOne";
private str toStrDir(many(), many()) = "ManyToMany";
