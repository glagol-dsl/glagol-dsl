# Glagol DSL

[![Build Status](https://travis-ci.org/BulgariaPHP/glagol-dsl.svg?branch=master)](https://travis-ci.org/BulgariaPHP/glagol-dsl)

A domain-specific language that utilizes Domain-Driven Design

## Install
Glagol runs as a service. Therefore you need to install two composer global packages:

```
composer global require bulgaria-php/glagol-dsl
composer global require bulgaria-php/glagol-dsl-client
```

> If you have trouble installing them, change your "minimum-stability" to "dev" in `~/.composer/composer.json`.

**Make sure to include your ~/.composer/vendor/bin path to the system PATH variable**

## Run the service
If you want to compile Glagol code you need to run the `glagol-server`:

```
glagol-server
```
Wait until a message `Opening socket...` appears.

## Create your first project
All you need is a `composer.json` file and `config/database.json` to start with.
You need to specify the following properties in your `composer.json`:
```
{
  "minimum-stability": "dev",
  "name": "glagol/test",
  "glagol": {
    "framework": "laravel",
    "orm": "doctrine",
    "paths": {
      "src": "src",
      "out": "compiled"
    }
  }
}
```
Notice the `glagol` group of properties. At the current moment, only Laravel Framework and Doctrine ORM are supported.

The `config/database.json` file persist of the following structure:
```
{
  "connection": "mysql",
  "host": "127.0.0.1",
  "port": "3306",
  "database": "glagol",
  "username": "root",
  "password": ""
}
```

### Hello world
Create a `src/MyProject/Controller/IndexController.g` with the following source code:
```
namespace MyProject::Controller

rest controller / {
    index = "Hello world!";
}
```

## Compile and test
Just run `glagol compile` in your project root directory.

You can now navigate to the `compiled` folder, install composer dependencies and run the php test server using artisan:
```
cd compiled
composer install
php artisan serve
```

Go to [http://127.0.0.1:8000/](http://127.0.0.1:8000/) and you should see the Hello world! message!
