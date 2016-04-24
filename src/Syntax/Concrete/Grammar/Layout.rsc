module Syntax::Concrete::Grammar::Layout

layout LAYOUTLIST 
    = LAYOUT* !>> [\t-\n\r\ ] ;

lexical LAYOUT
    = [\t-\n\r\ ];
