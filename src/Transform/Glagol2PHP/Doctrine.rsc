module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;

extend Transform::Glagol2PHP::Statements;

public map[str, PhpScript] toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpStmt(namespace, imports, artifact)])) 
    when entity(_, _) := artifact || annotated(_, entity(_, _)) := artifact;

public PhpStmt toPhpStmt(Declaration namespace, list[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))}
        )] + [toPhpStmt(artifact)]
    );
    
@doc="Convert entity to a PHP class"
public PhpStmt toPhpStmt(entity(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], [toPhpClassItem(m) | m <- declarations])[
        @phpAnnotations={phpAnnotation("ORM\\Entity")}
    ])
    when size(getConstructors(declarations)) <= 1;

public PhpStmt toPhpStmt(entity(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], 
        [toPhpClassItem(m) | m <- getNonConstructors(declarations)] + [createOverridedConstructor(getConstructors(declarations))]
      )[
        @phpAnnotations={phpAnnotation("ORM\\Entity")}
    ])
    when size(getConstructors(declarations)) > 1;
