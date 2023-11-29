class GraphQLUtils {
  static Map<String, dynamic> createGraphQLPayload({
    required String operationName,
    required String address,
    required String query,
    int? offset,
    int? limit,
  }) {
    final map = {
      "operationName": operationName,
      "variables": {
        "address": address,
        "offset": offset,
        "limit": limit,
      },
      "query": query,
    };
    return map;
  }

  static Map<String, dynamic> createNFTGraphQLPayload({
    required String operationName,
    required String address,
    required String query,
    int? offset,
    int? limit,
  }) {
    final map = {
      "operationName": operationName,
      "variables": {
        "account_address": address,
        "offset": offset,
      },
      "query": query,
    };
    return map;
  }
}
