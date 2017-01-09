module Parser::Converter::Declaration::Property

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`) 
    = property(convertType(prop), "<name>", {})[@src=a@\loc][
        @annotations=[annotation("column", [annotationMap(("type": convertPropertyType(convertType(prop))))])]
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) 
    = property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc][
        @annotations=[annotation("column", [annotationMap(("type": convertPropertyType(convertType(prop))))])]
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties))[@src=a@\loc][
        @annotations=[annotation("column", [annotationMap(("type": convertPropertyType(convertType(prop))))])]
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc][
        @annotations=[annotation("column", [annotationMap(("type": convertPropertyType(convertType(prop))))])]
    ];

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _) {

    Declaration property = convertProperty(prop);

    return property[
    	@annotations = (property@annotations? ? property@annotations : []) + convertAnnotations(annotations)
    ][@src=a@\loc];
}
    
public Annotation convertPropertyType(integer()) = annotationVal("integer");
public Annotation convertPropertyType(string()) = annotationVal("string");
public Annotation convertPropertyType(boolean()) = annotationVal("boolean");
public Annotation convertPropertyType(float()) = annotationVal("float");
public default Annotation convertPropertyType(_) = annotationVal("");
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _) = convertProperty(prop);
