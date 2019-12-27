import 'dart:typed_data';

import 'package:tcp_header/tcp_header.dart';

Uint8List buffer = Uint8List(0);

void onReceiveDataFromTCPSocket(final List<int> data){
  buffer = Uint8List.fromList(buffer.followedBy(data).toList());

  if(dataWithTCPHeaderCanBeDecoded(buffer)){
    final Uint8List allBytes = dataFromDataWithTCPHeader(buffer);
    //work(allBytes);
    buffer = Uint8List(0);
  } else {
    //wait for another chunk of data
  }
}