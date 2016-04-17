module Syntax::Concrete::Grammar

lexical LAYOUT = [\t-\n\r\ ];
lexical TableName = [a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
lexical Identifier =  [a-zA-Z][a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
lexical ImportArtifactType = "entity" | "value" | "repository" | "collection" | "util" | "service";

layout LAYOUTLIST = LAYOUT* !>> [\t-\n\r\ ] ;

start syntax Module = \module: "module" Identifier name ";" Imports* imports
                    | \module: "module" Identifier name ";" Imports* imports Artifact artifact
                    ;

syntax Imports = importInternal: "use" Identifier target ImportArtifactType artifactType ";"
               | importInternal: "use" Identifier target ImportArtifactType artifactType "as" Identifier alias ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module "as" Identifier alias ";"
               ;

// Entity grammar

syntax EntityAnno = annoTable: "@table(" "name=" TableName name ")"
                  | index: "@index(" Identifier name "," "{" {EntityAnnoIndexColumns ","}* columns "}" ")"
                  ;

syntax EntityAnnoIndexColumns = Identifier;

syntax Artifact = entity: EntityAnno* annotations "entity" Identifier name "{" "}";

