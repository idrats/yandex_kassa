/// Common interface for JSON-encodable objects
///
/// JSON encoding is used to tranfer object's state from cleints to server and back
/// and to store datat in noSql databases
abstract class JsonEncodable {
  /// JSON-encodable representation of object which can be encoded with `json.encode()`
  ///
  /// Allowed types:
  /// * [String]
  /// * [num]
  /// * [int]
  /// * [double]
  /// * [bool]
  /// * [List]
  /// * [Map]
  dynamic get json;
}
