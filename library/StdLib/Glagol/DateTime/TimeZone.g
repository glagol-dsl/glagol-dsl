namespace Glagol::DateTime

proxy \DateTimeZone as
value TimeZone {
    TimeZone(string timezone);

    string getName();
    int getOffset();
}
