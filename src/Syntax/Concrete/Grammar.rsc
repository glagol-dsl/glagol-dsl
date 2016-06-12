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
    = "@table" "(" "name" ":" Name name ")"
    | "@index" "(" Name name "," "{" {Name ","}* fields "}" ")"
    | "@field" "(" {AnnotationPair ","}+ pairs ")"
    ;

syntax AnnotationPair
    = AnnotationKey key ":" AnnotationValue value
    ;

syntax AnnotationValue
    = Name name
    | Type type
    | DecimalIntegerLiteral number
    | Boolean boolean
    ;

syntax Declaration
    = Annotation* annotations "value" Type type MemberName name AccessProperties? accessProperties ";"
    | "relation" RelationDir l ":" RelationDir r ArtifactName entity "as" MemberName alias AccessProperties? accessProperties ";"
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
