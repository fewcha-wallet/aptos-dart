import 'package:aptosdart/network/decodable.dart';

class CollectionsItemProperties extends Decoder<CollectionsItemProperties> {
  DefaultProperties? defaultProperties;
  String? description;
  String? largestPropertyVersion;
  String? maximum;
  MutabilityConfig? mutabilityConfig;
  String? name;
  Royalty? royalty;
  String? supply;
  String? uri;

  CollectionsItemProperties(
      {this.defaultProperties,
      this.description,
      this.largestPropertyVersion,
      this.maximum,
      this.mutabilityConfig,
      this.name,
      this.royalty,
      this.supply,
      this.uri});

  CollectionsItemProperties.fromJson(Map<String, dynamic> json) {
    defaultProperties = json['default_properties'] != null
        ? DefaultProperties.fromJson(json['default_properties'])
        : null;
    description = json['description'];
    largestPropertyVersion = json['largest_property_version'];
    maximum = json['maximum'];
    mutabilityConfig = json['mutability_config'] != null
        ? MutabilityConfig.fromJson(json['mutability_config'])
        : null;
    name = json['name'];
    royalty =
        json['royalty'] != null ? Royalty.fromJson(json['royalty']) : null;
    supply = json['supply'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (defaultProperties != null) {
      data['default_properties'] = defaultProperties!.toJson();
    }
    data['description'] = description;
    data['largest_property_version'] = largestPropertyVersion;
    data['maximum'] = maximum;
    if (mutabilityConfig != null) {
      data['mutability_config'] = mutabilityConfig!.toJson();
    }
    data['name'] = name;
    if (royalty != null) {
      data['royalty'] = royalty!.toJson();
    }
    data['supply'] = supply;
    data['uri'] = uri;
    return data;
  }

  @override
  CollectionsItemProperties decode(Map<String, dynamic> json) {
    return CollectionsItemProperties.fromJson(json);
  }
}

class DefaultProperties extends Decoder<DefaultProperties> {
  PropertiesMap? propertiesMapData;

  DefaultProperties({this.propertiesMapData});

  DefaultProperties.fromJson(Map<String, dynamic> json) {
    propertiesMapData =
        json['map'] != null ? PropertiesMap.fromJson(json['map']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (propertiesMapData != null) {
      data['map'] = propertiesMapData!.toJson();
    }
    return data;
  }

  @override
  DefaultProperties decode(Map<String, dynamic> json) {
    return DefaultProperties.fromJson(json);
  }
}

class PropertiesMap extends Decoder<PropertiesMap> {
  List<PropertiesData>? data;

  PropertiesMap({this.data});

  PropertiesMap.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PropertiesData>[];
      json['data'].forEach((v) {
        data!.add(PropertiesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  PropertiesMap decode(Map<String, dynamic> json) {
    return PropertiesMap.fromJson(json);
  }
}

class PropertiesData extends Decoder<PropertiesData> {
  String? key;
  PropertiesValue? value;

  PropertiesData({this.key, this.value});

  PropertiesData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value =
        json['value'] != null ? PropertiesValue.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    if (value != null) {
      data['value'] = value!.toJson();
    }
    return data;
  }

  @override
  PropertiesData decode(Map<String, dynamic> json) {
    return PropertiesData.fromJson(json);
  }
}

class PropertiesValue extends Decoder<PropertiesValue> {
  String? type;
  String? value;

  PropertiesValue({this.type, this.value});

  PropertiesValue.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }

  @override
  PropertiesValue decode(Map<String, dynamic> json) {
    return PropertiesValue.fromJson(json);
  }
}

class MutabilityConfig extends Decoder<MutabilityConfig> {
  bool? description, maximum, properties, royalty, uri;

  MutabilityConfig(
      {this.description,
      this.maximum,
      this.properties,
      this.royalty,
      this.uri});

  MutabilityConfig.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    maximum = json['maximum'];
    properties = json['properties'];
    royalty = json['royalty'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['maximum'] = maximum;
    data['properties'] = properties;
    data['royalty'] = royalty;
    data['uri'] = uri;
    return data;
  }

  @override
  MutabilityConfig decode(Map<String, dynamic> json) {
    return MutabilityConfig.fromJson(json);
  }
}

class Royalty extends Decoder<Royalty> {
  String? payeeAddress;
  String? royaltyPointsDenominator;
  String? royaltyPointsNumerator;

  Royalty(
      {this.payeeAddress,
      this.royaltyPointsDenominator,
      this.royaltyPointsNumerator});

  Royalty.fromJson(Map<String, dynamic> json) {
    payeeAddress = json['payee_address'];
    royaltyPointsDenominator = json['royalty_points_denominator'];
    royaltyPointsNumerator = json['royalty_points_numerator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payee_address'] = payeeAddress;
    data['royalty_points_denominator'] = royaltyPointsDenominator;
    data['royalty_points_numerator'] = royaltyPointsNumerator;
    return data;
  }

  @override
  Royalty decode(Map<String, dynamic> json) {
    return Royalty.fromJson(json);
  }
}
