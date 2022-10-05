import 'package:aptosdart/core/objects_owned/objects_owned.dart';
import 'package:aptosdart/core/sui_objects/sui_objects.dart';
import 'package:aptosdart/sdk/src/repository/sui_repository/sui_repository.dart';

class SUIClient {
  late SUIRepository _suiRepository;

  SUIClient() {
    _suiRepository = SUIRepository();
  }
  Future<List<ObjectsOwned>> getObjectsOwnedByAddress(String address) async {
    try {
      final result = await _suiRepository.getObjectsOwnedByAddress(address);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<SUIObjects> getObject(String objectIds) async {
    try {
      final result = await _suiRepository.getObject(objectIds);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getAccountBalance(String address) async {
    try {
      double balance = 0;
      final getObjectOwned = await getObjectsOwnedByAddress(address);
      if (getObjectOwned.isNotEmpty) {
        for (var element in getObjectOwned) {
          final objects = await getObject(element.objectId!);
          balance += objects.getBalance();
        }
      }
      return balance;
    } catch (e) {
      rethrow;
    }
  }
}
