module Transform::Glagol2PHP::Doctrine

import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Doctrine::Annotations;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Reader;
import List;
import IO;

public map[str, PhpScript] toPHPScript(<_, doctrine()>, \module(Declaration namespace, imports, artifact))
    = (makeFilename(namespace, artifact): phpScript([toPhpNamespace(namespace, imports, artifact)])) 
    when entity(_, _) := artifact || annotated(_, entity(_, _)) := artifact;

public PhpStmt toPhpNamespace(Declaration namespace, list[Declaration] imports, Declaration artifact)
    = phpNamespace(
        phpSomeName(phpName(namespaceToString(namespace, "\\"))),
        [phpUse(
            {toPhpUse(i) | i <- imports} + {phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM")))}
        )] + [toPhpClassDef(artifact)]
    );
    
private PhpStmt toPhpClassDef(annotated(list[Annotation] annotations, Declaration artifact)) 
    = applyAnnotationsOnStmt(toPhpClassDef(artifact), annotations);
    
@doc="Convert entity to a PHP class"
private PhpStmt toPhpClassDef(entity(str name, list[Declaration] declarations))
    = phpClassDef(phpClass(name, {}, phpNoName(), [], toPhpClassItems(declarations))[
        @phpAnnotations={phpAnnotation("ORM\\Entity")}
    ]);

private list[PhpClassItem] toPhpClassItems(list[Declaration] declarations) {
    list[PhpClassItem] classItems = [toPhpClassItem(ci) | ci <- declarations, isProperty(ci) || isAnnotated(ci, isProperty)];
    
    if (hasConstructors(declarations)) {
        classItems = classItems + [createConstructor(getConstructors(declarations))];
    }
    
    //map[str, list[Declaration]] methodsByName = categorizeMethods(declarations);
    
    return classItems;
}
