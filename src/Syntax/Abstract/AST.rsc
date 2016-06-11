module Syntax::Abstract::AST

data Declaration 
    = \module(str name, set[Declaration] imports)
    | use(str target, str \type, UseSource source, str as)
    ;
    
data UseSource
    = externalUse(str \module)
    | internalUse()
    ;
