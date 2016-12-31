module Exceptions::ConfigExceptions

data ConfigException 
    = InvalidFramework(str msg)
    | InvalidORM(str msg)
    | ConfigMissing(str msg)
    ;
