module Syntax::Concrete::Grammar::Layout

layout LAYOUTLIST
    = LAYOUT* !>> [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000] !>> "//" !>> "/*";

lexical LAYOUT
    = Comment
    | [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000] 
    ;

lexical Comment
    = "/*" (![*] | [*] !>> [/])* "*/" 
    | "//" ![\n]* !>> [\ \t\r \u00A0 \u1680 \u2000-\u200A \u202F \u205F \u3000] $
    ;
