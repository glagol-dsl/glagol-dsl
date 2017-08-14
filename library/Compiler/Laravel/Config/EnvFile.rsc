module Compiler::Laravel::Config::EnvFile

import Config::Config;
import Config::Reader;
import String;
import Map;
import Utils::Glue;

public str createEnvFile(Config config) = 
    glue(
    ["APP_<toUpperCase(k[0])>=<k[1]>" | k <- toList(getConfig(getConfigPath(config) + "app.json"))] +
    ["DB_<toUpperCase(k[0])>=<k[1]>" | k <- toList(getConfig(getConfigPath(config) + "database.json"))], "\n");
