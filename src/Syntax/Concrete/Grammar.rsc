module Syntax::Concrete::Grammar

extend Syntax::Concrete::Grammar::Keywords;
extend Syntax::Concrete::Grammar::Layout;
extend Syntax::Concrete::Grammar::Lexical;

start syntax Module
   = \module: ^"module" Name name ";" Use* uses Artifact? artifact
   ;

syntax Use
    = use: "use" ArtifactName target ArtifactType artifactType UseSource? source UseAlias? alias ";"
    ;
    
syntax UseAlias
    = "as" ArtifactName alias
    ;

syntax UseSource
    = "from" Name module
    ;

syntax Artifact
    = Annotation* annotations "entity" ArtifactName name "{" Declaration* declarations "}"
    ;

syntax Annotation
    = "@" Identifier id AnnotationArgs?
    ;

syntax AnnotationArgs
    = "(" {AnnotationArg ","}+ args ")"
    ;

syntax AnnotationArg
    = StringQuoted stringVal 
    | Boolean boolean
    | DecimalIntegerLiteral number
    | DeciFloatNumeral number
    | "[" {AnnotationArg ","}+ listVal "]"
    | "{" {AnnotationPair ","}+ mapVal "}"
    ;

syntax AnnotationPair
    = AnnotationKey key ":" AnnotationValue value
    ;

syntax AnnotationValue
    = AnnotationArg val
    | "primary"
    | Type type 
    ;

syntax Declaration
    = Annotation* annotations "value" Type type MemberName name AccessProperties? accessProperties ";"
    | "relation" RelationDir l ":" RelationDir r ArtifactName entity "as" MemberName alias AccessProperties? accessProperties ";"
    | ArtifactName "(" {Parameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    | ArtifactName "(" {Parameter ","}* parameters ")" When? when ";"
    | Type returnType MemberName name "(" {Parameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    | Type returnType MemberName name "(" {Parameter ","}* parameters ")" "=" Expression expr When? when ";"
    ;

syntax When
    = "when" Expression expr
    ;

syntax Parameter
    = Type paramType MemberName name ParameterDefaultValue? defaultValue
    ;

syntax ParameterDefaultValue
    = "=" DefaultValue defaultValue
    ;

syntax DefaultValue
    = stringLiteral : StringQuoted string
    | intLiteral : DecimalIntegerLiteral number
    | floatLiteral : DeciFloatNumeral number
    | booleanLiteral : Boolean boolean
    | array : "[" {DefaultValue ","}* items "]" array
    ;

syntax AccessProperties
    = "with" "{" {AccessProperty ","}* props "}"
    ;

syntax Type
    = integer: "int"
    | \float: "float"
    | string: "string"
    | \bool: "bool"
    | \bool: "boolean"
    | voidValue: "void"
    | typedArray: Type type "[]"
    > artifactType: ArtifactName name
    ;

syntax StringQuoted 
    = "\"" StringCharacter* string "\""
    ;

syntax Expression
    = bracket \bracket: "(" Expression expression ")"
    | \array: "[" {Expression ","}* items "]"
    | negative: "-" Expression argument
    | stringLiteral: StringQuoted string
    | intLiteral: DecimalIntegerLiteral number
    | floatLiteral: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    | variable: MemberName varName
    > left ( product: Expression lhs "*" () !>> "*" Expression rhs
           | remainder: Expression lhs "%" Expression rhs
           | division: Expression lhs "/" Expression rhs
    )
    > left ( addition: Expression lhs "+" Expression rhs
           | subtraction: Expression lhs "-" Expression rhs
    )
//    > left modulo: Expression lhs "mod" Expression rhs
    > non-assoc ( greaterThanOrEq: Expression lhs "\>=" Expression rhs
                | lessThanOrEq: Expression lhs "\<=" Expression rhs
                | lessThan: Expression lhs "\<" !>> "-" Expression rhs
                | greaterThan: Expression lhs "\>" Expression rhs
    )
    > non-assoc ( equals: Expression lhs "==" Expression rhs
                | nonEquals: Expression lhs "!=" Expression rhs
    )
    > left and: Expression lhs "&&" Expression rhs
    > left or: Expression lhs "||" Expression rhs
    > right ifThenElse: Expression condition "?" Expression thenExp ":" Expression elseExp
    ;

syntax Statement
    = expression: Expression expression ";"
    | emptyStmt: ";"
    | block: "{" Statement* statements "}"
    | ifThen: "if" "(" Expression condition ")" Statement then () !>> "else"
    | ifThenElse: "if" "(" Expression condition ")" Statement then "else" Statement else
    | assign: Assignable assignable AssignOperator operator Statement value !empty!block!ifThen!ifThenElse
    ;

syntax Assignable
    = variable: MemberName varName
    | arrayAccess: Assignable variable "[" Expression key "]"
    ;

syntax AssignOperator
    = divisionAssign: "/=" 
    | productAssign: "*=" 
    | subtractionAssign: "-=" 
    | defaultAssign: "=" 
    | additionAssign: "+=" 
    ;
