import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maily/components/components.dart';

part 'oauth_flow_result.freezed.dart';

@freezed
class OAuthFlowResult with _$OAuthFlowResult {
  factory OAuthFlowResult({
    required String email,
    required OAuthToken token,
  }) = _OAuthFlowResult;
}
