package org.glagol.sourcemap;

import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;

import java.io.IOException;

public class RascalBase64VLQ {

    private final IValueFactory valueFactory;

    public RascalBase64VLQ(IValueFactory vf) {
        this.valueFactory = vf;
    }

    public IString encode(IInteger val) throws IOException {
        StringBuilder out = new StringBuilder();
        Base64VLQ.encode(out, val.intValue());
        return valueFactory.string(out.toString());
    }

    public IInteger decode(IString val) {
        int decoded = Base64VLQ.decode(new StringCharIterator(val.getValue()));
        return valueFactory.integer(decoded);
    }
}
