module Syntax::Concrete::Grammar::Lexical

extend Syntax::Concrete::Grammar::Keywords;

lexical ArtifactName
    =  ([A-Z] !<< [A-Z] [0-9 A-Z a-z]* !>> [0-9 A-Z a-z]) \ GlagolPreserved
    ;

lexical MemberName
    =  ([a-z] !<< [a-z] [0-9 A-Z a-z]* !>> [0-9 A-Z a-z]) \ GlagolPreserved
    ;

lexical Identifier
    =  ([a-zA-Z][a-zA-Z0-9_]* !>> [a-zA-Z0-9_]) \ GlagolPreserved;

lexical AlphaIdentifier
    =  ([A-Z a-z] !<< [A-Z a-z] [0-9 A-Z a-z]* !>> [0-9 A-Z a-z]) \ GlagolPreserved
    ;

lexical Name
    =  ([A-Z a-z _] !<< [A-Z _ a-z] [0-9 A-Z _ a-z]* !>> [0-9 A-Z _ a-z]) \ GlagolPreserved
    ;

lexical ArtifactType
    = "entity" | "value" | "repository" | "collection" | "util" | "service";

lexical ValueProperty
    = "get" | "set" 
    ;

lexical RelationDir
    = "one" | "many" 
    ;

lexical RelProperty
    = "get" | "set" | "add" | "reset" | "clear" 
    ;

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
