module Parser::Converter::Declaration::Property

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertProperty((Property) `<Type prop><MemberName name>;`) 
    = property(convertType(prop), "<name>", {});

public Declaration convertProperty((Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`) 
    = property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal, convertType(prop)));
    
public Declaration convertProperty((Property) `<Type prop><MemberName name><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertProperty((Property) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal, convertType(prop)));
    
public Declaration convertDeclaration((Declaration) `<Annotation+ annotations><Property prop>`, _, _) 
    = convertProperty(prop)[
    	@annotations = convertAnnotations(annotations)
    ];
    
public Declaration convertDeclaration((Declaration) `<Property prop>`, _, _) = convertProperty(prop);
