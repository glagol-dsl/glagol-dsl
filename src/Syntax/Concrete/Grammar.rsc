module Syntax::Concrete::Grammar

// Define layout

layout LAYOUTLIST = LAYOUT* !>> [\t-\n\r\ ] ;

// Start grammar

start syntax Module = \module: "module" Identifier name ";" Imports* imports
                    | \module: "module" Identifier name ";" Imports* imports Artifact artifact
                    ;

syntax Imports = importInternal: "use" Identifier target ImportArtifactType artifactType ";"
               | importInternal: "use" Identifier target ImportArtifactType artifactType "as" Identifier alias ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module "as" Identifier alias ";"
               ;

// Artifacts grammar

syntax Artifact = entity: EntityAnno* annotations "entity" Identifier name "{" EntityDeclarations* declarations "}"
                ;

syntax EntityDeclarations = EntityValue | EntityRelation;

syntax EntityRelation = relation: "relation" RelationDir local ":" RelationDir foreign Identifier entity "as" Identifier alias ";"
                      | relation: "relation" RelationDir local ":" RelationDir foreign Identifier entity "as" Identifier alias "with" "{" {RelProperties ","}* "}" ";"
                      ;

syntax EntityValue = entityValue: EntityValueAnno* annotations "value" Identifier type Identifier name ";"
                   | entityValue: EntityValueAnno* annotations "value" Identifier type Identifier name "with" "{" {ValueProperties ","}* "}" ";"
                   ;

syntax EntityAnno = annoTable: "@table(" "name=" Name name ")"
                  | index: "@index(" Identifier name "," "{" {Identifier ","}* columns "}" ")"
                  ;

syntax EntityValueAnno = annoField: "@field(" {AnnotationPair ","}* pairs ")";

syntax AnnotationPair = annoPair: Identifier key ":" Name value;

// Lexical tokens

lexical LAYOUT = [\t-\n\r\ ];
lexical Name = [a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
lexical Identifier =  [a-zA-Z][a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
lexical ImportArtifactType = "entity" | "value" | "repository" | "collection" | "util" | "service";
lexical ValueProperties = "get" | "set" ;
lexical RelationDir = "one" | "many" ;
lexical RelProperties = "get" | "set" | "add" | "reset" | "clear" ;

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


lexical StringConstant = "\"" StringCharacter* chars "\"" ;


