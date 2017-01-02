module Parser::Converter::Declaration::Property

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`) 
    = property(convertType(prop), "<name>", {})[@src=a@\loc];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) 
    = property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc];
    
public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties))[@src=a@\loc];
    
public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)))[@src=a@\loc];
    
public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _) 
    = convertProperty(prop)[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _) = convertProperty(prop);
