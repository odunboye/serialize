// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'list.dart';

// // **************************************************************************
// // JsonModelGenerator
// // **************************************************************************

// @generatedSerializable
// class Zoo extends _Zoo {
//   Zoo({List<dynamic> birds}) : this.birds = List.unmodifiable(birds ?? []);

//   @override
//   List<dynamic> birds;

//   Zoo copyWith({List<dynamic> birds}) {
//     return Zoo(birds: birds ?? this.birds);
//   }

//   bool operator ==(other) {
//     return other is _Zoo &&
//         ListEquality<dynamic>(DefaultEquality()).equals(other.birds, birds);
//   }

//   @override
//   int get hashCode {
//     return hashObjects([birds]);
//   }

//   @override
//   String toString() {
//     return "Zoo(birds=$birds)";
//   }

//   Map<String, dynamic> toJson() {
//     return ZooSerializer.toMap(this);
//   }
// }

// // **************************************************************************
// // SerializerGenerator
// // **************************************************************************

// const ZooSerializer zooSerializer = ZooSerializer();

// class ZooEncoder extends Converter<Zoo, Map> {
//   const ZooEncoder();

//   @override
//   Map convert(Zoo model) => ZooSerializer.toMap(model);
// }

// class ZooDecoder extends Converter<Map, Zoo> {
//   const ZooDecoder();

//   @override
//   Zoo convert(Map map) => ZooSerializer.fromMap(map);
// }

// class ZooSerializer extends Codec<Zoo, Map> {
//   const ZooSerializer();

//   @override
//   get encoder => const ZooEncoder();
//   @override
//   get decoder => const ZooDecoder();
//   static Zoo fromMap(Map map) {
//     return Zoo(
//         birds: map['birds'] is Iterable
//             ? (map['birds'] as Iterable).cast<dynamic>().toList()
//             : null);
//   }

//   static Map<String, dynamic> toMap(_Zoo model) {
//     if (model == null) {
//       return null;
//     }
//     return {'birds': model.birds};
//   }
// }

// abstract class ZooFields {
//   static const List<String> allFields = <String>[birds];

//   static const String birds = 'birds';
// }
