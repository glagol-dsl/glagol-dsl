module Parser::Converter::Declaration::Property

import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::AccessProperty;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertDeclaration((Declaration) `<Type prop><MemberName name>;`, _, _) 
    = property(convertType(prop), "<name>", {});

public Declaration convertDeclaration((Declaration) `<Type prop><MemberName name><AssignDefaultValue defVal>;`, _, _) 
    = property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal));
    
public Declaration convertDeclaration((Declaration) `<Type prop><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`, _, _) 
    = property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type prop><MemberName name>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, property(convertType(prop), "<name>"));

public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type prop><MemberName name><AssignDefaultValue defVal>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, property(convertType(prop), "<name>", {}, convertParameterDefaultVal(defVal)));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type prop><MemberName name><AccessProperties accessProperties>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, property(convertType(prop), "<name>", convertAccessProperties(accessProperties)));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations><Type prop><MemberName name><AssignDefaultValue defVal><AccessProperties accessProperties>;`, _, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, property(convertType(prop), "<name>", convertAccessProperties(accessProperties), convertParameterDefaultVal(defVal)));
