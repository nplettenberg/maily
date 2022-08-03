import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationStateProvider = StateProvider<ApplicationState>(
  (_) => ApplicationState.uninitialized,
);

enum ApplicationState {
  initialized,
  uninitialized,
}
