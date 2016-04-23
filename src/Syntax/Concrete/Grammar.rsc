module Syntax::Concrete::Grammar

// Define layout

layout LAYOUTLIST = LAYOUT* !>> [\t-\n\r\ ] ;

keyword GlagolPreserved
	= "module"
	| "use"
	| "from"
	| "as"
	| "entity"
	| "util"
	| "service"
	| "value"
	| "repository"
	| "collection"
	| "int"
	| "bool"
	| "boolean"
	| "string"
	| "relation"
	| "true"
	| "false"
	| "when"
	;

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

lexical AnnotationFieldKeyIndex
    = "key"
    ;

lexical AnnotationFieldSequenceIndex
    = "sequence"
    ;

lexical AnnotationFieldTypeIndex
    = "type"
    ;

lexical AnnotationFieldSizeIndex
    = "size" | "precision"
    ;

lexical AnnotationFieldScaleIndex
    = "scale"
    ;

lexical AnnotationFieldColumnIndex
    = "column"
    ;

lexical AnnotationFieldKeyValue
    = "primary" | "unique"
    ;

// TODO replace Name with lower-case starting alphabetical-chars-only non-terminal
syntax Method
    = method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "=" Expression expr ";"
    | method: Modifier modifier Type returnType Name name "(" {Parameter ","}* parameters ")" "=" Expression expr "when" Expression when ";"
    //| method: Modifier modifier Type type AlphaIdentifier name "(" {Parameters parameters ","}* ")" "{" Statement body "}"
    //| method: Modifier modifier Type type AlphaIdentifier name "(" {Parameters parameters ","}* ")" "{" Statement body "}" "when" Expression when ";"
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
    | \void: "void"
    | typedArray: Type type "[]"
    > artifactType: Name name
    ;

syntax Parameter
    = parameter: Type paramType AlphaIdentifier name
    | parameter: Type paramType AlphaIdentifier name "=" ParameterDefaultValue defaultValue
    ;

syntax ParameterDefaultValue
    = stringLiteral: StringConstant string
    | intLiteral: DecimalIntegerLiteral number
    | floatLiteral: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    | array: "[" {ParameterDefaultValue ","}* items "]" array
    ;

syntax Statement
    = "statement";

lexical Digid = [0-9];

syntax Expression
    = bracket \bracket  : "(" Expression expression ")"
    | \array            : "[" {Expression ","}* items "]"
    | negative          : "-" Expression argument
    | literal           : Literal literal
    | variable          : Identifier varName
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

syntax Literal
    = stringLiteral: StringConstant string
    | intLiteral: DecimalIntegerLiteral number
    | floatLiteral: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    //| dateTime: DateTimeLiteral dateTimeLiteral
    ;

// Lexical tokens

lexical LAYOUT
    = [\t-\n\r\ ];

lexical Identifier
    =  [a-zA-Z][a-zA-Z0-9_]* !>> [a-zA-Z0-9_] \ GlagolPreserved;

lexical ImportArtifactType
    = "entity" | "value" | "repository" | "collection" | "util" | "service";

lexical ValueProperties
    = "get" | "set" ;

lexical RelationDir
    = "one" | "many" ;

lexical RelProperties
    = "get" | "set" | "add" | "reset" | "clear" ;

lexical UnicodeEscape
    = utf16: "\\" [u] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f]
    | utf32: "\\" [U] (("0" [0-9 A-F a-f]) | "10") [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] // 24 bits
    | ascii: "\\" [a] [0-7] [0-9A-Fa-f]
    ;

lexical StringCharacter
    = "\\" [\" \' \< \> \\ b f n r t]
    | UnicodeEscape
    | ![\" \' \< \> \\]
    | [\n][\ \t \u00A0 \u1680 \u2000-\u200A \u202F \u205F \u3000]* [\'] // margin
    ;

lexical Boolean
    = "true"
    | "false"
    ;

lexical StringConstant
    = "\"" StringCharacter* chars "\""
    ;

lexical DecimalIntegerLiteral
    = "0" !>> [0-9 A-Z _ a-z]
    | [1-9] [0-9]* !>> [0-9 A-Z _ a-z] ;

lexical DeciFloatExponentPart
    = [E e] SignedInteger !>> [0-9]
    ;

lexical SignedInteger
    = [+ \-]? [0-9]+
    ;

lexical DeciFloatNumeral
    = [0-9] !<< [0-9]+ DeciFloatExponentPart
    | [0-9] !<< [0-9]+ >> [D F d f]
    | [0-9] !<< [0-9]+ "." [0-9]* !>> [0-9] DeciFloatExponentPart?
    | [0-9] !<< "." [0-9]+ !>> [0-9] DeciFloatExponentPart?
    ;

lexical AlphaIdentifier
	=  ([A-Z a-z] !<< [A-Z a-z] [0-9 A-Z a-z]* !>> [0-9 A-Z a-z]) \ GlagolPreserved
	;

lexical Name
	=  ([A-Z a-z _] !<< [A-Z _ a-z] [0-9 A-Z _ a-z]* !>> [0-9 A-Z _ a-z]) \ GlagolPreserved
	;


