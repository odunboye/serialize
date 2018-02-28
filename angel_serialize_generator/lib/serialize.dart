part of angel_serialize_generator;

class SerializerGenerator extends GeneratorForAnnotation<Serializable> {
  final bool autoSnakeCaseNames;

  const SerializerGenerator({this.autoSnakeCaseNames: true});

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    if (element.kind != ElementKind.CLASS)
      throw 'Only classes can be annotated with a @Serializable() annotation.';

    var ctx = await buildContext(element, annotation, buildStep,
        await buildStep.resolver, true, autoSnakeCaseNames != false);

    var serializers = annotation.peek('serializers')?.listValue ?? [];

    if (serializers.isEmpty) return null;

    // Check if any serializer is recognized
    if (!serializers.any((s) => Serializers.all.contains(s.toIntValue()))) {
      return null;
    }

    var lib = new File((b) {
      generateClass(serializers.map((s) => s.toIntValue()).toList(), ctx, b);
    });

    var buf = lib.accept(new DartEmitter());
    return buf.toString();
  }

  /// Generate a serializer class.
  void generateClass(
      List<int> serializers, BuildContext ctx, FileBuilder file) {
    file.body.add(new Class((clazz) {
      clazz
        ..name = '${ctx.modelClassNameRecase.pascalCase}Serializer'
        ..abstract = true;

      if (serializers.contains(Serializers.map)) {
        // TODO: Generate fromMap
      }

      if (serializers.contains(Serializers.map) ||
          serializers.contains(Serializers.json)) {
        generateToMapMethod(clazz, ctx, file);
        // TODO: Generate toJson
      }
    }));
  }

  void generateToMapMethod(
      ClassBuilder clazz, BuildContext ctx, FileBuilder file) {
    clazz.methods.add(new Method((method) {
      method
        ..static = true
        ..name = 'toMap'
        ..returns = new Reference('Map<String, dynamic>')
        ..requiredParameters.add(new Parameter((b) {
          b
            ..name = 'model'
            ..type = ctx.modelClassType;
        }));

      var buf = new StringBuffer('return {');
      int i = 0;

      // Add named parameters
      for (var field in ctx.fields) {
        // Skip excluded fields
        if (ctx.excluded[field.name] == true) continue;

        var alias = ctx.resolveFieldName(field.name);

        if (i++ > 0) buf.write(', ');

        String serializedRepresentation = 'model.${field.name}';

        // Serialize dates
        if (dateTimeTypeChecker.isAssignableFromType(field.type))
          serializedRepresentation = 'model.${field.name}.toIso8601String()';

        // Serialize model classes via `XSerializer.toMap`
        else if (isModelClass(field.type)) {
          var rc = new ReCase(field.type.name);
          serializedRepresentation =
              '${rc.pascalCase}Serializer.toMap(model.${field.name})';
        }

        else if (field.type is InterfaceType) {
          var t = field.type as InterfaceType;

          if (t.name == 'List' && t.typeArguments.length == 1) {
            var rc = new ReCase(t.typeArguments[0].name);
            serializedRepresentation = 'model.${field.name}.map(${rc.pascalCase}Serializer.toMap).toList()';
          }

          else if (t.name == 'List' && t.typeArguments.length == 2 && isModelClass(t.typeArguments[1])) {
            // TODO: Serialize maps
          }
        }

        buf.write("'$alias': $serializedRepresentation");
      }

      buf.write('};');
      method.body = new Code(buf.toString());
    }));
  }
}
