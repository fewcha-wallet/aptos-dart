// import 'package:aptosdart/core/resources/resource.dart';
// import 'package:aptosdart/sdk/src/repository/ipfs_repository/ipfs_repository.dart';
//
// class ANSClient {
//   late IPFSRepo _ipfsRepo;
//   ANSClient() {
//     _ipfsRepo = IPFSRepo();
//   }
//   Future<ANSProfile> getANSProfile(String address) async {
//     try {
//       final add = address.split('/').last;
//       final result = await _ipfsRepo.getANSProfile(add);
//       return result;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<ANSProfile> getSUINFT(String address) async {
//     try {
//       final add = address.split('/').last;
//       final result = await _ipfsRepo.getANSProfile(add);
//       return result;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
