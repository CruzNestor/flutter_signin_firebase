import 'package:flutter_test/flutter_test.dart';

import 'package:sign_in_firebase_auth/src/core/platform/network_info.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;

  setUp((){
    networkInfoImpl = NetworkInfoImpl();
  });
  
  test('if is connected, should send true', () async {
    final result = await networkInfoImpl.isConnected;
    expect(result, true);
  });
}