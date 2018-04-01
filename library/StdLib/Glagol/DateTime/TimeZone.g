namespace Glagol::DateTime

@typeFactory=false
proxy \DateTimeZone as
value TimeZone {
    TimeZone(string timezone);

    string getName();
    int getOffset();
}
