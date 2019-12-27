import 'dart:typed_data';

import 'package:tcp_header/tcp_header.dart';

Uint8List buffer = Uint8List(0);
bool sanityChecked = false;

void onReceiveDataFromTCPSocket(final List<int> data){
  buffer = Uint8List.fromList(buffer.followedBy(data).toList());

  if(!sanityChecked){
    if(headerCanBeExtracted(data)){
      final int messageLength = lengthHeaderFromData(data);
      if(messageLength > 0xFFFFFF+1){ //if the client intends to send more than 16 megabytes
        //socket.destroy();
      } else {
        sanityChecked = true;
      }
    }
  }

  if(dataWithTCPHeaderCanBeDecoded(buffer)){
    final Uint8List allBytes = dataFromDataWithTCPHeader(buffer);
    //work(allBytes);
    buffer = Uint8List(0);
  } else {
    //wait for another chunk of data
  }
}