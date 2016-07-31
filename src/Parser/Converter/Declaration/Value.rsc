module Parser::Converter::Declaration::Value

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;

public Declaration convertDeclaration((Declaration) `<Type valueType><MemberName name>;`, _, _) 
    = \value(convertType(valueType), "<name>");
    
public Declaration convertDeclaration((Declaration) `<Type valueType><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type valueType><MemberName name>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type valueType><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));
