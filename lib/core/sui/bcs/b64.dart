import 'dart:typed_data';

int b64ToUint6(int nChr) {
  return nChr > 64 && nChr < 91
      ? nChr - 65
      : nChr > 96 && nChr < 123
          ? nChr - 71
          : nChr > 47 && nChr < 58
              ? nChr + 4
              : nChr == 43
                  ? 62
                  : nChr == 47
                      ? 63
                      : 0;
}

Uint8List fromB64(String sBase64, {int? nBlocksSize}) {
  var sB64Enc = sBase64.replaceAll(RegExp('[^A-Za-z0-9+/]'), ''),
      nInLen = sB64Enc.length,
      nOutLen = nBlocksSize != null
          ? (((nInLen * 3 + 1) >> 2) / nBlocksSize).ceil() * nBlocksSize
          : (nInLen * 3 + 1) >> 2,
      taBytes = Uint8List(nOutLen);

  for (int nMod3, nMod4, nUint24 = 0, nOutIdx = 0, nInIdx = 0;
      nInIdx < nInLen;
      nInIdx++) {
    nMod4 = nInIdx & 3;
    nUint24 |= b64ToUint6(sB64Enc.codeUnitAt(nInIdx)) << (6 * (3 - nMod4));
    if (nMod4 == 3 || nInLen - nInIdx == 1) {
      for (nMod3 = 0; nMod3 < 3 && nOutIdx < nOutLen; nMod3++, nOutIdx++) {
        taBytes[nOutIdx] = (nUint24 >>> ((16 >>> nMod3) & 24)) & 255;
      }
      nUint24 = 0;
    }
  }

  return taBytes;
}

/* Base64 string to array encoding */

int uInt6ToB64(int nUint6) {
  return nUint6 < 26
      ? nUint6 + 65
      : nUint6 < 52
          ? nUint6 + 71
          : nUint6 < 62
              ? nUint6 - 4
              : nUint6 == 62
                  ? 43
                  : nUint6 == 63
                      ? 47
                      : 65;
}

String toB64(Uint8List aBytes) {
  var nMod3 = 2, sB64Enc = '';

  for (var nLen = aBytes.length, nUint24 = 0, nIdx = 0; nIdx < nLen; nIdx++) {
    nMod3 = nIdx % 3;
    if (nIdx > 0 && ((nIdx * 4) / 3) % 76 == 0) {
      sB64Enc += '';
    }
    nUint24 |= aBytes[nIdx] << ((16 >>> nMod3) & 24);
    if (nMod3 == 2 || aBytes.length - nIdx == 1) {
      sB64Enc += String.fromCharCodes([
        uInt6ToB64((nUint24 >>> 18) & 63),
        uInt6ToB64((nUint24 >>> 12) & 63),
        uInt6ToB64((nUint24 >>> 6) & 63),
        uInt6ToB64(nUint24 & 63)
      ]);
      nUint24 = 0;
    }
  }

  return (sB64Enc.substring(0, sB64Enc.length - 2 + nMod3) +
      (nMod3 == 2
          ? ''
          : nMod3 == 1
              ? '='
              : '=='));
}
