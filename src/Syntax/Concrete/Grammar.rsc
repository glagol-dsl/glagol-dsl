module Syntax::Concrete::Grammar

extend Syntax::Concrete::Grammar::Keywords;
extend Syntax::Concrete::Grammar::Layout;
extend Syntax::Concrete::Grammar::Lexical;

start syntax Module
   = \module: ^"module" Name name ";" Use* uses
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
