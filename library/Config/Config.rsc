module Config::Config

data Framework
    = zend()
    | anyFramework()
    | lumen()
// TODO    | symfony()
    ;

data ORM
    = doctrine()
    | anyORM()
// TODO    | eloquent()
    ;
