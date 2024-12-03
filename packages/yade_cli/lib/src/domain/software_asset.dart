import 'package:equatable/equatable.dart';

class SoftwareAsset extends Equatable {
  const SoftwareAsset({
    required this.type,
    required this.name,
    required this.version,
    required this.url,
  });

  final SoftwareAssetType type;
  final String name;
  final String version;
  final String url;

  @override
  List<Object?> get props => [type, name, version, url];

  @override
  bool get stringify => true;
}

enum SoftwareAssetType {
  github,
}
