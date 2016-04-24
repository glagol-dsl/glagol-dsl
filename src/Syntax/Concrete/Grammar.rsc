module Syntax::Concrete::Grammar

extend Syntax::Concrete::Grammar::Keywords;
extend Syntax::Concrete::Grammar::Layout;
extend Syntax::Concrete::Grammar::Lexical;

// Start grammar

start syntax Module
   = \module: ^"module" Identifier name ";" Imports* imports
   | \module: ^"module" Identifier name ";" Imports* imports Artifact mainArtifact
   ;

syntax Imports
    = importInternal: "use" Identifier target ImportArtifactType artifactType ";"
    | importInternal: "use" Identifier target ImportArtifactType artifactType "as" Identifier alias ";"
    | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module ";"
    | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module "as" Identifier alias ";"
    ;

// Artifacts grammar

syntax Artifact
    = entity: EntityAnno* annotations "entity" Identifier name "{" EntityDeclarations* declarations "}"
    ;

syntax EntityDeclarations
    = EntityValue
    | EntityRelation
    | Method
    ;

syntax EntityRelation
    = relation: "relation" RelationDir local ":" RelationDir foreign Identifier entity "as" Identifier alias ";"
    | relation: "relation" RelationDir local ":" RelationDir foreign Identifier entity "as" Identifier alias "with" "{" {RelProperties ","}* "}" ";"
    ;

syntax EntityValue
    = entityValue: EntityValueAnno* annotations "value" Type type Identifier name ";"
    | entityValue: EntityValueAnno* annotations "value" Type type Identifier name "with" "{" {ValueProperties ","}* "}" ";"
    ;

syntax EntityAnno
    = annoTable: "@table(" "name=" Name name ")"
    | index: "@index(" Identifier name "," "{" {Identifier ","}* columns "}" ")"
    ;

syntax EntityValueAnno = annoField: "@field(" {AnnotationFieldKeyPair ","}* pairs ")";

syntax AnnotationFieldKeyPair
    = annoPair: AnnotationFieldKeyIndex key ":" AnnotationFieldKeyValue value
    | annoPair: AnnotationFieldSequenceIndex key ":" Boolean value
    | annoPair: AnnotationFieldTypeIndex key ":" DatabaseType value
    | annoPair: AnnotationFieldSizeIndex key ":" DecimalIntegerLiteral value
    | annoPair: AnnotationFieldScaleIndex key ":" DecimalIntegerLiteral value
    | annoPair: AnnotationFieldColumnIndex key ":" Identifier value
    ;

// TODO replace Name with lower-case starting alphabetical-chars-only non-terminal
syntax Method
    = method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "=" Expression expr ";"
    | method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "=" Expression expr "when" Expression when ";"
    | method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "{" Statement* body "}"
    | method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "{" Statement* body "}" "when" Expression when ";"
    ;

syntax Modifier
    = \public: "public"
    | \public: ()
    | \private: "private"
    ;

syntax DatabaseType
    = integer: "int"
    | \float: "float"
    | \float: "decimal"
    | string: "string"
    | \bool: "bool"
    | \bool: "boolean"
    | \date: "date"
    | \dateTime: "dateTime"
    | \timestamp: "timestamp"
    ;

syntax Type
    = integer: "int"
    | \float: "float"
    | string: "string"
    | \bool: "bool"
    | \bool: "boolean"
    | voidValue: "void"
    | typedArray: Type type "[]"
    > artifactType: Name name
    ;

syntax Parameter
    = parameter: Type paramType AlphaIdentifier name
    | parameter: Type paramType AlphaIdentifier name "=" ParameterDefaultValue defaultValue
    ;

syntax ParameterDefaultValue
    = stringLiteral: "\"" StringCharacter* string "\""
    | intLiteral: DecimalIntegerLiteral number
    | floatLiteral: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    | array: "[" {ParameterDefaultValue ","}* items "]" array
    ;

syntax Statement
    = expression: Expression expression ";"
    | empty: ";"
    ;

syntax Expression
    = bracket \bracket  : "(" Expression expression ")"
    | \array            : "[" {Expression ","}* items "]"
    | negative          : "-" Expression argument
    | stringLiteral     : "\"" StringCharacter* string "\""
    | intLiteral        : DecimalIntegerLiteral number
    | floatLiteral      : DeciFloatNumeral number
    | booleanLiteral    : Boolean boolean
    | variable          : Name varName
    > left ( product: Expression lhs "*" () !>> "*" Expression rhs
           | remainder: Expression lhs "%" Expression rhs
           | division: Expression lhs "/" Expression rhs
    )
    > left ( addition   : Expression lhs "+" Expression rhs
           | subtraction: Expression lhs "-" Expression rhs
    )
    > left modulo: Expression lhs "mod" Expression rhs
    > non-assoc ( greaterThanOrEq: Expression lhs "\>=" Expression rhs
                | lessThanOrEq   : Expression lhs "\<=" Expression rhs
                | lessThan       : Expression lhs "\<" !>> "-" Expression rhs
                | greaterThan    : Expression lhs "\>" Expression rhs
    )
    > non-assoc ( equals         : Expression lhs "==" Expression rhs
                | nonEquals      : Expression lhs "!=" Expression rhs
    )
    > left and: Expression lhs "&&" Expression rhs
    > left or: Expression lhs "||" Expression rhs
    > right ifThenElse: Expression condition "?" Expression thenExp ":" Expression elseExp
    ;
