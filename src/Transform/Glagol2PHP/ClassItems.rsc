module Transform::Glagol2PHP::ClassItems

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Utils;
import Transform::Glagol2PHP::Entities;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::Doctrine::Annotations;
import Transform::Glagol2PHP::Doctrine::Relations;

public PhpStmt toPhpClassDef(annotated(list[Annotation] annotations, Declaration artifact), env) 
    = applyAnnotationsOnStmt(toPhpClassDef(artifact, env), annotations, env);
    
@doc="Will apply annotations to all php class items that were converted from Glagol in-artefact declarations"
public PhpClassItem toPhpClassItem(annotated(list[Annotation] annotations, Declaration declaration), env)
    = applyAnnotationsOnClassItem(toPhpClassItem(declaration, env), annotations, env);

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations, env) {
    list[PhpClassItem] classItems = [toPhpClassItem(ci, env) | ci <- declarations, isProperty(ci) || isAnnotated(ci, isProperty)];
    
    if (hasConstructors(declarations)) {
        classItems = classItems + [createConstructor(getConstructors(declarations), env)];
    }
    
    map[str, list[Declaration]] methodsByName = categorizeMethods(declarations);
    
    classItems = classItems + [createMethod(methodsByName[m], env) | m <- methodsByName] 
                            + [toPhpClassItem(r, env) | r <- getRelations(declarations)];
    
    return classItems;
}
