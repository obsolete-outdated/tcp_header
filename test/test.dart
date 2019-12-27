import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:tcp_header/tcp_header.dart';

void main(){
  test("tcp header", (){
    final Uint8List data = Uint8List.fromList(const [1,2,111,23,242,0, 24 ,123,11 ,32,87 ,4, 12]);
    expect(dataWithTCPHeader(data).length, equals(data.length+4));
    expect(dataFromDataWithTCPHeader(dataWithTCPHeader(data)), equals(data));
    expect(dataWithTCPHeaderCanBeDecoded(dataWithTCPHeader(data)), equals(true));
    expect(dataWithTCPHeaderCanBeDecoded(dataWithTCPHeader(data).sublist(0, dataWithTCPHeader(data).length - 1)), equals(false));
  });
}