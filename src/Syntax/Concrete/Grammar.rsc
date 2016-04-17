module Syntax::Concrete::Grammar

lexical LAYOUT = [\t-\n\r\ ];
lexical Identifier =  [a-zA-Z][a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
lexical ImportArtifactType = "entity" | "value" | "repository" | "collection" | "util" | "service";

layout LAYOUTLIST = LAYOUT* !>> [\t-\n\r\ ] ;

start syntax Module = \module: "module" Identifier name ";" Imports* imports
                    ;

syntax Imports = importInternal: "use" Identifier target ImportArtifactType artifactType ";"
               | importInternal: "use" Identifier target ImportArtifactType artifactType "as" Identifier alias ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module ";"
               | importExternal: "use" Identifier target ImportArtifactType artifactType "from" Identifier module "as" Identifier alias ";"
               ;