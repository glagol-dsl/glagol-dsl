package org.glagol.system;

import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;

public class Env {
    private final IValueFactory vf;

    public Env(IValueFactory vf) {
        this.vf = vf;
    }

    public IString getenv(IString key, IString defaultValue) {
        String envVal = System.getenv(key.getValue());

        return isEmpty(envVal) ? defaultValue : vf.string(envVal);
    }

    private boolean isEmpty(String envVal) {
        return envVal == null || envVal.length() == 0;
    }
}
