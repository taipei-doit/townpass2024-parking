// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountResponse _$AccountResponseFromJson(Map<String, dynamic> json) =>
    AccountResponse(
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
      reasonPhrase: json['reasonPhrase'] as String,
      account: Account.fromJson(json['data'] as Map<String, dynamic>),
      extra: json['extra'] as String?,
      version: json['version'] as String,
    );

Map<String, dynamic> _$AccountResponseToJson(AccountResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'reasonPhrase': instance.reasonPhrase,
      'data': instance.account.toJson(),
      'extra': instance.extra,
      'version': instance.version,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['id'] as String,
      account: json['account'] as String,
      username: json['username'] as String,
      realName: json['realName'] as String,
      idNumber: json['idNo'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNo'] as String,
      birthday: json['birthday'] as String,
      memberType: json['memberType'] as String,
      verifyLevel: json['verifyLevel'] as String,
      addressList: (json['addresses'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      residentAddress: json['residentAddress'] as String,
      citizen: json['citizen'] as bool,
      nativePeople: json['nativePeople'] as bool,
      cityInternetUid: json['cityInternetUid'] as String,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'username': instance.username,
      'realName': instance.realName,
      'idNo': instance.idNumber,
      'email': instance.email,
      'phoneNo': instance.phoneNumber,
      'birthday': instance.birthday,
      'memberType': instance.memberType,
      'verifyLevel': instance.verifyLevel,
      'addresses': instance.addressList.map((e) => e.toJson()).toList(),
      'residentAddress': instance.residentAddress,
      'citizen': instance.citizen,
      'nativePeople': instance.nativePeople,
      'cityInternetUid': instance.cityInternetUid,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      zip3: (json['zip3'] as num).toInt(),
      city: json['city'] as String,
      town: json['town'] as String,
      village: json['village'] as String,
      street: json['street'] as String,
      usageType: json['usageType'] as String,
      seq: (json['seq'] as num).toInt(),
      priority: json['priority'] as bool,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'zip3': instance.zip3,
      'city': instance.city,
      'town': instance.town,
      'village': instance.village,
      'street': instance.street,
      'usageType': instance.usageType,
      'seq': instance.seq,
      'priority': instance.priority,
    };
