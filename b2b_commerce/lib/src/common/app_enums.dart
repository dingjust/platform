import 'package:models/models.dart';

class AppEnums {
  static const MemberRatingList = <EnumModel>[
    const EnumModel('A', 'A'),
    const EnumModel('B', 'B'),
    const EnumModel('C', 'C'),
  ];

  static const Map<dynamic, EnumModel> MemberRatings = {
    MemberRating.A: const EnumModel('A', 'A'),
    MemberRating.B: const EnumModel('B', 'B'),
    MemberRating.C: const EnumModel('C', 'C'),
  };
}
