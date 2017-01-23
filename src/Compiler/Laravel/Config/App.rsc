module Compiler::Laravel::Config::App

import Syntax::Abstract::PHP;
import Syntax::Abstract::Glagol;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;
import Config::Config;
import Config::Reader;

public str createAppConfig(Config config, list[Declaration] ast) = 
    toCode(createAppConfigAST(config, ast));

private PhpScript createAppConfigAST(Config config, list[Declaration] ast) =
    phpScript([phpReturn(phpSomeExpr(toPhpConf(array((
        "name": env("APP_NAME", "Glagol DSL project"),
        "env": env("APP_ENV", "production"),
        "debug": env("APP_DEBUG", true),
        "url": env("APP_URL", "http://localhost"),
        "timezone": string("UTC"),
        "locale": string("en"),
        "fallback_locale": string("en"),
        "key": env("APP_KEY"),
        "cipher": string("AES-256-CBC"),
        "log": env("APP_LOG", "single"),
        "log_level": env("APP_LOG_LEVEL", "debug"),
        "providers": array([
            class("Illuminate\\Auth\\AuthServiceProvider"),
            class("Illuminate\\Broadcasting\\BroadcastServiceProvider"),
            class("Illuminate\\Bus\\BusServiceProvider"),
            class("Illuminate\\Cache\\CacheServiceProvider"),
            class("Illuminate\\Foundation\\Providers\\ConsoleSupportServiceProvider"),
            class("Illuminate\\Cookie\\CookieServiceProvider"),
            class("Illuminate\\Database\\DatabaseServiceProvider"),
            class("Illuminate\\Encryption\\EncryptionServiceProvider"),
            class("Illuminate\\Filesystem\\FilesystemServiceProvider"),
            class("Illuminate\\Foundation\\Providers\\FoundationServiceProvider"),
            class("Illuminate\\Hashing\\HashServiceProvider"),
            class("Illuminate\\Mail\\MailServiceProvider"),
            class("Illuminate\\Notifications\\NotificationServiceProvider"),
            class("Illuminate\\Pagination\\PaginationServiceProvider"),
            class("Illuminate\\Pipeline\\PipelineServiceProvider"),
            class("Illuminate\\Queue\\QueueServiceProvider"),
            class("Illuminate\\Redis\\RedisServiceProvider"),
            class("Illuminate\\Auth\\Passwords\\PasswordResetServiceProvider"),
            class("Illuminate\\Session\\SessionServiceProvider"),
            class("Illuminate\\Translation\\TranslationServiceProvider"),
            class("Illuminate\\Validation\\ValidationServiceProvider"),
            class("Illuminate\\View\\ViewServiceProvider"),
            class("Glagol\\Bridge\\Laravel\\Providers\\RouteServiceProvider")
        ] + getORMProviders(getORM(config), ast)),
        "aliases": array((
            "App": class("Illuminate\\Support\\Facades\\App"),
            "Artisan": class("Illuminate\\Support\\Facades\\Artisan"),
            "Auth": class("Illuminate\\Support\\Facades\\Auth"),
            "Blade": class("Illuminate\\Support\\Facades\\Blade"),
            "Bus": class("Illuminate\\Support\\Facades\\Bus"),
            "Cache": class("Illuminate\\Support\\Facades\\Cache"),
            "Config": class("Illuminate\\Support\\Facades\\Config"),
            "Cookie": class("Illuminate\\Support\\Facades\\Cookie"),
            "Crypt": class("Illuminate\\Support\\Facades\\Crypt"),
            "DB": class("Illuminate\\Support\\Facades\\DB"),
            "Eloquent": class("Illuminate\\Database\\Eloquent\\Model"),
            "Event": class("Illuminate\\Support\\Facades\\Event"),
            "File": class("Illuminate\\Support\\Facades\\File"),
            "Gate": class("Illuminate\\Support\\Facades\\Gate"),
            "Hash": class("Illuminate\\Support\\Facades\\Hash"),
            "Lang": class("Illuminate\\Support\\Facades\\Lang"),
            "Log": class("Illuminate\\Support\\Facades\\Log"),
            "Mail": class("Illuminate\\Support\\Facades\\Mail"),
            "Notification": class("Illuminate\\Support\\Facades\\Notification"),
            "Password": class("Illuminate\\Support\\Facades\\Password"),
            "Queue": class("Illuminate\\Support\\Facades\\Queue"),
            "Redirect": class("Illuminate\\Support\\Facades\\Redirect"),
            "Redis": class("Illuminate\\Support\\Facades\\Redis"),
            "Request": class("Illuminate\\Support\\Facades\\Request"),
            "Response": class("Illuminate\\Support\\Facades\\Response"),
            "Route": class("Illuminate\\Support\\Facades\\Route"),
            "Schema": class("Illuminate\\Support\\Facades\\Schema"),
            "Session": class("Illuminate\\Support\\Facades\\Session"),
            "Storage": class("Illuminate\\Support\\Facades\\Storage"),
            "URL": class("Illuminate\\Support\\Facades\\URL"),
            "Validator": class("Illuminate\\Support\\Facades\\Validator"),
            "View": class("Illuminate\\Support\\Facades\\View")
        ))
    )))))]);

private list[Conf] getORMProviders(doctrine(), list[Declaration] ast) = [
    class("LaravelDoctrine\\ORM\\DoctrineServiceProvider")
] + [class("App\\Provider\\<name>RepositoryProvider") | file(_, \module(_, _, repository(str name, _))) <- ast];
