import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Exception for steganography-related errors
class SteganographyException implements Exception {
  final String message;
  SteganographyException(this.message);

  @override
  String toString() => 'SteganographyException: $message';
}

/// LSB (Least Significant Bit) Steganography Engine
class StegoEngine {
  /// Magic number to identify encoded images
  static const int _magicNumber = 0x43434B; // "CCK" in hex (CipherKeep)

  /// Encodes a message into image bytes using LSB steganography
  static Future<Uint8List> encodeMessage(
      Uint8List imageBytes, String message) async {
    try {
      // Decode image
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw SteganographyException('Failed to decode image');
      }

      // Check if message can fit
      if (!_canFitMessage(image, message)) {
        throw SteganographyException(
          'Message too large for image. Max capacity: ${_getCapacity(image)} chars, Message: ${message.length} chars',
        );
      }

      // Convert message to binary with header
      final messageBinary = _createMessageWithHeader(message);

      // Encode message into image
      final encodedImage = _embedBitsInImage(image, messageBinary);

      // Encode back to PNG
      return Uint8List.fromList(img.encodePng(encodedImage));
    } catch (e) {
      if (e is SteganographyException) rethrow;
      throw SteganographyException('Encoding failed: $e');
    }
  }

  /// Decodes a message from encoded image bytes
  static Future<String> decodeMessage(Uint8List imageBytes) async {
    try {
      // Decode image
      final image = img.decodeImage(imageBytes.buffer.asUint8List());

      if (image == null) {
        throw SteganographyException('Failed to decode image');
      }

      // Extract bits from image
      final extractedBits = _extractBitsFromImage(image);

      // Parse header and message
      final message = _parseMessageWithHeader(extractedBits);

      return message;
    } catch (e) {
      if (e is SteganographyException) rethrow;
      throw SteganographyException('Decoding failed: $e');
    }
  }

  /// Checks if a message can fit in the image
  static bool _canFitMessage(img.Image image, String message) {
    final capacity = _getCapacity(image);
    return message.length <= capacity;
  }

  /// Calculates the maximum message capacity of an image (in characters)
  static int _getCapacity(img.Image image) {
    // Each pixel can store 3 bits (1 per RGB channel)
    // We need 8 bits per character
    // Plus header: 24 bits (magic) + 32 bits (length) = 56 bits
    final totalPixels = image.width * image.height;
    final availableBits = (totalPixels * 3) - 56; // Reserve bits for header
    return availableBits ~/ 8; // Convert to bytes/characters
  }

  /// Creates message binary with header (magic number + length + message)
  static String _createMessageWithHeader(String message) {
    final messageBytes = utf8.encode(message);
    final messageLength = messageBytes.length;

    // Create header: magic number (24 bits) + message length (32 bits)
    final magicBinary = _magicNumber.toRadixString(2).padLeft(24, '0');
    final lengthBinary = messageLength.toRadixString(2).padLeft(32, '0');
    final messageBinary = _stringToBinary(message);

    return magicBinary + lengthBinary + messageBinary;
  }

  /// Parses message from binary with header validation
  static String _parseMessageWithHeader(String binaryData) {
    // Extract magic number (first 24 bits)
    final magicBinary = binaryData.substring(0, 24);
    final magic = int.parse(magicBinary, radix: 2);

    if (magic != _magicNumber) {
      throw SteganographyException('Invalid or corrupted encoded image');
    }

    // Extract message length (next 32 bits)
    final lengthBinary = binaryData.substring(24, 56);
    final messageLength = int.parse(lengthBinary, radix: 2);

    // Extract message (next messageLength * 8 bits)
    final messageBinary = binaryData.substring(56, 56 + (messageLength * 8));
    final message = _binaryToString(messageBinary);

    return message;
  }

  /// Embeds binary data into image using LSB
  static img.Image _embedBitsInImage(img.Image image, String binaryData) {
    final result = img.Image.from(image);
    int bitIndex = 0;

    for (int y = 0; y < result.height && bitIndex < binaryData.length; y++) {
      for (int x = 0; x < result.width && bitIndex < binaryData.length; x++) {
        final pixel = result.getPixel(x, y);

        // Get RGB values
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        // Embed bit in R channel
        if (bitIndex < binaryData.length) {
          r = _setBit(r, binaryData[bitIndex] == '1');
          bitIndex++;
        }

        // Embed bit in G channel
        if (bitIndex < binaryData.length) {
          g = _setBit(g, binaryData[bitIndex] == '1');
          bitIndex++;
        }

        // Embed bit in B channel
        if (bitIndex < binaryData.length) {
          b = _setBit(b, binaryData[bitIndex] == '1');
          bitIndex++;
        }

        // Set modified pixel
        result.setPixelRgba(x, y, r, g, b, pixel.a.toInt());
      }
    }

    return result;
  }

  /// Extracts bits from image using LSB
  static String _extractBitsFromImage(img.Image image) {
    final bits = StringBuffer();

    // First, extract header to get message length
    // We need 56 bits for header (24 magic + 32 length)
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        // Extract LSB from R, G, B channels
        bits.write(_getBit(pixel.r.toInt()) ? '1' : '0');
        bits.write(_getBit(pixel.g.toInt()) ? '1' : '0');
        bits.write(_getBit(pixel.b.toInt()) ? '1' : '0');

        // Once we have 56 bits, we can determine total length needed
        if (bits.length == 56) {
          final lengthBinary = bits.toString().substring(24, 56);
          final messageLength = int.parse(lengthBinary, radix: 2);
          final totalBitsNeeded = 56 + (messageLength * 8);

          // Continue extracting until we have all bits
          for (int y2 = y;
              y2 < image.height && bits.length < totalBitsNeeded;
              y2++) {
            for (int x2 = (y2 == y ? x + 1 : 0);
                x2 < image.width && bits.length < totalBitsNeeded;
                x2++) {
              final p = image.getPixel(x2, y2);
              bits.write(_getBit(p.r.toInt()) ? '1' : '0');
              if (bits.length >= totalBitsNeeded) break;
              bits.write(_getBit(p.g.toInt()) ? '1' : '0');
              if (bits.length >= totalBitsNeeded) break;
              bits.write(_getBit(p.b.toInt()) ? '1' : '0');
            }
          }

          return bits.toString();
        }
      }
    }

    return bits.toString();
  }

  /// Converts string to binary representation
  static String _stringToBinary(String text) {
    final bytes = utf8.encode(text);
    return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  }

  /// Converts binary representation to string
  static String _binaryToString(String binary) {
    final bytes = <int>[];
    for (int i = 0; i < binary.length; i += 8) {
      final byte = binary.substring(i, i + 8);
      bytes.add(int.parse(byte, radix: 2));
    }
    return utf8.decode(bytes);
  }

  /// Sets the LSB of a byte
  static int _setBit(int byte, bool bit) {
    return bit ? (byte | 1) : (byte & ~1);
  }

  /// Gets the LSB of a byte
  static bool _getBit(int byte) {
    return (byte & 1) == 1;
  }
}
