///Construct to wrap all dart type to fit with decodable for APICBecause sometime, data isn't response in JSON format (String, int, bool,..).
///Because sometime, data isn't response in JSON format (String, int, bool,..)
class TypeDecodable<T> {
  T? value;
  TypeDecodable({this.value});
}
