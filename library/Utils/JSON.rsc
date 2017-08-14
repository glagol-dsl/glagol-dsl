module Utils::JSON

import lang::json::IO;
import lang::json::ast::JSON;

public map[&K, &T] merge(map[&K, &T] a, map[&K, &T] b) {
    for (k <- b) {
        if (a[k]? && object(_) := a[k] && object(_) := b[k]) {
            a[k] = object(merge(a[k].properties, b[k].properties));
        } else {
            a[k] = b[k];
        }
    }
    
    return a;
}
