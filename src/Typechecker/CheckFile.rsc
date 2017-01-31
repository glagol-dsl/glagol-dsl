module Typechecker::CheckFile

import Config::Config;
import Config::Reader;
import Typechecker::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import String;

public TypeEnv checkFile(Config config, f:file(loc src, m:\module(ns, list[Declaration] imports, Declaration artifact)), TypeEnv env) = 
    checkImports(m, 
        checkLocVsModule(getSourcesPath(config), f, env[location = src]));

public TypeEnv checkLocVsModule(loc sources, file(loc src, m:\module(ns, imports, Declaration artifact)), TypeEnv env) =
    env[errors = env.errors + <
        src, 
        "Wrong file name, does not follow namespace declaration and/or artifact name. " + 
        "Expected <constructFileFromModule(sources, m).uri>, got <src.uri>."
    >]
    when src != constructFileFromModule(sources, m);
    
public TypeEnv checkLocVsModule(loc sources, file(loc src, m:\module(ns, imports, Declaration artifact)), TypeEnv env) =
    env when src == constructFileFromModule(sources, m);

public loc constructFileFromModule(loc sources, \module(Declaration ns, _, entity(GlagolID name, _))) = 
    sources + namespaceToString(ns, "/") + "<name>.g";

public loc constructFileFromModule(loc sources, \module(Declaration ns, _, repository(GlagolID name, _))) = 
    sources + namespaceToString(ns, "/") + "<name>Repository.g";

public loc constructFileFromModule(loc sources, \module(Declaration ns, _, valueObject(GlagolID name, _))) = 
    sources + namespaceToString(ns, "/") + "<name>.g";
    
public loc constructFileFromModule(loc sources, \module(Declaration ns, _, util(GlagolID name, _))) = 
    sources + namespaceToString(ns, "/") + "<name>.g";
    
public loc constructFileFromModule(loc sources, \module(Declaration ns, _, controller(GlagolID name, _, _, _))) = 
    sources + namespaceToString(ns, "/") + "<name>.g";
    