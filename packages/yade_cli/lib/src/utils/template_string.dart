class TemplateString {
  TemplateString(String template)
      : fixedComponents = <String>[],
        genericComponents = <int, String>{},
        totalComponents = 0 {
    final components = template.split('{');

    for (final component in components) {
      if (component == '') {
        continue; // If the template starts with "{", skip the first element.
      }

      final split = component.split('}');

      if (split.length != 1) {
        // The condition allows for template strings without parameters.
        genericComponents[totalComponents] = split.first;
        totalComponents++;
      }

      if (split.last != '') {
        fixedComponents.add(split.last);
        totalComponents++;
      }
    }
  }

  final List<String> fixedComponents;
  final Map<int, String> genericComponents;

  int totalComponents;

  String format(Map<String, dynamic> params) {
    var result = '';

    var fixedComponent = 0;
    for (var i = 0; i < totalComponents; i++) {
      if (genericComponents.containsKey(i)) {
        result += '${params[genericComponents[i]]}';
        continue;
      }
      result += fixedComponents[fixedComponent++];
    }

    return result;
  }
}
