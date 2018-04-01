namespace Glagol::DateTime

import Glagol::DateTime::TimeZone;

@typeFactory="\\Glagol\\Bridge\\Lumen\\Value\\DateTimeType"
proxy \Glagol\Bridge\Lumen\Value\DateTime as
value DateTime {
    DateTime();
    DateTime(string now);
    DateTime(string now, TimeZone timezone);
    string format(string format);
    TimeZone getTimezone();
}
