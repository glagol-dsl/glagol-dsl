module Syntax::Concrete::Grammar

extend Syntax::Concrete::Grammar::Keywords;
extend Syntax::Concrete::Grammar::Layout;
extend Syntax::Concrete::Grammar::Lexical;

start syntax Module
   = \module: ^"namespace" Namespace namespace Import* imports AnnotatedArtifact? artifact LAYOUTLIST l1
   ;

syntax Namespace 
    = Name name
    | Name name "::" Namespace sub
    ;

syntax Import
    = \import: "import" Namespace namespace "::" ArtifactName artifact ImportAlias? alias ";"
    ;
    
syntax ImportAlias
    = "as" ArtifactName alias
    ;

syntax AnnotatedArtifact
	= Annotation* annotations Artifact artifact
	;

syntax Artifact
    = "entity" ArtifactName name "{" Declaration* declarations "}"
    | "repository" "for" ArtifactName name "{" Declaration* declarations "}"
    | "value" ArtifactName name "{" Declaration* declarations "}"
    | ("util" | "service") ArtifactName name "{" Declaration* declarations "}"
    | ControllerType controllerType "controller" Route routes "{" Declaration* declarations "}"
    ;

lexical Route = "/" {RoutePart "/"}* routes;

syntax RoutePart
	= Identifier part
	| RoutePlaceholder placeholder
	;

syntax Annotation
    = "@" Identifier id AnnotationArgs? args
    | "@" Identifier id "=" AnnotationArg arg
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

// TODO generelize annotations by introducing AnnotatedDeclaration
syntax Declaration
    = Property property
    | Annotation+ annotations Property property
    | Constructor constructor
    | Annotation+ annotations Constructor constructor
    | Method method
    | Annotation+ annotations Method method
    | Action action
    | Annotation+ annotations Action action
    ;

syntax Property 
    = Type type MemberName name AssignDefaultValue? ";";

syntax Constructor
    = ArtifactName "(" {AbstractParameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    ;

syntax Method
    = Modifier? modifier Type returnType MemberName name "(" {AbstractParameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    | Modifier? modifier Type returnType MemberName name "(" {AbstractParameter ","}* parameters ")" "=" Expression expr When? when ";"
    ;

syntax Action
    = MemberName name AbstractParameters? "{" Statement* body "}"
    | MemberName name AbstractParameters? "=" Expression expr ";"
    ;
    
syntax Modifier
    = "private"
    | "public"
    ;

syntax When
    = "when" Expression expr
    ;

syntax AbstractParameters
	= "(" {AbstractParameter ","}* parameters ")"
	;

syntax AbstractParameter
    = Parameter parameter
    | Annotation+ annotations Parameter parameter;

syntax Parameter
    = Type paramType MemberName name AssignDefaultValue? defaultValue
    ;

syntax AssignDefaultValue
    = "=" DefaultValue defaultValue
    ;

// TODO deprecate - just use expression. Typechecker will disallow illegal input
syntax DefaultValue
    = stringLiteral : StringQuoted string
    | integer : DecimalIntegerLiteral number
    | float : DeciFloatNumeral number
    | booleanLiteral : Boolean boolean
    | \list : "[" {DefaultValue ","}* items "]" list
    | \map: "{" {MapPair ","}* items "}"
    | getInstance: "get" InstanceType
    | newInstance: "new" InstanceType "(" {Expression ","}* args ")"
    ;

syntax InstanceType
    = "selfie"
    | Type
    ;

syntax Type
    = integer: "int"
    | \float: "float"
    | string: "string"
    | \bool: "bool"
    | \bool: "boolean"
    | voidValue: "void"
    | typedList: Type type "[]"
    | typedMap: "{" Type key "," Type v "}"
    | repositoryType: "repository" "\<" ArtifactName name "\>" 
    > artifactType: ArtifactName name
    ;

syntax Expression
    = bracket \bracket: "(" Expression expression ")"
    | \list: "[" {Expression ","}* items "]"
    | \map: "{" {MapPair ","}* items "}"
    | negative: "-" Expression argument
    | positive: "+" Expression argument
    | stringLiteral: StringQuoted string
    | integer: DecimalIntegerLiteral number
    | float: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    | variable: MemberName varName
    | newInstance: "new" ArtifactName "(" {Expression ","}* args ")"
//    | getInstance: "get" Type
    | invokeLocal: MemberName method "(" {Expression ","}* args ")"
    | invoke: Expression prev "." MemberName method "(" {Expression ","}* args ")"
    | fieldAccess: Expression prev "." MemberName field
    | this: "this"
    > left "(" Type type ")" Expression expr
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

syntax MapPair
    = Expression key ":" Expression val
    ;

syntax Statement
    = expression: Expression expression ";"
    | block: "{" Statement* statements "}"
    | ifThen: "if" "(" Expression condition ")" Statement then () !>> "else"
    | ifThenElse: "if" "(" Expression condition ")" Statement then "else" Statement else
    | assign: Assignable assignable AssignOperator operator Statement value !emptyStmt!block!ifThen!ifThenElse!return!break
    | query: QueryStatement query ";"
    | foreach: "for" "(" Expression list "as" MemberName var (","  {Expression ","}+ conditions)? ")" Statement body
    | foreach: "for" "(" Expression list "as" MemberName key ":" MemberName var (","  {Expression ","}+ conditions)? ")" Statement body
    > non-assoc  (
            \return: "return" Expression? expr ";"
        |   \persist: "persist" Expression expr ";"
        |   \flush: "flush" Expression? expr ";"
        |   \flush: "remove" Expression expr ";"
        |   \break: "break" Integer? level ";"
        |   \continue: "continue" Integer? level ";"
        |   declare: Type type MemberName varName "=" Statement defaultValue !emptyStmt!block!ifThen!ifThenElse!return!declare
        |   declare: Type type MemberName varName ";"
    )
    > emptyStmt: ";"
    ;   

syntax QueryStatement 
	= QuerySelectStmt selectStatement
	;

syntax QuerySelectStmt
	= "SELECT" QuerySpec spec "FROM" {QuerySource ","}+ sources QueryWhere? where QueryOrderBy? order QueryLimit? limit
	;

syntax QuerySpec
	= MemberName as 
	;

syntax QuerySource
	= ArtifactName artifact MemberName as
	| ArtifactName artifact "as" MemberName as
	;

syntax QueryWhere
	= "WHERE" QueryExpression
	;

syntax QueryField
	= MemberName artifact "." MemberName field
	;

syntax QueryExpression
	= bracket "(" QueryExpression expr ")"
	| QueryExpression l "=" QueryExpression r
	| QueryExpression l "!=" QueryExpression r
	| QueryExpression l "\>" QueryExpression r
	| QueryExpression l "\>=" QueryExpression r
	| QueryExpression l "\<" QueryExpression r
	| QueryExpression l "\<=" QueryExpression r
	| QueryExpression l "IS" "NULL"
	| QueryExpression l "IS" "NOT" "NULL"
	| QueryExpression l "AND" QueryExpression r
	| QueryExpression l "OR" QueryExpression r
	| "\<" Expression expr "\>"
	| QueryField field
	;

syntax QueryOrderBy
	= "ORDER" "BY" {QueryOrderByField ","}+ fields
	;

syntax QueryOrderByField
	= QueryField field
	| QueryField field "DESC"
	| QueryField field "ASC"
	;

syntax QueryLimit
	= QueryExpression size
	| QueryExpression size "OFFSET" QueryExpression offset
	| QueryExpression offset "," QueryExpression size
	;

syntax Assignable
    = variable: MemberName varName
    | fieldAccess: Expression prev "." MemberName field
    | arrayAccess: Assignable variable "[" Expression key "]"
    ;

syntax AssignOperator
    = divisionAssign: "/=" 
    | productAssign: "*=" 
    | subtractionAssign: "-=" 
    | defaultAssign: "=" 
    | additionAssign: "+=" 
    ;
    
