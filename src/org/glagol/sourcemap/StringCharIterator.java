package org.glagol.sourcemap;

public class StringCharIterator implements Base64VLQ.CharIterator {
    private final String content;
    private final int length;
    private int current = 0;

    StringCharIterator(String content) {
        this.content = content;
        this.length = content.length();
    }

    @Override
    public char next() {
        return content.charAt(current++);
    }

    @Override
    public boolean hasNext() {
        return current < length;
    }
}
