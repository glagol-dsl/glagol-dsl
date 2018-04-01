namespace Glagol::Http

proxy \Illuminate\Http\Request as util Request {
	string \get(string key);
	string \get(string key, string default);
	string input(string key);
	string input(string key, string default);
}
