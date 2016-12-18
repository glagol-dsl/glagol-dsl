module Transform::Glagol2PHP::Doctrine::Relations

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(d: relation(l, r, str name, str as, valueProperties), env: <_, doctrine()>) 
    = phpProperty({phpPrivate()}, [phpProperty(as, phpNoExpr())])[@phpAnnotations={
        phpAnnotation("ORM\\<toStrDir(l, r)>", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("<name>")
        )))
    } + toPhpAnnotations(d, env)];

private str toStrDir(\one(), \one()) = "OneToOne";
private str toStrDir(\one(), many()) = "OneToMany";
private str toStrDir(many(), \one()) = "ManyToOne";
private str toStrDir(many(), many()) = "ManyToMany";
