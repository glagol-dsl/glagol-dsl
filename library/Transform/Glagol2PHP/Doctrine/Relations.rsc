module Transform::Glagol2PHP::Doctrine::Relations

import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;

public PhpClassItem toPhpClassItem(d: relation(l, r, str name, str as), env: <_, doctrine()>) 
    = phpProperty({phpPrivate()}, [phpProperty(as, phpNoExpr())])[@phpAnnotations={
        phpAnnotation("ORM\\<toStrDir(l, r)>", phpAnnotationVal((
            "targetEntity": phpAnnotationVal("<name>")
        )))
    } + toPhpAnnotations(d, env) + typeVarAnnotations(l, r, name)];

private str toStrDir(\one(), \one()) = "OneToOne";
private str toStrDir(\one(), many()) = "OneToMany";
private str toStrDir(many(), \one()) = "ManyToOne";
private str toStrDir(many(), many()) = "ManyToMany";

private PhpAnnotation typeVarAnnotations(_, \one(), str name) = phpAnnotation("var", phpAnnotationVal(name));
private PhpAnnotation typeVarAnnotations(_, many(), str name) = phpAnnotation("var", phpAnnotationVal("<name>[]"));
