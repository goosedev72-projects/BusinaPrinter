import 'dart:typed_data';
import 'dart:convert';

class BleCommands {
  static const int PRINT_WIDTH = 384; // Standard width for cat printers

  // Commands based on iPrint app BluetoothOrder class
  static const List<int> CMD_GET_DEV_STATE = [0x51, 0x78, 0xa3, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff];
  static const List<int> CMD_SET_QUALITY_3 = [0x51, 0x78, 0xa4, 0x00, 0x01, 0x00, 0x33, -103, 0xff]; // quality3 from iPrint: [81, 120, -92, 0, 1, 0, 51, -103, -1]
  static const List<int> CMD_GET_DEV_INFO = [0x51, 0x78, 0x78, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff];
  static const List<int> CMD_LATTICE_START = [0x51, 0x78, 0xa6, 0x00, 0x0b, 0x00, 0xaa, 0x55, 0x17, 0x38, 0x44, 0x5f, 0x5f, 0x5f, 0x44, 0x38, 0x2c, 0x91, 0xff]; // matches iPrint
  static const List<int> CMD_LATTICE_END = [0x51, 0x78, 0xa6, 0x00, 0x0b, 0x00, 0xaa, 0x55, 0x17, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17, 0x11, 0xff]; // matches iPrint
  static const List<int> CMD_SET_PAPER = [0x51, 0x78, 0x9d, 0x00, 0x02, 0x00, 0x30, 0x00, 0xf9, 0xff]; // matches iPrint
  static const List<int> CMD_PRINT_IMG = [0x51, 0x78, 0xbe, 0x00, 0x01, 0x00, 0x00, 0x00, 0xff]; // matches iPrint
  static const List<int> CMD_PRINT_TEXT = [0x51, 0x78, 0xbe, 0x00, 0x01, 0x00, 0x01, 0x07, 0xff]; // matches iPrint

  static const List<int> CHECKSUM_TABLE = [
    0, 7, 14, 9, 28, 27, 18, 21, 56, 63, 54, 49, 36, 35, 42, 45, 112, 119, 126, 121,
    108, 107, 98, 101, 72, 79, 70, 65, 84, 83, 90, 93, -32, -25, -18, -23, -4, -5,
    -14, -11, -40, -33, -42, -47, -60, -61, -54, -51, -112, -105, -98, -103, -116,
    -117, -126, -123, -88, -81, -90, -95, -76, -77, -70, -67, -57, -64, -55, -50,
    -37, -36, -43, -46, -1, -8, -15, -10, -29, -28, -19, -22, -73, -80, -71, -66,
    -85, -84, -91, -94, -113, -120, -127, -122, -109, -108, -99, -102, 39, 32, 41,
    46, 59, 60, 53, 50, 31, 24, 17, 22, 3, 4, 13, 10, 87, 80, 89, 94, 75, 76, 69, 66,
    111, 104, 97, 102, 115, 116, 125, 122, -119, -114, -121, -128, -107, -110, -101,
    -100, -79, -74, -65, -72, -83, -86, -93, -92, -7, -2, -9, -16, -27, -30, -21, -20,
    -63, -58, -49, -56, -35, -38, -45, -44, 105, 110, 103, 96, 117, 114, 123, 124, 81,
    86, 95, 88, 77, 74, 67, 68, 25, 30, 23, 16, 5, 2, 11, 12, 33, 38, 47, 40, 61, 58,
    51, 52, 78, 73, 64, 71, 82, 85, 92, 91, 118, 113, 120, 127, 106, 109, 100, 99, 62,
    57, 48, 55, 34, 37, 44, 43, 6, 1, 8, 15, 26, 29, 20, 19, -82, -87, -96, -89, -78,
    -75, -68, -69, -106, -111, -104, -97, -118, -115, -124, -125, -34, -39, -48, -41,
    -62, -59, -52, -53, -26, -31, -24, -17, -6, -3, -12, -13,
  ];

  /// Calculate checksum for a command sequence (based on iPrint app's calcCrc8 method)
  static int calcChecksum(List<int> data, int offset, int length) {
    int checksum = 0;
    for (int i = offset; i < offset + length && i < data.length; i++) {
      // Convert both values to unsigned bytes before XOR
      int dataByte = data[i] & 0xff;
      int tableIndex = (checksum ^ dataByte) & 0xff;
      checksum = CHECKSUM_TABLE[tableIndex];
    }
    return checksum;
  }

  /// Convert signed byte values to unsigned
  static int _toUnsignedByte(int val) {
    return val >= 0 ? val : (val & 0xff);
  }

  /// Create feed paper command
  static Uint8List cmdFeedPaper(int howMuch) {
    final bArr = Uint8List.fromList([
      0x51,
      0x78,
      0xbd,
      0x00,
      0x01,
      0x00,
      howMuch & 0xff,
      0x00,
      0xff,
    ]);
    bArr[7] = calcChecksum(bArr, 6, 1);
    return bArr;
  }

  /// Create set energy command
  static Uint8List cmdSetEnergy(int val) {
    final bArr = Uint8List.fromList([
      0x51,
      0x78,
      0xaf,
      0x00,
      0x02,
      0x00,
      (val >> 8) & 0xff,
      val & 0xff,
      0,
      0xff,
    ]);
    bArr[8] = calcChecksum(bArr, 6, 2);
    return bArr;
  }

  /// Create apply energy command
  static Uint8List cmdApplyEnergy() {
    final bArr = Uint8List.fromList([
      0x51,
      0x78,
      0xbe,
      0x00,
      0x01,
      0x00,
      0x01,
      0x00,
      0xff,
    ]);
    bArr[7] = calcChecksum(bArr, 6, 1);
    return bArr;
  }

  /// Encode run length repetition
  static List<int> _encodeRunLengthRepetition(int n, int val) {
    final res = <int>[];
    while (n > 0x7f) {
      res.add(0x7f | (val << 7));
      n -= 0x7f;
    }
    if (n > 0) {
      res.add((val << 7) | n);
    }
    return res;
  }

  /// Run-length encode image row
  static List<int> runLengthEncode(List<bool> imgRow) {
    final res = <int>[];
    int count = 0;
    bool? lastVal;
    for (bool val in imgRow) {
      if (val == lastVal) {
        count += 1;
      } else {
        if (lastVal != null) {
          res.addAll(_encodeRunLengthRepetition(count, lastVal ? 1 : 0));
        }
        count = 1;
      }
      lastVal = val;
    }
    if (count > 0 && lastVal != null) {
      res.addAll(_encodeRunLengthRepetition(count, lastVal ? 1 : 0));
    }
    return res;
  }

  /// Byte encode image row 
  static List<int> byteEncode(List<bool> imgRow) {
    final res = <int>[];
    for (int chunkStart = 0; chunkStart < imgRow.length; chunkStart += 8) {
      int byte = 0;
      for (int bitIndex = 0; bitIndex < 8; bitIndex++) {
        if (chunkStart + bitIndex < imgRow.length && imgRow[chunkStart + bitIndex]) {
          byte |= 1 << bitIndex;  // Match Python catprinter bit order
        }
      }
      res.add(byte);
    }
    return res;
  }

  /// Create print row command (based on iPrint app format)
  static Uint8List cmdPrintRow(List<bool> imgRow) {
    // Based on iPrint's eachLinePixToCmdC method, always use the fixed-length encoding format
    // Use command ID 0xA2 (-94 signed) to send image data
    final encodedImgBytes = byteEncode(imgRow);
    final bArr = Uint8List.fromList([
      0x51,
      0x78,
      0xa2,  // Command ID for image data (same as iPrint)
      0x00,
      encodedImgBytes.length & 0xff,  // Low byte of length
      0x00, // Always 0 for the high byte in iPrint
      ...encodedImgBytes,
      0, // placeholder for checksum
      0xff
    ]);
    bArr[bArr.length - 2] = calcChecksum(bArr, 6, encodedImgBytes.length);
    return bArr;
  }

  /// Generate print commands for an image (based on iPrint app format)
  static Uint8List generatePrintCommands(List<List<bool>> img, {int energy = 0xffff}) {
    final data = <int>[
      ...CMD_GET_DEV_STATE,
      ...CMD_SET_QUALITY_3,  // Using quality3 from iPrint app instead of 200 DPI
      ...cmdSetEnergy(energy),
      ...cmdApplyEnergy(),
      ...CMD_LATTICE_START,
    ];
    
    for (final row in img) {
      data.addAll(cmdPrintRow(row));
    }
    
    data.addAll([
      ...cmdFeedPaper(25),
      ...CMD_SET_PAPER,
      ...CMD_SET_PAPER,
      ...CMD_SET_PAPER,
      ...CMD_LATTICE_END,
      ...CMD_GET_DEV_STATE
    ]);
    
    return Uint8List.fromList(data);
  }
  
  /// Generate print commands for text (placeholder - text is converted to image first)
  static Uint8List generateTextPrintCommands(String text, {int energy = 0xffff}) {
    final data = <int>[
      ...CMD_GET_DEV_STATE,
      ...CMD_SET_QUALITY_3,
      ...cmdSetEnergy(energy),
      ...cmdApplyEnergy(),
      ...CMD_LATTICE_START,
      ...CMD_PRINT_TEXT,
      ...utf8.encode(text),
      ...cmdFeedPaper(25),
      ...CMD_SET_PAPER,
      ...CMD_SET_PAPER,
      ...CMD_SET_PAPER,
      ...CMD_LATTICE_END,
      ...CMD_GET_DEV_STATE
    ];
    
    return Uint8List.fromList(data);
  }
}