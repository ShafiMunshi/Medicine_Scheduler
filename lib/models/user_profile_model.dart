import 'package:drift/drift.dart' as drift;
import 'package:medicine_app/data/database/app_database.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String? email;
  final String? gender;
  final int age;
  final double? weight;
  final double? height;
  final String? avatarUrl;
  final String? bloodGroup;
  final String? allergies;
  final String? chronicConditions;
  final String? emergencyContact;
  final String role; // 'patient' or 'parent'
  final String? linkingCode;
  final bool isProfileCompleted;
  final List<String> linkedParentUids;
  final List<String> monitoredPatientUids;
  final DateTime? updatedAt;

  const UserProfileModel({
    required this.uid,
    required this.name,
    this.email,
    this.gender,
    this.age = 25,
    this.weight,
    this.height,
    this.avatarUrl,
    this.bloodGroup,
    this.allergies,
    this.chronicConditions,
    this.emergencyContact,
    this.role = 'patient',
    this.linkingCode,
    this.isProfileCompleted = false,
    this.linkedParentUids = const [],
    this.monitoredPatientUids = const [],
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'avatarUrl': avatarUrl,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'emergencyContact': emergencyContact,
      'role': role,
      'linkingCode': linkingCode,
      'isProfileCompleted': isProfileCompleted,
      'linkedParentUids': linkedParentUids,
      'monitoredPatientUids': monitoredPatientUids,
      'updatedAt': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserProfileModel(
      uid: docId ?? (map['uid'] as String? ?? ''),
      name: (map['name'] as String? ?? 'User').trim().isEmpty ? 'User' : (map['name'] as String? ?? 'User'),
      email: map['email'] as String?,
      gender: map['gender'] as String?,
      age: (map['age'] as num?)?.toInt() ?? 25,
      weight: (map['weight'] as num?)?.toDouble(),
      height: (map['height'] as num?)?.toDouble(),
      avatarUrl: map['avatarUrl'] as String?,
      bloodGroup: map['bloodGroup'] as String?,
      allergies: map['allergies'] as String?,
      chronicConditions: map['chronicConditions'] as String?,
      emergencyContact: map['emergencyContact'] as String?,
      role: map['role'] as String? ?? 'patient',
      linkingCode: map['linkingCode'] as String?,
      isProfileCompleted: map['isProfileCompleted'] as bool? ?? false,
      linkedParentUids: (map['linkedParentUids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      monitoredPatientUids: (map['monitoredPatientUids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  UsersCompanion toUsersCompanion() {
    return UsersCompanion(
      name: drift.Value(name),
      age: drift.Value(age),
      gender: drift.Value(gender),
      email: drift.Value(email),
      weight: drift.Value(weight),
      height: drift.Value(height),
      bloodGroup: drift.Value(bloodGroup),
      allergies: drift.Value(allergies),
      chronicConditions: drift.Value(chronicConditions),
      emergencyContact: drift.Value(emergencyContact),
      firebaseUid: drift.Value(uid),
      role: drift.Value(role),
      linkingCode: drift.Value(linkingCode),
      isProfileCompleted: drift.Value(isProfileCompleted),
      imagePath: avatarUrl != null ? drift.Value(avatarUrl) : const drift.Value.absent(),
    );
  }

  factory UserProfileModel.fromDriftUser(User user) {
    return UserProfileModel(
      uid: user.firebaseUid ?? 'local_${user.id}',
      name: user.name,
      email: user.email,
      gender: user.gender,
      age: user.age,
      weight: user.weight,
      height: user.height,
      avatarUrl: user.imagePath,
      bloodGroup: user.bloodGroup,
      allergies: user.allergies,
      chronicConditions: user.chronicConditions,
      emergencyContact: user.emergencyContact,
      role: user.role,
      linkingCode: user.linkingCode,
      isProfileCompleted: user.isProfileCompleted,
    );
  }

  UserProfileModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? gender,
    int? age,
    double? weight,
    double? height,
    String? avatarUrl,
    String? bloodGroup,
    String? allergies,
    String? chronicConditions,
    String? emergencyContact,
    String? role,
    String? linkingCode,
    bool? isProfileCompleted,
    List<String>? linkedParentUids,
    List<String>? monitoredPatientUids,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      role: role ?? this.role,
      linkingCode: linkingCode ?? this.linkingCode,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      linkedParentUids: linkedParentUids ?? this.linkedParentUids,
      monitoredPatientUids: monitoredPatientUids ?? this.monitoredPatientUids,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PatientDailyStatus {
  final String patientUid;
  final String patientName;
  final String dateString;
  final int totalScheduled;
  final int totalTaken;
  final int totalMissed;
  final int totalPending;
  final double adherenceRate;
  final List<PatientMedicineDoseStatus> doses;
  final DateTime lastUpdated;

  const PatientDailyStatus({
    required this.patientUid,
    required this.patientName,
    required this.dateString,
    required this.totalScheduled,
    required this.totalTaken,
    required this.totalMissed,
    required this.totalPending,
    required this.adherenceRate,
    required this.doses,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientUid': patientUid,
      'patientName': patientName,
      'dateString': dateString,
      'totalScheduled': totalScheduled,
      'totalTaken': totalTaken,
      'totalMissed': totalMissed,
      'totalPending': totalPending,
      'adherenceRate': adherenceRate,
      'doses': doses.map((d) => d.toMap()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PatientDailyStatus.fromMap(Map<String, dynamic> map) {
    final doseList = (map['doses'] as List<dynamic>?) ?? [];
    return PatientDailyStatus(
      patientUid: map['patientUid'] as String? ?? '',
      patientName: map['patientName'] as String? ?? 'Patient',
      dateString: map['dateString'] as String? ?? '',
      totalScheduled: (map['totalScheduled'] as num?)?.toInt() ?? 0,
      totalTaken: (map['totalTaken'] as num?)?.toInt() ?? 0,
      totalMissed: (map['totalMissed'] as num?)?.toInt() ?? 0,
      totalPending: (map['totalPending'] as num?)?.toInt() ?? 0,
      adherenceRate: (map['adherenceRate'] as num?)?.toDouble() ?? 0.0,
      doses: doseList
          .map((d) => PatientMedicineDoseStatus.fromMap(d as Map<String, dynamic>))
          .toList(),
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.tryParse(map['lastUpdated'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class PatientMedicineDoseStatus {
  final int scheduleId;
  final String medicineName;
  final String dosage;
  final String dayTimeName;
  final String timeString;
  final String status; // 'taken', 'missed', 'pending'
  final String? actualTakenTime;

  const PatientMedicineDoseStatus({
    required this.scheduleId,
    required this.medicineName,
    required this.dosage,
    required this.dayTimeName,
    required this.timeString,
    required this.status,
    this.actualTakenTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'scheduleId': scheduleId,
      'medicineName': medicineName,
      'dosage': dosage,
      'dayTimeName': dayTimeName,
      'timeString': timeString,
      'status': status,
      'actualTakenTime': actualTakenTime,
    };
  }

  factory PatientMedicineDoseStatus.fromMap(Map<String, dynamic> map) {
    return PatientMedicineDoseStatus(
      scheduleId: (map['scheduleId'] as num?)?.toInt() ?? 0,
      medicineName: map['medicineName'] as String? ?? '',
      dosage: map['dosage'] as String? ?? '',
      dayTimeName: map['dayTimeName'] as String? ?? '',
      timeString: map['timeString'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      actualTakenTime: map['actualTakenTime'] as String?,
    );
  }
}
