module Transform::Glagol2PHP::ClassItems

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;

public list[PhpClassItem] toPhpClassItems(list[Declaration] declarations) {
    list[PhpClassItem] classItems = [toPhpClassItem(ci) | ci <- declarations, isProperty(ci) || isAnnotated(ci, isProperty)];
    
    if (hasConstructors(declarations)) {
        classItems = classItems + [createConstructor(getConstructors(declarations))];
    }
    
    map[str, list[Declaration]] methodsByName = categorizeMethods(declarations);
    
    classItems = classItems + [createMethod(methodsByName[m]) | m <- methodsByName] 
                            + [toPhpClassItem(r) | r <- getRelations(declarations)];
    
    return classItems;
}
