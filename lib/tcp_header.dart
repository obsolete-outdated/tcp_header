library tcp_header;

import 'dart:typed_data';

const int _headerLength = 4;
const int _byteArrayStart = 0;

Uint8List dataWithTCPHeader(final Uint8List data) => Uint8List.fromList(((Uint8List(_headerLength)..buffer.asByteData().setUint32(_byteArrayStart, data.length + _headerLength)).followedBy(data)).toList());

bool dataWithTCPHeaderCanBeDecoded(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.length>_headerLength && dataWithTCPHeader.length == dataWithTCPHeader.buffer.asByteData().getUint32(_byteArrayStart);

Uint8List dataFromDataWithTCPHeader(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.sublist(_headerLength);

bool headerCanBeExtracted(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.length>=_headerLength;

int lengthHeaderFromData(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.sublist(_byteArrayStart, _headerLength).buffer.asByteData().getUint32(_byteArrayStart);