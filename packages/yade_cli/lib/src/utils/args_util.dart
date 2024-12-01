import 'package:args/args.dart';

String getProjectIdArg(ArgResults results) {
  return results['project_id'] as String;
}

String getApplicationNameArg(ArgResults results) {
  return results.rest.first;
}

String getOrganizationArg(ArgResults results) {
  return results['organization'] as String;
}

String getEnvironmentArg(ArgResults results) {
  return results['environment'] as String;
}

String getHostnameArg(ArgResults results) {
  return results['hostname'] as String;
}

List<Map<String, String>> getAnsibleCollectionsArg(ArgResults results) {
  final ansibleCollectionsStr = results['ansible_collections'] as String;

  // Split the string by comma and then by colon and create a List of Map
  final ansibleCollections = ansibleCollectionsStr
      .split(',')
      .map((e) => e.split(':'))
      .map(
        (e) => {
          'name': e[0],
          'version': e[1],
        },
      )
      .toList();

  return ansibleCollections;
}

List<Map<String, String>> getAnsibleRoles(ArgResults results) {
  final ansibleRolesStr = results['ansible_roles'] as String?;

  // Split the string by comma and then by colon and create a List of Map
  final ansibleRoles = ansibleRolesStr != null
      ? ansibleRolesStr
          .split(',')
          .map((e) => e.split(':'))
          .map(
            (e) => {
              'name': e[0],
              'version': e[1],
            },
          )
          .toList()
      : <Map<String, String>>[];

  return ansibleRoles;
}

List<String> getCollectionsGitignore(
  List<Map<String, String>> ansibleCollections,
) {
  final collectionsGitignore = <String>[];

  for (final collection in ansibleCollections) {
    final collectionName = collection['name']!;
    final entry =
        '${collectionName.substring(0, collectionName.lastIndexOf('.'))}*';

    collectionsGitignore.add(entry);
  }

  return collectionsGitignore.toSet().toList();
}
