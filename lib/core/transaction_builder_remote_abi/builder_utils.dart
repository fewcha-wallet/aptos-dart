import 'package:aptosdart/core/account_address/account_address.dart';
import 'package:aptosdart/core/type_tag/type_tag.dart';
import 'package:aptosdart/utils/extensions/list_extension.dart';
import 'package:aptosdart/utils/validator/validator.dart';

class TypeTagParser {
  late List<TokenParser> tokens;

  TypeTagParser(String tagStr) {
    tokens = BuilderUtils.tokenize(tagStr);
  }
  TypeTag parseTypeTag() {
    if (tokens.isEmpty) {
      throw ("Invalid type tag.");
    }

    // Pop left most element out
    TokenParser tokenParser = tokens.shift();

    if (tokenParser.tokenValue == "u8") {
      return TypeTagU8();
    }
    if (tokenParser.tokenValue == "u64") {
      return TypeTagU64();
    }
    if (tokenParser.tokenValue == "u128") {
      return TypeTagU128();
    }
    if (tokenParser.tokenValue == "bool") {
      return TypeTagBool();
    }
    if (tokenParser.tokenValue == "address") {
      return TypeTagAddress();
    }
    if (tokenParser.tokenValue == "vector") {
      _consume("<");
      TypeTag res = parseTypeTag();
      _consume(">");
      return TypeTagVector(res);
    }
    if (tokenParser.tokenType == "IDENT" &&
        (tokenParser.tokenValue!.startsWith("0x") ||
            tokenParser.tokenValue!.startsWith("0X"))) {
      String address = tokenParser.tokenValue!;
      _consume("::");
      TokenParser moduleToken = tokens.shift()!;
      if (moduleToken.tokenType != "IDENT") {
        throw ("Invalid type tag.");
      }
      _consume("::");
      TokenParser nameToken = tokens.shift()!;
      if (nameToken.tokenType != "IDENT") {
        throw ("Invalid type tag.");
      }

      List<TypeTag> tyTags = [];
      // Check if the struct has ty args
      if (tokens.isNotEmpty && tokens.first.tokenValue == "<") {
        _consume("<");
        tyTags = _parseCommaList(">", true);
        _consume(">");
      }

      StructTag structTag = StructTag(
        AccountAddress.fromHex(address),
        Identifier(moduleToken.tokenValue!),
        Identifier(nameToken.tokenValue!),
        tyTags,
      );
      return TypeTagStruct(structTag);
    }

    throw ("Invalid type tag.");
  }

  _consume(String targetToken) {
    if (tokens.isEmpty) throw ("Invalid type tag.");

    TokenParser token = tokens.shift();
    if (token.tokenValue != targetToken) {
      throw ("Invalid type tag.");
    }
  }

  List<TypeTag> _parseCommaList(String endToken, bool allowTraillingComma) {
    List<TypeTag> res = [];
    if (tokens.isEmpty) {
      throw ("Invalid type tag.");
    }

    while (tokens.first.tokenValue != endToken) {
      res.add(parseTypeTag());

      if (tokens.isNotEmpty && tokens.first.tokenValue == endToken) {
        break;
      }

      _consume(",");
      if (tokens.isNotEmpty &&
          tokens.first.tokenValue == endToken &&
          allowTraillingComma) {
        break;
      }

      if (tokens.isEmpty) {
        throw ("Invalid type tag.");
      }
    }
    return res;
  }
}

class BuilderUtils {
  static List<TokenParser> tokenize(String tagStr) {
    int pos = 0;
    List<TokenParser> listToken = [];
    while (pos < tagStr.length) {
      TokenNumber tokenNumber = nextToken(tagStr, pos);
      if (tokenNumber.token.tokenType != "SPACE") {
        listToken.add(tokenNumber.token);
      }
      pos += tokenNumber.number;
    }
    return listToken;
  }

  // Returns Token and Token byte size
  static TokenNumber nextToken(String tagStr, int pos) {
    String c = tagStr[pos];
    if (c == ":") {
      if (tagStr.substring(pos, pos + 2) == "::") {
        return TokenNumber(
            token: TokenParser(
              tokenType: "COLON",
              tokenValue: "::",
            ),
            number: 2);
      }
      throw ("Unrecognized token.");
    } else if (c == "<") {
      return TokenNumber(
          token: TokenParser(
            tokenType: "LT",
            tokenValue: "<",
          ),
          number: 1);
    } else if (c == ">") {
      return TokenNumber(
          token: TokenParser(
            tokenType: "GT",
            tokenValue: ">",
          ),
          number: 1);
    } else if (c == ",") {
      return TokenNumber(
          token: TokenParser(
            tokenType: "COMMA",
            tokenValue: ",",
          ),
          number: 1);
    } else if (isWhiteSpace(c)) {
      String res = "";
      for (int i = pos; i < tagStr.length; i += 1) {
        String char = tagStr[i];
        if (isWhiteSpace(char)) {
          res = '$res$char';
        } else {
          break;
        }
      }
      return TokenNumber(
          token: TokenParser(
            tokenType: "SPACE",
            tokenValue: res,
          ),
          number: res.length);
    } else if (isValidAlphabetic(c)) {
      String res = "";
      for (int i = pos; i < tagStr.length; i += 1) {
        String char = tagStr[i];
        if (isValidAlphabetic(char)) {
          res = '$res$char';
        } else {
          break;
        }
      }
      return TokenNumber(
          token: TokenParser(
            tokenType: "IDENT",
            tokenValue: res,
          ),
          number: res.length);
    }
    throw ("Unrecognized token.");
  }

  static bool isWhiteSpace(String c) {
    if (Validator.whiteSpace.hasMatch(c)) {
      return true;
    }
    return false;
  }

  static bool isValidAlphabetic(String c) {
    if (Validator.alphabetic.hasMatch(c)) {
      return true;
    }
    return false;
  }
}

class TokenParser {
  String? tokenType;
  String? tokenValue;

  TokenParser({required this.tokenType, required this.tokenValue});
}

class TokenNumber {
  TokenParser token;
  int number;

  TokenNumber({required this.token, required this.number});
}
