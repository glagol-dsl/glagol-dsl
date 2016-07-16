module Parser::Converter::Declaration::Value

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;

public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name>;`, _) 
    = \value(convertType(valueType), "<name>");
    
public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));
