// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:isar_community/isar.dart';

import '../../../core/operations/math_operations.dart';

part 'subscribe.g.dart';

//--------SUBSCRIBE MODEL FOR LOCAL SAVING--------//
// `flutter pub run build_runner build` to generate file

@Collection()
class Subscribe {
  late String id;
  // Use composite key: id + profileName for unique identification per profile
  @Index(unique: true, composite: [CompositeIndex('profileName')])
  Id get isarId => fastHash('${id}_$profileName');
  late String channelName;
  late bool? isVerified;
  @Index()
  String profileName;
  Subscribe({
    required this.id,
    required this.channelName,
    this.isVerified,
    this.profileName = 'default',
  });
}
