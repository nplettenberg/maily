import 'package:maily/api/api.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationService extends Mock
    implements GoogleAuthenticationService {}

class MockAuthorizationService extends Mock
    implements GoogleAuthorizationService {}
