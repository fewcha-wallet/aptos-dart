import 'package:aptosdart/constant/constant_value.dart';
import 'package:aptosdart/core/coin/coin.dart';
import 'package:aptosdart/core/data_model/data_model.dart';
import 'package:aptosdart/core/event_handle_struct/event_handle_struct.dart';
import 'package:aptosdart/core/supply/supply.dart';
import 'package:aptosdart/network/decodable.dart';
import 'package:aptosdart/utils/validator/validator.dart';

// class Resource extends Decoder<Resource> {
//   String? type;
//   DataModel? data;
//
//   Resource({this.type, this.data});
//
//   @override
//   Resource decode(Map<String, dynamic> json) {
//     return Resource.fromJson(json);
//   }
//
//   Resource.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     data = json['data'] != null ? DataModel?.fromJson(json['data']) : null;
//   }
// }

class ResourceNew extends Decoder<ResourceNew> {
  String? type;
  DataModelAbstract? data;

  ResourceNew({this.type, this.data});

  @override
  ResourceNew decode(Map<String, dynamic> json) {
    return ResourceNew.fromJson(json);
  }

  ResourceNew.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data =
        json['data'] != null ? getDataByType(json['type'], json['data']) : null;
  }
  DataModelAbstract getDataByType(String type, Map<String, dynamic> json) {
    if (Validator.validatorByRegex(
        regExp: Validator.coinStructType, data: type.toString())) {
      return AptosCoin.fromJson(json);
    } else if (type
        .toString()
        .toLowerCase()
        .startsWith(AppConstants.coinInfo.toLowerCase())) {
      return Token.fromJson(json);
    } else if (type
        .toString()
        .toLowerCase()
        .contains(AppConstants.account.toLowerCase())) {
      return AptosAccountData.fromJson(json);
    } else if (type
        .toString()
        .toLowerCase()
        .contains(AppConstants.ansProfile.toLowerCase())) {
      return ANS.fromJson(json);
    }
    return Token.fromJson(json);
  }
}

abstract class DataModelAbstract extends Decoder<DataModelAbstract> {}

class Token extends DataModelAbstract {
  int? decimals;
  String? name;
  Supply? supply;
  String? symbol;

  Token({this.decimals, this.name, this.supply, this.symbol});

  Token.fromJson(Map<String, dynamic> json) {
    decimals = json['decimals'];
    name = json['name'];
    // supply = json['supply'] != null ? Supply.fromJson(json['supply']) : null;
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decimals'] = decimals;
    data['name'] = name;
    data['symbol'] = symbol;
    return data;
  }

  @override
  DataModelAbstract decode(Map<String, dynamic> json) {
    return Token.fromJson(json);
  }
}

class ANS extends DataModelAbstract {
  String? name, profile, ansAvatar;

  ANS({this.profile, this.name, this.ansAvatar});

  ANS.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profile'] = profile;
    return data;
  }

  @override
  DataModelAbstract decode(Map<String, dynamic> json) {
    return ANS.fromJson(json);
  }
}

class ANSProfile extends Decoder<ANSProfile> {
  String? avatar, businessName, country, gender, birthday;

  ANSProfile(
      {this.avatar,
      this.businessName,
      this.country,
      this.gender,
      this.birthday});

  ANSProfile.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    businessName = json['business_name'];
    country = json['country'];
    gender = json['gender'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['business_name'] = businessName;
    data['country'] = country;
    data['gender'] = gender;
    data['birthday'] = birthday;
    return data;
  }

  @override
  ANSProfile decode(Map<String, dynamic> json) {
    return ANSProfile.fromJson(json);
  }
}

class AptosCoin extends DataModelAbstract {
  Coin? coin;
  EventHandleStruct? depositEvents, withdrawEvents;
  AptosCoin({
    this.coin,
    this.depositEvents,
    this.withdrawEvents,
  });

  AptosCoin.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] != null ? Coin?.fromJson(json['coin']) : null;
    depositEvents = json['deposit_events'] != null
        ? EventHandleStruct?.fromJson(json['deposit_events'])
        : null;
    withdrawEvents = json['withdraw_events'] != null
        ? EventHandleStruct?.fromJson(json['withdraw_events'])
        : null;
  }
  @override
  DataModelAbstract decode(Map<String, dynamic> json) {
    return AptosCoin.fromJson(json);
  }

  AptosName toAptosName(String name, String symbol) {
    return AptosName(
        name: name,
        symbol: symbol,
        coin: coin,
        depositEvents: depositEvents,
        withdrawEvents: withdrawEvents);
  }
}

class AptosName extends AptosCoin {
  String? name, symbol;
  AptosName(
      {this.name,
      this.symbol,
      Coin? coin,
      EventHandleStruct? depositEvents,
      withdrawEvents})
      : super(
            coin: coin,
            depositEvents: depositEvents,
            withdrawEvents: withdrawEvents);
}

class AptosAccountData extends DataModelAbstract {
  EventHandleStruct? keyRotationEvents, coinRegisterEvents;
  String? authenticationKey, sequenceNumber;

  AptosAccountData(
      {this.keyRotationEvents,
      this.coinRegisterEvents,
      this.authenticationKey,
      this.sequenceNumber});

  AptosAccountData.fromJson(Map<String, dynamic> json) {
    keyRotationEvents = json['key_rotation_events'] != null
        ? EventHandleStruct?.fromJson(json['key_rotation_events'])
        : null;
    coinRegisterEvents = json['coin_register_events'] != null
        ? EventHandleStruct?.fromJson(json['coin_register_events'])
        : null;
    authenticationKey = json['authentication_key'];
    sequenceNumber = json['sequence_number'];
  }
  @override
  DataModelAbstract decode(Map<String, dynamic> json) {
    return AptosAccountData.fromJson(json);
  }
}

class UserResources {
  ResourceNew? aptosCoin, aptosAccountData, tokenInfo, ans;
  List<ResourceNew>? listToken;

  UserResources(
      {this.listToken,
      this.aptosCoin,
      this.aptosAccountData,
      this.tokenInfo,
      this.ans});
}
