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
    | "construct" "(" {Parameter ","}* parameters ")" "{" "}"
    | "construct" "(" {Parameter ","}* parameters ")" ";"
    ;

syntax Parameter
    = Type paramType MemberName name ParameterDefaultValue? defaultValue
    ;

syntax ParameterDefaultValue
    = "=" DefaultValue defaultValue
    ;

syntax DefaultValue
    = stringLiteral     : "\"" StringCharacter* string "\""
    | intLiteral        : DecimalIntegerLiteral number
    | floatLiteral      : DeciFloatNumeral number
    | booleanLiteral    : Boolean boolean
    | array             : "[" {DefaultValue ","}* items "]" array
    ;

syntax AccessProperties
    = "with" "{" {AccessProperty ","}* props "}"
    ;

syntax Type
    = integer:      "int"
    | \float:       "float"
    | string:       "string"
    | \bool:        "bool"
    | \bool:        "boolean"
    | voidValue:    "void"
    | typedArray:   Type type "[]"
    > artifactType: ArtifactName name
    ;

syntax StringQuoted 
    = "\"" StringCharacter* string "\""
    ;
