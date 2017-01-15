module Parser::Converter::Declaration::Property

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`)  = 
    property(convertType(prop), "<name>", {})[@src=a@\loc];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) = 
    property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) = 
    property(convertType(prop), "<name>", convertAccessProperties(accessProperties))[@src=a@\loc];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) = 
    property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc];

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _) {
    Declaration property = convertProperty(prop);

    list[Annotation] pAnnotations = [];

    if (property.valueType in [integer(), string(), boolean(), float()]) {
        pAnnotations += [annotation("column", [annotationMap(("type": annotationVal(property.valueType)))])];
    }

    for (an <- convertAnnotations(annotations)) {
        if (annotation(f: /column|field/, [*Annotation L, annotationMap(m), *Annotation R]) := an) {
            pAnnotations[0].arguments[0].\map += m;
        } else {
            pAnnotations += an;
        }
    }

    return property[
        @annotations = pAnnotations
    ][@src=a@\loc];
}
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _) = convertProperty(prop);
