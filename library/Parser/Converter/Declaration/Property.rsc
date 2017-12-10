module Parser::Converter::Declaration::Property

import Syntax::Abstract::Glagol;
import Syntax::Concrete::Grammar;
import Parser::Converter::Type;
import Parser::Converter::Annotation;
import Parser::Converter::DefaultValue;

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name>;`, ParseEnv env)  =
    property(convertType(prop, env), "<name>", emptyExpr()[@src=name@\loc])[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop, env))
    ];

public Declaration convertProperty(a: (Property) `<Type prop><MemberName name><AssignDefaultValue defVal>;`, ParseEnv env) =
    property(convertType(prop, env), "<name>", convertParameterDefaultVal(defVal, convertType(prop, env), env))[@src=a@\loc][
        @annotations=buildPropDefaultAnnotations(convertType(prop, env))
    ];

public list[Annotation] buildPropDefaultAnnotations(Type t) = 
    [annotation("column", [annotationMap(("type": annotationVal(t)))])]
    when t in [integer(), string(), boolean(), float()];
    
public default list[Annotation] buildPropDefaultAnnotations(Type t) = [];

public Declaration convertDeclaration(a: (Declaration) `<Annotation+ annotations><Property prop>`, _, _, ParseEnv env) {
    Declaration property = convertProperty(prop, env);

    list[Annotation] pAnnotations = property@annotations? ? property@annotations : [];

    for (an <- convertAnnotations(annotations, env)) {
        if (annotation(f: /column|field/, [*Annotation L, annotationMap(m), *Annotation R]) := an, 
            pAnnotations[0]? && pAnnotations[0].arguments? && pAnnotations[0].arguments[0]?) {
            pAnnotations[0].arguments[0].\map += m;
        } else {
            pAnnotations += an;
        }
    }

    return property[
        @annotations = pAnnotations
    ][@src=a@\loc];
}
    
public Declaration convertDeclaration(a: (Declaration) `<Property prop>`, _, _, ParseEnv env) = convertProperty(prop, env);
