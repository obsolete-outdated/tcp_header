library tcp_header;

import 'dart:typed_data';

const int _headerLength = 4;
const int _byteArrayStart = 0;

Uint8List dataWithTCPHeader(final Uint8List data) => Uint8List.fromList(((Uint8List(_headerLength)..buffer.asByteData().setUint32(_byteArrayStart, data.length + _headerLength)).followedBy(data)).toList());

bool dataWithTCPHeaderCanBeDecoded(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.length>_headerLength && dataWithTCPHeader.length == dataWithTCPHeader.buffer.asByteData().getUint32(_byteArrayStart);

Uint8List dataFromDataWithTCPHeader(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.sublist(_headerLength);

bool headerCanBeExtracted(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.length>=_headerLength;

int lengthHeaderFromData(final Uint8List dataWithTCPHeader) => dataWithTCPHeader.sublist(_byteArrayStart, _headerLength).buffer.asByteData().getUint32(_byteArrayStart);

class MessageDecoder{
  static const int _maxMessageLength = 0xffffff;
  static const bool _sanityUncheckedDefault = true;
  static final Uint8List _dataDefault = Uint8List(0);

  Uint8List _data = _dataDefault;
  bool _sanityUnchecked = _sanityUncheckedDefault;

  void _reset(){
    _data = _dataDefault;
    _sanityUnchecked = _sanityUncheckedDefault;
  }

  void addData(final Uint8List newData){
    _data = Uint8List.fromList(_data.followedBy(newData).toList());

    if(_sanityUnchecked){
      if(headerCanBeExtracted(_data)){
        if(lengthHeaderFromData(_data) > _maxMessageLength){
          throw 'Message is too big';
        } else {
          _sanityUnchecked = false;
        }
      }
    }
  }

  bool get canDecode => dataWithTCPHeaderCanBeDecoded(_data);

  Uint8List get decode {
    final Uint8List decodedData = dataFromDataWithTCPHeader(_data);
    _reset();
    return decodedData;
  }
}