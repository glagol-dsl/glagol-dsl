module Config::Config

data Framework
    = zend()
    | anyFramework()
    | laravel()
// TODO    | symfony()
    ;

data ORM
    = doctrine()
    | anyORM()
// TODO    | eloquent()
    ;