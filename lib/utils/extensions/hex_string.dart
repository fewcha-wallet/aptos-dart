extension HexString on String {
  String toHexString() {
    if (startsWith('0x')) {
      return this;
    }
    return '0x$this';
  }
}
