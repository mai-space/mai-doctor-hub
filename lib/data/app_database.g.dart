// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialtyMeta = const VerificationMeta(
    'specialty',
  );
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
    'specialty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _practiceNameMeta = const VerificationMeta(
    'practiceName',
  );
  @override
  late final GeneratedColumn<String> practiceName = GeneratedColumn<String>(
    'practice_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    specialty,
    practiceName,
    phone,
    address,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Doctor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(
        _specialtyMeta,
        specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta),
      );
    }
    if (data.containsKey('practice_name')) {
      context.handle(
        _practiceNameMeta,
        practiceName.isAcceptableOrUnknown(
          data['practice_name']!,
          _practiceNameMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Doctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Doctor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      specialty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialty'],
      ),
      practiceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}practice_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DoctorsTable createAlias(String alias) {
    return $DoctorsTable(attachedDatabase, alias);
  }
}

class Doctor extends DataClass implements Insertable<Doctor> {
  final String id;
  final String name;
  final String? specialty;
  final String? practiceName;
  final String? phone;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Doctor({
    required this.id,
    required this.name,
    this.specialty,
    this.practiceName,
    this.phone,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    if (!nullToAbsent || practiceName != null) {
      map['practice_name'] = Variable<String>(practiceName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DoctorsCompanion toCompanion(bool nullToAbsent) {
    return DoctorsCompanion(
      id: Value(id),
      name: Value(name),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      practiceName: practiceName == null && nullToAbsent
          ? const Value.absent()
          : Value(practiceName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Doctor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Doctor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      practiceName: serializer.fromJson<String?>(json['practiceName']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'specialty': serializer.toJson<String?>(specialty),
      'practiceName': serializer.toJson<String?>(practiceName),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    Value<String?> specialty = const Value.absent(),
    Value<String?> practiceName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Doctor(
    id: id ?? this.id,
    name: name ?? this.name,
    specialty: specialty.present ? specialty.value : this.specialty,
    practiceName: practiceName.present ? practiceName.value : this.practiceName,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Doctor copyWithCompanion(DoctorsCompanion data) {
    return Doctor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      practiceName: data.practiceName.present
          ? data.practiceName.value
          : this.practiceName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Doctor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('specialty: $specialty, ')
          ..write('practiceName: $practiceName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    specialty,
    practiceName,
    phone,
    address,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Doctor &&
          other.id == this.id &&
          other.name == this.name &&
          other.specialty == this.specialty &&
          other.practiceName == this.practiceName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DoctorsCompanion extends UpdateCompanion<Doctor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> specialty;
  final Value<String?> practiceName;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DoctorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.specialty = const Value.absent(),
    this.practiceName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorsCompanion.insert({
    required String id,
    required String name,
    this.specialty = const Value.absent(),
    this.practiceName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Doctor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? specialty,
    Expression<String>? practiceName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (specialty != null) 'specialty': specialty,
      if (practiceName != null) 'practice_name': practiceName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? specialty,
    Value<String?>? practiceName,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DoctorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      practiceName: practiceName ?? this.practiceName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (practiceName.present) {
      map['practice_name'] = Variable<String>(practiceName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('specialty: $specialty, ')
          ..write('practiceName: $practiceName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiagnosesTable extends Diagnoses
    with TableInfo<$DiagnosesTable, Diagnose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiagnosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DiagnosisStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DiagnosisStatus>($DiagnosesTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    notes,
    startedAt,
    endedAt,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diagnoses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Diagnose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Diagnose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diagnose(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: $DiagnosesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DiagnosesTable createAlias(String alias) {
    return $DiagnosesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DiagnosisStatus, int, int> $converterstatus =
      const EnumIndexConverter<DiagnosisStatus>(DiagnosisStatus.values);
}

class Diagnose extends DataClass implements Insertable<Diagnose> {
  final String id;
  final String title;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DiagnosisStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Diagnose({
    required this.id,
    required this.title,
    this.notes,
    this.startedAt,
    this.endedAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    {
      map['status'] = Variable<int>(
        $DiagnosesTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DiagnosesCompanion toCompanion(bool nullToAbsent) {
    return DiagnosesCompanion(
      id: Value(id),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Diagnose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diagnose(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: $DiagnosesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<int>(
        $DiagnosesTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Diagnose copyWith({
    String? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    DiagnosisStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Diagnose(
    id: id ?? this.id,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Diagnose copyWithCompanion(DiagnosesCompanion data) {
    return Diagnose(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diagnose(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    notes,
    startedAt,
    endedAt,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diagnose &&
          other.id == this.id &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DiagnosesCompanion extends UpdateCompanion<Diagnose> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> notes;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<DiagnosisStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DiagnosesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiagnosesCompanion.insert({
    required String id,
    required String title,
    this.notes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    required DiagnosisStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Diagnose> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiagnosesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? notes,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<DiagnosisStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DiagnosesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $DiagnosesTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiagnosesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomsTable extends Symptoms with TableInfo<$SymptomsTable, Symptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diagnosisIdMeta = const VerificationMeta(
    'diagnosisId',
  );
  @override
  late final GeneratedColumn<String> diagnosisId = GeneratedColumn<String>(
    'diagnosis_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagnoses (id)',
    ),
  );
  static const VerificationMeta _bodyRegionMeta = const VerificationMeta(
    'bodyRegion',
  );
  @override
  late final GeneratedColumn<String> bodyRegion = GeneratedColumn<String>(
    'body_region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healedAtMeta = const VerificationMeta(
    'healedAt',
  );
  @override
  late final GeneratedColumn<DateTime> healedAt = GeneratedColumn<DateTime>(
    'healed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CheckInCadence, int>
  checkInCadence = GeneratedColumn<int>(
    'check_in_cadence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<CheckInCadence>($SymptomsTable.$convertercheckInCadence);
  static const VerificationMeta _reminderTimesJsonMeta = const VerificationMeta(
    'reminderTimesJson',
  );
  @override
  late final GeneratedColumn<String> reminderTimesJson =
      GeneratedColumn<String>(
        'reminder_times_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    diagnosisId,
    bodyRegion,
    healedAt,
    checkInCadence,
    reminderTimesJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Symptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('diagnosis_id')) {
      context.handle(
        _diagnosisIdMeta,
        diagnosisId.isAcceptableOrUnknown(
          data['diagnosis_id']!,
          _diagnosisIdMeta,
        ),
      );
    }
    if (data.containsKey('body_region')) {
      context.handle(
        _bodyRegionMeta,
        bodyRegion.isAcceptableOrUnknown(data['body_region']!, _bodyRegionMeta),
      );
    }
    if (data.containsKey('healed_at')) {
      context.handle(
        _healedAtMeta,
        healedAt.isAcceptableOrUnknown(data['healed_at']!, _healedAtMeta),
      );
    }
    if (data.containsKey('reminder_times_json')) {
      context.handle(
        _reminderTimesJsonMeta,
        reminderTimesJson.isAcceptableOrUnknown(
          data['reminder_times_json']!,
          _reminderTimesJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Symptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Symptom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      diagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis_id'],
      ),
      bodyRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_region'],
      ),
      healedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}healed_at'],
      ),
      checkInCadence: $SymptomsTable.$convertercheckInCadence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}check_in_cadence'],
        )!,
      ),
      reminderTimesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_times_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SymptomsTable createAlias(String alias) {
    return $SymptomsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CheckInCadence, int, int> $convertercheckInCadence =
      const EnumIndexConverter<CheckInCadence>(CheckInCadence.values);
}

class Symptom extends DataClass implements Insertable<Symptom> {
  final String id;
  final String label;
  final String? diagnosisId;
  final String? bodyRegion;
  final DateTime? healedAt;
  final CheckInCadence checkInCadence;
  final String reminderTimesJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Symptom({
    required this.id,
    required this.label,
    this.diagnosisId,
    this.bodyRegion,
    this.healedAt,
    required this.checkInCadence,
    required this.reminderTimesJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || diagnosisId != null) {
      map['diagnosis_id'] = Variable<String>(diagnosisId);
    }
    if (!nullToAbsent || bodyRegion != null) {
      map['body_region'] = Variable<String>(bodyRegion);
    }
    if (!nullToAbsent || healedAt != null) {
      map['healed_at'] = Variable<DateTime>(healedAt);
    }
    {
      map['check_in_cadence'] = Variable<int>(
        $SymptomsTable.$convertercheckInCadence.toSql(checkInCadence),
      );
    }
    map['reminder_times_json'] = Variable<String>(reminderTimesJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SymptomsCompanion toCompanion(bool nullToAbsent) {
    return SymptomsCompanion(
      id: Value(id),
      label: Value(label),
      diagnosisId: diagnosisId == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosisId),
      bodyRegion: bodyRegion == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyRegion),
      healedAt: healedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(healedAt),
      checkInCadence: Value(checkInCadence),
      reminderTimesJson: Value(reminderTimesJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Symptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Symptom(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      diagnosisId: serializer.fromJson<String?>(json['diagnosisId']),
      bodyRegion: serializer.fromJson<String?>(json['bodyRegion']),
      healedAt: serializer.fromJson<DateTime?>(json['healedAt']),
      checkInCadence: $SymptomsTable.$convertercheckInCadence.fromJson(
        serializer.fromJson<int>(json['checkInCadence']),
      ),
      reminderTimesJson: serializer.fromJson<String>(json['reminderTimesJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'diagnosisId': serializer.toJson<String?>(diagnosisId),
      'bodyRegion': serializer.toJson<String?>(bodyRegion),
      'healedAt': serializer.toJson<DateTime?>(healedAt),
      'checkInCadence': serializer.toJson<int>(
        $SymptomsTable.$convertercheckInCadence.toJson(checkInCadence),
      ),
      'reminderTimesJson': serializer.toJson<String>(reminderTimesJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Symptom copyWith({
    String? id,
    String? label,
    Value<String?> diagnosisId = const Value.absent(),
    Value<String?> bodyRegion = const Value.absent(),
    Value<DateTime?> healedAt = const Value.absent(),
    CheckInCadence? checkInCadence,
    String? reminderTimesJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Symptom(
    id: id ?? this.id,
    label: label ?? this.label,
    diagnosisId: diagnosisId.present ? diagnosisId.value : this.diagnosisId,
    bodyRegion: bodyRegion.present ? bodyRegion.value : this.bodyRegion,
    healedAt: healedAt.present ? healedAt.value : this.healedAt,
    checkInCadence: checkInCadence ?? this.checkInCadence,
    reminderTimesJson: reminderTimesJson ?? this.reminderTimesJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Symptom copyWithCompanion(SymptomsCompanion data) {
    return Symptom(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      diagnosisId: data.diagnosisId.present
          ? data.diagnosisId.value
          : this.diagnosisId,
      bodyRegion: data.bodyRegion.present
          ? data.bodyRegion.value
          : this.bodyRegion,
      healedAt: data.healedAt.present ? data.healedAt.value : this.healedAt,
      checkInCadence: data.checkInCadence.present
          ? data.checkInCadence.value
          : this.checkInCadence,
      reminderTimesJson: data.reminderTimesJson.present
          ? data.reminderTimesJson.value
          : this.reminderTimesJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Symptom(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('healedAt: $healedAt, ')
          ..write('checkInCadence: $checkInCadence, ')
          ..write('reminderTimesJson: $reminderTimesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    diagnosisId,
    bodyRegion,
    healedAt,
    checkInCadence,
    reminderTimesJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Symptom &&
          other.id == this.id &&
          other.label == this.label &&
          other.diagnosisId == this.diagnosisId &&
          other.bodyRegion == this.bodyRegion &&
          other.healedAt == this.healedAt &&
          other.checkInCadence == this.checkInCadence &&
          other.reminderTimesJson == this.reminderTimesJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SymptomsCompanion extends UpdateCompanion<Symptom> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> diagnosisId;
  final Value<String?> bodyRegion;
  final Value<DateTime?> healedAt;
  final Value<CheckInCadence> checkInCadence;
  final Value<String> reminderTimesJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SymptomsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.healedAt = const Value.absent(),
    this.checkInCadence = const Value.absent(),
    this.reminderTimesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomsCompanion.insert({
    required String id,
    required String label,
    this.diagnosisId = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.healedAt = const Value.absent(),
    required CheckInCadence checkInCadence,
    this.reminderTimesJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       checkInCadence = Value(checkInCadence),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Symptom> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? diagnosisId,
    Expression<String>? bodyRegion,
    Expression<DateTime>? healedAt,
    Expression<int>? checkInCadence,
    Expression<String>? reminderTimesJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (bodyRegion != null) 'body_region': bodyRegion,
      if (healedAt != null) 'healed_at': healedAt,
      if (checkInCadence != null) 'check_in_cadence': checkInCadence,
      if (reminderTimesJson != null) 'reminder_times_json': reminderTimesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? diagnosisId,
    Value<String?>? bodyRegion,
    Value<DateTime?>? healedAt,
    Value<CheckInCadence>? checkInCadence,
    Value<String>? reminderTimesJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SymptomsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      healedAt: healedAt ?? this.healedAt,
      checkInCadence: checkInCadence ?? this.checkInCadence,
      reminderTimesJson: reminderTimesJson ?? this.reminderTimesJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (diagnosisId.present) {
      map['diagnosis_id'] = Variable<String>(diagnosisId.value);
    }
    if (bodyRegion.present) {
      map['body_region'] = Variable<String>(bodyRegion.value);
    }
    if (healedAt.present) {
      map['healed_at'] = Variable<DateTime>(healedAt.value);
    }
    if (checkInCadence.present) {
      map['check_in_cadence'] = Variable<int>(
        $SymptomsTable.$convertercheckInCadence.toSql(checkInCadence.value),
      );
    }
    if (reminderTimesJson.present) {
      map['reminder_times_json'] = Variable<String>(reminderTimesJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('healedAt: $healedAt, ')
          ..write('checkInCadence: $checkInCadence, ')
          ..write('reminderTimesJson: $reminderTimesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomObservationsTable extends SymptomObservations
    with TableInfo<$SymptomObservationsTable, SymptomObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES symptoms (id)',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ObservationKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ObservationKind>(
        $SymptomObservationsTable.$converterkind,
      );
  static const VerificationMeta _valueNumberMeta = const VerificationMeta(
    'valueNumber',
  );
  @override
  late final GeneratedColumn<double> valueNumber = GeneratedColumn<double>(
    'value_number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  @override
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueColorMeta = const VerificationMeta(
    'valueColor',
  );
  @override
  late final GeneratedColumn<String> valueColor = GeneratedColumn<String>(
    'value_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symptomId,
    recordedAt,
    kind,
    valueNumber,
    valueText,
    valueColor,
    unit,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_observations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomObservation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('value_number')) {
      context.handle(
        _valueNumberMeta,
        valueNumber.isAcceptableOrUnknown(
          data['value_number']!,
          _valueNumberMeta,
        ),
      );
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    if (data.containsKey('value_color')) {
      context.handle(
        _valueColorMeta,
        valueColor.isAcceptableOrUnknown(data['value_color']!, _valueColorMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomObservation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      kind: $SymptomObservationsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      valueNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_number'],
      ),
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      ),
      valueColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_color'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SymptomObservationsTable createAlias(String alias) {
    return $SymptomObservationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ObservationKind, int, int> $converterkind =
      const EnumIndexConverter<ObservationKind>(ObservationKind.values);
}

class SymptomObservation extends DataClass
    implements Insertable<SymptomObservation> {
  final String id;
  final String symptomId;
  final DateTime recordedAt;
  final ObservationKind kind;
  final double? valueNumber;
  final String? valueText;
  final String? valueColor;
  final String? unit;
  final String? note;
  const SymptomObservation({
    required this.id,
    required this.symptomId,
    required this.recordedAt,
    required this.kind,
    this.valueNumber,
    this.valueText,
    this.valueColor,
    this.unit,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['symptom_id'] = Variable<String>(symptomId);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    {
      map['kind'] = Variable<int>(
        $SymptomObservationsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || valueNumber != null) {
      map['value_number'] = Variable<double>(valueNumber);
    }
    if (!nullToAbsent || valueText != null) {
      map['value_text'] = Variable<String>(valueText);
    }
    if (!nullToAbsent || valueColor != null) {
      map['value_color'] = Variable<String>(valueColor);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SymptomObservationsCompanion toCompanion(bool nullToAbsent) {
    return SymptomObservationsCompanion(
      id: Value(id),
      symptomId: Value(symptomId),
      recordedAt: Value(recordedAt),
      kind: Value(kind),
      valueNumber: valueNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNumber),
      valueText: valueText == null && nullToAbsent
          ? const Value.absent()
          : Value(valueText),
      valueColor: valueColor == null && nullToAbsent
          ? const Value.absent()
          : Value(valueColor),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SymptomObservation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomObservation(
      id: serializer.fromJson<String>(json['id']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      kind: $SymptomObservationsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      valueNumber: serializer.fromJson<double?>(json['valueNumber']),
      valueText: serializer.fromJson<String?>(json['valueText']),
      valueColor: serializer.fromJson<String?>(json['valueColor']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'symptomId': serializer.toJson<String>(symptomId),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'kind': serializer.toJson<int>(
        $SymptomObservationsTable.$converterkind.toJson(kind),
      ),
      'valueNumber': serializer.toJson<double?>(valueNumber),
      'valueText': serializer.toJson<String?>(valueText),
      'valueColor': serializer.toJson<String?>(valueColor),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
    };
  }

  SymptomObservation copyWith({
    String? id,
    String? symptomId,
    DateTime? recordedAt,
    ObservationKind? kind,
    Value<double?> valueNumber = const Value.absent(),
    Value<String?> valueText = const Value.absent(),
    Value<String?> valueColor = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SymptomObservation(
    id: id ?? this.id,
    symptomId: symptomId ?? this.symptomId,
    recordedAt: recordedAt ?? this.recordedAt,
    kind: kind ?? this.kind,
    valueNumber: valueNumber.present ? valueNumber.value : this.valueNumber,
    valueText: valueText.present ? valueText.value : this.valueText,
    valueColor: valueColor.present ? valueColor.value : this.valueColor,
    unit: unit.present ? unit.value : this.unit,
    note: note.present ? note.value : this.note,
  );
  SymptomObservation copyWithCompanion(SymptomObservationsCompanion data) {
    return SymptomObservation(
      id: data.id.present ? data.id.value : this.id,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      valueNumber: data.valueNumber.present
          ? data.valueNumber.value
          : this.valueNumber,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
      valueColor: data.valueColor.present
          ? data.valueColor.value
          : this.valueColor,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomObservation(')
          ..write('id: $id, ')
          ..write('symptomId: $symptomId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kind: $kind, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueText: $valueText, ')
          ..write('valueColor: $valueColor, ')
          ..write('unit: $unit, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symptomId,
    recordedAt,
    kind,
    valueNumber,
    valueText,
    valueColor,
    unit,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomObservation &&
          other.id == this.id &&
          other.symptomId == this.symptomId &&
          other.recordedAt == this.recordedAt &&
          other.kind == this.kind &&
          other.valueNumber == this.valueNumber &&
          other.valueText == this.valueText &&
          other.valueColor == this.valueColor &&
          other.unit == this.unit &&
          other.note == this.note);
}

class SymptomObservationsCompanion extends UpdateCompanion<SymptomObservation> {
  final Value<String> id;
  final Value<String> symptomId;
  final Value<DateTime> recordedAt;
  final Value<ObservationKind> kind;
  final Value<double?> valueNumber;
  final Value<String?> valueText;
  final Value<String?> valueColor;
  final Value<String?> unit;
  final Value<String?> note;
  final Value<int> rowid;
  const SymptomObservationsCompanion({
    this.id = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueText = const Value.absent(),
    this.valueColor = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomObservationsCompanion.insert({
    required String id,
    required String symptomId,
    required DateTime recordedAt,
    required ObservationKind kind,
    this.valueNumber = const Value.absent(),
    this.valueText = const Value.absent(),
    this.valueColor = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       symptomId = Value(symptomId),
       recordedAt = Value(recordedAt),
       kind = Value(kind);
  static Insertable<SymptomObservation> custom({
    Expression<String>? id,
    Expression<String>? symptomId,
    Expression<DateTime>? recordedAt,
    Expression<int>? kind,
    Expression<double>? valueNumber,
    Expression<String>? valueText,
    Expression<String>? valueColor,
    Expression<String>? unit,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symptomId != null) 'symptom_id': symptomId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (kind != null) 'kind': kind,
      if (valueNumber != null) 'value_number': valueNumber,
      if (valueText != null) 'value_text': valueText,
      if (valueColor != null) 'value_color': valueColor,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomObservationsCompanion copyWith({
    Value<String>? id,
    Value<String>? symptomId,
    Value<DateTime>? recordedAt,
    Value<ObservationKind>? kind,
    Value<double?>? valueNumber,
    Value<String?>? valueText,
    Value<String?>? valueColor,
    Value<String?>? unit,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SymptomObservationsCompanion(
      id: id ?? this.id,
      symptomId: symptomId ?? this.symptomId,
      recordedAt: recordedAt ?? this.recordedAt,
      kind: kind ?? this.kind,
      valueNumber: valueNumber ?? this.valueNumber,
      valueText: valueText ?? this.valueText,
      valueColor: valueColor ?? this.valueColor,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $SymptomObservationsTable.$converterkind.toSql(kind.value),
      );
    }
    if (valueNumber.present) {
      map['value_number'] = Variable<double>(valueNumber.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    if (valueColor.present) {
      map['value_color'] = Variable<String>(valueColor.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomObservationsCompanion(')
          ..write('id: $id, ')
          ..write('symptomId: $symptomId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kind: $kind, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueText: $valueText, ')
          ..write('valueColor: $valueColor, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES doctors (id)',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppointmentStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AppointmentStatus>($AppointmentsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    doctorId,
    scheduledAt,
    durationMin,
    title,
    notes,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Appointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: $AppointmentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppointmentStatus, int, int> $converterstatus =
      const EnumIndexConverter<AppointmentStatus>(AppointmentStatus.values);
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final String id;
  final String doctorId;
  final DateTime scheduledAt;
  final int? durationMin;
  final String? title;
  final String? notes;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Appointment({
    required this.id,
    required this.doctorId,
    required this.scheduledAt,
    this.durationMin,
    this.title,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['doctor_id'] = Variable<String>(doctorId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || durationMin != null) {
      map['duration_min'] = Variable<int>(durationMin);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['status'] = Variable<int>(
        $AppointmentsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      doctorId: Value(doctorId),
      scheduledAt: Value(scheduledAt),
      durationMin: durationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMin),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Appointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<String>(json['id']),
      doctorId: serializer.fromJson<String>(json['doctorId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      durationMin: serializer.fromJson<int?>(json['durationMin']),
      title: serializer.fromJson<String?>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: $AppointmentsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'doctorId': serializer.toJson<String>(doctorId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'durationMin': serializer.toJson<int?>(durationMin),
      'title': serializer.toJson<String?>(title),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<int>(
        $AppointmentsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Appointment copyWith({
    String? id,
    String? doctorId,
    DateTime? scheduledAt,
    Value<int?> durationMin = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Appointment(
    id: id ?? this.id,
    doctorId: doctorId ?? this.doctorId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    durationMin: durationMin.present ? durationMin.value : this.durationMin,
    title: title.present ? title.value : this.title,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('doctorId: $doctorId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMin: $durationMin, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    doctorId,
    scheduledAt,
    durationMin,
    title,
    notes,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.doctorId == this.doctorId &&
          other.scheduledAt == this.scheduledAt &&
          other.durationMin == this.durationMin &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<String> id;
  final Value<String> doctorId;
  final Value<DateTime> scheduledAt;
  final Value<int?> durationMin;
  final Value<String?> title;
  final Value<String?> notes;
  final Value<AppointmentStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    required String id,
    required String doctorId,
    required DateTime scheduledAt,
    this.durationMin = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    required AppointmentStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       doctorId = Value(doctorId),
       scheduledAt = Value(scheduledAt),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Appointment> custom({
    Expression<String>? id,
    Expression<String>? doctorId,
    Expression<DateTime>? scheduledAt,
    Expression<int>? durationMin,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (doctorId != null) 'doctor_id': doctorId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (durationMin != null) 'duration_min': durationMin,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? doctorId,
    Value<DateTime>? scheduledAt,
    Value<int?>? durationMin,
    Value<String?>? title,
    Value<String?>? notes,
    Value<AppointmentStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMin: durationMin ?? this.durationMin,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $AppointmentsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('doctorId: $doctorId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMin: $durationMin, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentDiagnosesTable extends AppointmentDiagnoses
    with TableInfo<$AppointmentDiagnosesTable, AppointmentDiagnose> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentDiagnosesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id)',
    ),
  );
  static const VerificationMeta _diagnosisIdMeta = const VerificationMeta(
    'diagnosisId',
  );
  @override
  late final GeneratedColumn<String> diagnosisId = GeneratedColumn<String>(
    'diagnosis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagnoses (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [appointmentId, diagnosisId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointment_diagnoses';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppointmentDiagnose> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('diagnosis_id')) {
      context.handle(
        _diagnosisIdMeta,
        diagnosisId.isAcceptableOrUnknown(
          data['diagnosis_id']!,
          _diagnosisIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diagnosisIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appointmentId, diagnosisId};
  @override
  AppointmentDiagnose map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentDiagnose(
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      )!,
      diagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis_id'],
      )!,
    );
  }

  @override
  $AppointmentDiagnosesTable createAlias(String alias) {
    return $AppointmentDiagnosesTable(attachedDatabase, alias);
  }
}

class AppointmentDiagnose extends DataClass
    implements Insertable<AppointmentDiagnose> {
  final String appointmentId;
  final String diagnosisId;
  const AppointmentDiagnose({
    required this.appointmentId,
    required this.diagnosisId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['appointment_id'] = Variable<String>(appointmentId);
    map['diagnosis_id'] = Variable<String>(diagnosisId);
    return map;
  }

  AppointmentDiagnosesCompanion toCompanion(bool nullToAbsent) {
    return AppointmentDiagnosesCompanion(
      appointmentId: Value(appointmentId),
      diagnosisId: Value(diagnosisId),
    );
  }

  factory AppointmentDiagnose.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentDiagnose(
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      diagnosisId: serializer.fromJson<String>(json['diagnosisId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appointmentId': serializer.toJson<String>(appointmentId),
      'diagnosisId': serializer.toJson<String>(diagnosisId),
    };
  }

  AppointmentDiagnose copyWith({String? appointmentId, String? diagnosisId}) =>
      AppointmentDiagnose(
        appointmentId: appointmentId ?? this.appointmentId,
        diagnosisId: diagnosisId ?? this.diagnosisId,
      );
  AppointmentDiagnose copyWithCompanion(AppointmentDiagnosesCompanion data) {
    return AppointmentDiagnose(
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      diagnosisId: data.diagnosisId.present
          ? data.diagnosisId.value
          : this.diagnosisId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentDiagnose(')
          ..write('appointmentId: $appointmentId, ')
          ..write('diagnosisId: $diagnosisId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(appointmentId, diagnosisId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentDiagnose &&
          other.appointmentId == this.appointmentId &&
          other.diagnosisId == this.diagnosisId);
}

class AppointmentDiagnosesCompanion
    extends UpdateCompanion<AppointmentDiagnose> {
  final Value<String> appointmentId;
  final Value<String> diagnosisId;
  final Value<int> rowid;
  const AppointmentDiagnosesCompanion({
    this.appointmentId = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentDiagnosesCompanion.insert({
    required String appointmentId,
    required String diagnosisId,
    this.rowid = const Value.absent(),
  }) : appointmentId = Value(appointmentId),
       diagnosisId = Value(diagnosisId);
  static Insertable<AppointmentDiagnose> custom({
    Expression<String>? appointmentId,
    Expression<String>? diagnosisId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentDiagnosesCompanion copyWith({
    Value<String>? appointmentId,
    Value<String>? diagnosisId,
    Value<int>? rowid,
  }) {
    return AppointmentDiagnosesCompanion(
      appointmentId: appointmentId ?? this.appointmentId,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (diagnosisId.present) {
      map['diagnosis_id'] = Variable<String>(diagnosisId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentDiagnosesCompanion(')
          ..write('appointmentId: $appointmentId, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentSymptomsTable extends AppointmentSymptoms
    with TableInfo<$AppointmentSymptomsTable, AppointmentSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentSymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id)',
    ),
  );
  static const VerificationMeta _symptomIdMeta = const VerificationMeta(
    'symptomId',
  );
  @override
  late final GeneratedColumn<String> symptomId = GeneratedColumn<String>(
    'symptom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES symptoms (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [appointmentId, symptomId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointment_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppointmentSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('symptom_id')) {
      context.handle(
        _symptomIdMeta,
        symptomId.isAcceptableOrUnknown(data['symptom_id']!, _symptomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appointmentId, symptomId};
  @override
  AppointmentSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentSymptom(
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
    );
  }

  @override
  $AppointmentSymptomsTable createAlias(String alias) {
    return $AppointmentSymptomsTable(attachedDatabase, alias);
  }
}

class AppointmentSymptom extends DataClass
    implements Insertable<AppointmentSymptom> {
  final String appointmentId;
  final String symptomId;
  const AppointmentSymptom({
    required this.appointmentId,
    required this.symptomId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['appointment_id'] = Variable<String>(appointmentId);
    map['symptom_id'] = Variable<String>(symptomId);
    return map;
  }

  AppointmentSymptomsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentSymptomsCompanion(
      appointmentId: Value(appointmentId),
      symptomId: Value(symptomId),
    );
  }

  factory AppointmentSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentSymptom(
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appointmentId': serializer.toJson<String>(appointmentId),
      'symptomId': serializer.toJson<String>(symptomId),
    };
  }

  AppointmentSymptom copyWith({String? appointmentId, String? symptomId}) =>
      AppointmentSymptom(
        appointmentId: appointmentId ?? this.appointmentId,
        symptomId: symptomId ?? this.symptomId,
      );
  AppointmentSymptom copyWithCompanion(AppointmentSymptomsCompanion data) {
    return AppointmentSymptom(
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentSymptom(')
          ..write('appointmentId: $appointmentId, ')
          ..write('symptomId: $symptomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(appointmentId, symptomId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentSymptom &&
          other.appointmentId == this.appointmentId &&
          other.symptomId == this.symptomId);
}

class AppointmentSymptomsCompanion extends UpdateCompanion<AppointmentSymptom> {
  final Value<String> appointmentId;
  final Value<String> symptomId;
  final Value<int> rowid;
  const AppointmentSymptomsCompanion({
    this.appointmentId = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentSymptomsCompanion.insert({
    required String appointmentId,
    required String symptomId,
    this.rowid = const Value.absent(),
  }) : appointmentId = Value(appointmentId),
       symptomId = Value(symptomId);
  static Insertable<AppointmentSymptom> custom({
    Expression<String>? appointmentId,
    Expression<String>? symptomId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (symptomId != null) 'symptom_id': symptomId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentSymptomsCompanion copyWith({
    Value<String>? appointmentId,
    Value<String>? symptomId,
    Value<int>? rowid,
  }) {
    return AppointmentSymptomsCompanion(
      appointmentId: appointmentId ?? this.appointmentId,
      symptomId: symptomId ?? this.symptomId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (symptomId.present) {
      map['symptom_id'] = Variable<String>(symptomId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentSymptomsCompanion(')
          ..write('appointmentId: $appointmentId, ')
          ..write('symptomId: $symptomId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsTable extends Reports with TableInfo<$ReportsTable, Report> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReportSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ReportSource>($ReportsTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appointmentId,
    title,
    mimeType,
    localPath,
    extractedText,
    pageCount,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<Report> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Report map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Report(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      source: $ReportsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReportsTable createAlias(String alias) {
    return $ReportsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReportSource, int, int> $convertersource =
      const EnumIndexConverter<ReportSource>(ReportSource.values);
}

class Report extends DataClass implements Insertable<Report> {
  final String id;
  final String? appointmentId;
  final String title;
  final String mimeType;
  final String localPath;
  final String? extractedText;
  final int? pageCount;
  final ReportSource source;
  final DateTime createdAt;
  const Report({
    required this.id,
    this.appointmentId,
    required this.title,
    required this.mimeType,
    required this.localPath,
    this.extractedText,
    this.pageCount,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<String>(appointmentId);
    }
    map['title'] = Variable<String>(title);
    map['mime_type'] = Variable<String>(mimeType);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || extractedText != null) {
      map['extracted_text'] = Variable<String>(extractedText);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    {
      map['source'] = Variable<int>(
        $ReportsTable.$convertersource.toSql(source),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportsCompanion toCompanion(bool nullToAbsent) {
    return ReportsCompanion(
      id: Value(id),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
      title: Value(title),
      mimeType: Value(mimeType),
      localPath: Value(localPath),
      extractedText: extractedText == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedText),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory Report.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Report(
      id: serializer.fromJson<String>(json['id']),
      appointmentId: serializer.fromJson<String?>(json['appointmentId']),
      title: serializer.fromJson<String>(json['title']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      localPath: serializer.fromJson<String>(json['localPath']),
      extractedText: serializer.fromJson<String?>(json['extractedText']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      source: $ReportsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appointmentId': serializer.toJson<String?>(appointmentId),
      'title': serializer.toJson<String>(title),
      'mimeType': serializer.toJson<String>(mimeType),
      'localPath': serializer.toJson<String>(localPath),
      'extractedText': serializer.toJson<String?>(extractedText),
      'pageCount': serializer.toJson<int?>(pageCount),
      'source': serializer.toJson<int>(
        $ReportsTable.$convertersource.toJson(source),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Report copyWith({
    String? id,
    Value<String?> appointmentId = const Value.absent(),
    String? title,
    String? mimeType,
    String? localPath,
    Value<String?> extractedText = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    ReportSource? source,
    DateTime? createdAt,
  }) => Report(
    id: id ?? this.id,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
    title: title ?? this.title,
    mimeType: mimeType ?? this.mimeType,
    localPath: localPath ?? this.localPath,
    extractedText: extractedText.present
        ? extractedText.value
        : this.extractedText,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  Report copyWithCompanion(ReportsCompanion data) {
    return Report(
      id: data.id.present ? data.id.value : this.id,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      title: data.title.present ? data.title.value : this.title,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Report(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('title: $title, ')
          ..write('mimeType: $mimeType, ')
          ..write('localPath: $localPath, ')
          ..write('extractedText: $extractedText, ')
          ..write('pageCount: $pageCount, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appointmentId,
    title,
    mimeType,
    localPath,
    extractedText,
    pageCount,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report &&
          other.id == this.id &&
          other.appointmentId == this.appointmentId &&
          other.title == this.title &&
          other.mimeType == this.mimeType &&
          other.localPath == this.localPath &&
          other.extractedText == this.extractedText &&
          other.pageCount == this.pageCount &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class ReportsCompanion extends UpdateCompanion<Report> {
  final Value<String> id;
  final Value<String?> appointmentId;
  final Value<String> title;
  final Value<String> mimeType;
  final Value<String> localPath;
  final Value<String?> extractedText;
  final Value<int?> pageCount;
  final Value<ReportSource> source;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReportsCompanion({
    this.id = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.title = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.localPath = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCompanion.insert({
    required String id,
    this.appointmentId = const Value.absent(),
    required String title,
    required String mimeType,
    required String localPath,
    this.extractedText = const Value.absent(),
    this.pageCount = const Value.absent(),
    required ReportSource source,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       mimeType = Value(mimeType),
       localPath = Value(localPath),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<Report> custom({
    Expression<String>? id,
    Expression<String>? appointmentId,
    Expression<String>? title,
    Expression<String>? mimeType,
    Expression<String>? localPath,
    Expression<String>? extractedText,
    Expression<int>? pageCount,
    Expression<int>? source,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (title != null) 'title': title,
      if (mimeType != null) 'mime_type': mimeType,
      if (localPath != null) 'local_path': localPath,
      if (extractedText != null) 'extracted_text': extractedText,
      if (pageCount != null) 'page_count': pageCount,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCompanion copyWith({
    Value<String>? id,
    Value<String?>? appointmentId,
    Value<String>? title,
    Value<String>? mimeType,
    Value<String>? localPath,
    Value<String?>? extractedText,
    Value<int?>? pageCount,
    Value<ReportSource>? source,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReportsCompanion(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      title: title ?? this.title,
      mimeType: mimeType ?? this.mimeType,
      localPath: localPath ?? this.localPath,
      extractedText: extractedText ?? this.extractedText,
      pageCount: pageCount ?? this.pageCount,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $ReportsTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCompanion(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('title: $title, ')
          ..write('mimeType: $mimeType, ')
          ..write('localPath: $localPath, ')
          ..write('extractedText: $extractedText, ')
          ..write('pageCount: $pageCount, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleTextMeta = const VerificationMeta(
    'scheduleText',
  );
  @override
  late final GeneratedColumn<String> scheduleText = GeneratedColumn<String>(
    'schedule_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diagnosisIdMeta = const VerificationMeta(
    'diagnosisId',
  );
  @override
  late final GeneratedColumn<String> diagnosisId = GeneratedColumn<String>(
    'diagnosis_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diagnoses (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dosage,
    scheduleText,
    diagnosisId,
    startedAt,
    endedAt,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('schedule_text')) {
      context.handle(
        _scheduleTextMeta,
        scheduleText.isAcceptableOrUnknown(
          data['schedule_text']!,
          _scheduleTextMeta,
        ),
      );
    }
    if (data.containsKey('diagnosis_id')) {
      context.handle(
        _diagnosisIdMeta,
        diagnosisId.isAcceptableOrUnknown(
          data['diagnosis_id']!,
          _diagnosisIdMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      scheduleText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_text'],
      ),
      diagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosis_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String name;
  final String? dosage;
  final String? scheduleText;
  final String? diagnosisId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? notes;
  final DateTime createdAt;
  const Medication({
    required this.id,
    required this.name,
    this.dosage,
    this.scheduleText,
    this.diagnosisId,
    this.startedAt,
    this.endedAt,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || scheduleText != null) {
      map['schedule_text'] = Variable<String>(scheduleText);
    }
    if (!nullToAbsent || diagnosisId != null) {
      map['diagnosis_id'] = Variable<String>(diagnosisId);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
      scheduleText: scheduleText == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduleText),
      diagnosisId: diagnosisId == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosisId),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      scheduleText: serializer.fromJson<String?>(json['scheduleText']),
      diagnosisId: serializer.fromJson<String?>(json['diagnosisId']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'scheduleText': serializer.toJson<String?>(scheduleText),
      'diagnosisId': serializer.toJson<String?>(diagnosisId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Medication copyWith({
    String? id,
    String? name,
    Value<String?> dosage = const Value.absent(),
    Value<String?> scheduleText = const Value.absent(),
    Value<String?> diagnosisId = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Medication(
    id: id ?? this.id,
    name: name ?? this.name,
    dosage: dosage.present ? dosage.value : this.dosage,
    scheduleText: scheduleText.present ? scheduleText.value : this.scheduleText,
    diagnosisId: diagnosisId.present ? diagnosisId.value : this.diagnosisId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      scheduleText: data.scheduleText.present
          ? data.scheduleText.value
          : this.scheduleText,
      diagnosisId: data.diagnosisId.present
          ? data.diagnosisId.value
          : this.diagnosisId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleText: $scheduleText, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dosage,
    scheduleText,
    diagnosisId,
    startedAt,
    endedAt,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.scheduleText == this.scheduleText &&
          other.diagnosisId == this.diagnosisId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> scheduleText;
  final Value<String?> diagnosisId;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.scheduleText = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    this.dosage = const Value.absent(),
    this.scheduleText = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? scheduleText,
    Expression<String>? diagnosisId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (scheduleText != null) 'schedule_text': scheduleText,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? dosage,
    Value<String?>? scheduleText,
    Value<String?>? diagnosisId,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleText: scheduleText ?? this.scheduleText,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (scheduleText.present) {
      map['schedule_text'] = Variable<String>(scheduleText.value);
    }
    if (diagnosisId.present) {
      map['diagnosis_id'] = Variable<String>(diagnosisId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleText: $scheduleText, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedAppointmentIdMeta =
      const VerificationMeta('relatedAppointmentId');
  @override
  late final GeneratedColumn<String> relatedAppointmentId =
      GeneratedColumn<String>(
        'related_appointment_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES appointments (id)',
        ),
      );
  static const VerificationMeta _relatedDiagnosisIdMeta =
      const VerificationMeta('relatedDiagnosisId');
  @override
  late final GeneratedColumn<String> relatedDiagnosisId =
      GeneratedColumn<String>(
        'related_diagnosis_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES diagnoses (id)',
        ),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    relatedAppointmentId,
    relatedDiagnosisId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('related_appointment_id')) {
      context.handle(
        _relatedAppointmentIdMeta,
        relatedAppointmentId.isAcceptableOrUnknown(
          data['related_appointment_id']!,
          _relatedAppointmentIdMeta,
        ),
      );
    }
    if (data.containsKey('related_diagnosis_id')) {
      context.handle(
        _relatedDiagnosisIdMeta,
        relatedDiagnosisId.isAcceptableOrUnknown(
          data['related_diagnosis_id']!,
          _relatedDiagnosisIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      relatedAppointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_appointment_id'],
      ),
      relatedDiagnosisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_diagnosis_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String body;
  final String? relatedAppointmentId;
  final String? relatedDiagnosisId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.body,
    this.relatedAppointmentId,
    this.relatedDiagnosisId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || relatedAppointmentId != null) {
      map['related_appointment_id'] = Variable<String>(relatedAppointmentId);
    }
    if (!nullToAbsent || relatedDiagnosisId != null) {
      map['related_diagnosis_id'] = Variable<String>(relatedDiagnosisId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      body: Value(body),
      relatedAppointmentId: relatedAppointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedAppointmentId),
      relatedDiagnosisId: relatedDiagnosisId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedDiagnosisId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      relatedAppointmentId: serializer.fromJson<String?>(
        json['relatedAppointmentId'],
      ),
      relatedDiagnosisId: serializer.fromJson<String?>(
        json['relatedDiagnosisId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'relatedAppointmentId': serializer.toJson<String?>(relatedAppointmentId),
      'relatedDiagnosisId': serializer.toJson<String?>(relatedDiagnosisId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    String? id,
    String? body,
    Value<String?> relatedAppointmentId = const Value.absent(),
    Value<String?> relatedDiagnosisId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    body: body ?? this.body,
    relatedAppointmentId: relatedAppointmentId.present
        ? relatedAppointmentId.value
        : this.relatedAppointmentId,
    relatedDiagnosisId: relatedDiagnosisId.present
        ? relatedDiagnosisId.value
        : this.relatedDiagnosisId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      relatedAppointmentId: data.relatedAppointmentId.present
          ? data.relatedAppointmentId.value
          : this.relatedAppointmentId,
      relatedDiagnosisId: data.relatedDiagnosisId.present
          ? data.relatedDiagnosisId.value
          : this.relatedDiagnosisId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('relatedAppointmentId: $relatedAppointmentId, ')
          ..write('relatedDiagnosisId: $relatedDiagnosisId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    body,
    relatedAppointmentId,
    relatedDiagnosisId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.body == this.body &&
          other.relatedAppointmentId == this.relatedAppointmentId &&
          other.relatedDiagnosisId == this.relatedDiagnosisId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> body;
  final Value<String?> relatedAppointmentId;
  final Value<String?> relatedDiagnosisId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.relatedAppointmentId = const Value.absent(),
    this.relatedDiagnosisId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String body,
    this.relatedAppointmentId = const Value.absent(),
    this.relatedDiagnosisId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       body = Value(body),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? body,
    Expression<String>? relatedAppointmentId,
    Expression<String>? relatedDiagnosisId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (relatedAppointmentId != null)
        'related_appointment_id': relatedAppointmentId,
      if (relatedDiagnosisId != null)
        'related_diagnosis_id': relatedDiagnosisId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? body,
    Value<String?>? relatedAppointmentId,
    Value<String?>? relatedDiagnosisId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      relatedAppointmentId: relatedAppointmentId ?? this.relatedAppointmentId,
      relatedDiagnosisId: relatedDiagnosisId ?? this.relatedDiagnosisId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (relatedAppointmentId.present) {
      map['related_appointment_id'] = Variable<String>(
        relatedAppointmentId.value,
      );
    }
    if (relatedDiagnosisId.present) {
      map['related_diagnosis_id'] = Variable<String>(relatedDiagnosisId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('relatedAppointmentId: $relatedAppointmentId, ')
          ..write('relatedDiagnosisId: $relatedDiagnosisId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _morningReminderEnabledMeta =
      const VerificationMeta('morningReminderEnabled');
  @override
  late final GeneratedColumn<bool> morningReminderEnabled =
      GeneratedColumn<bool>(
        'morning_reminder_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("morning_reminder_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _eveningReminderEnabledMeta =
      const VerificationMeta('eveningReminderEnabled');
  @override
  late final GeneratedColumn<bool> eveningReminderEnabled =
      GeneratedColumn<bool>(
        'evening_reminder_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("evening_reminder_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _morningHourMeta = const VerificationMeta(
    'morningHour',
  );
  @override
  late final GeneratedColumn<int> morningHour = GeneratedColumn<int>(
    'morning_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _morningMinuteMeta = const VerificationMeta(
    'morningMinute',
  );
  @override
  late final GeneratedColumn<int> morningMinute = GeneratedColumn<int>(
    'morning_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eveningHourMeta = const VerificationMeta(
    'eveningHour',
  );
  @override
  late final GeneratedColumn<int> eveningHour = GeneratedColumn<int>(
    'evening_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _eveningMinuteMeta = const VerificationMeta(
    'eveningMinute',
  );
  @override
  late final GeneratedColumn<int> eveningMinute = GeneratedColumn<int>(
    'evening_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _calendarSyncEnabledMeta =
      const VerificationMeta('calendarSyncEnabled');
  @override
  late final GeneratedColumn<bool> calendarSyncEnabled = GeneratedColumn<bool>(
    'calendar_sync_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calendar_sync_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<String> calendarId = GeneratedColumn<String>(
    'calendar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calendarIncludeTitleMeta =
      const VerificationMeta('calendarIncludeTitle');
  @override
  late final GeneratedColumn<bool> calendarIncludeTitle = GeneratedColumn<bool>(
    'calendar_include_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calendar_include_title" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _appLockEnabledMeta = const VerificationMeta(
    'appLockEnabled',
  );
  @override
  late final GeneratedColumn<bool> appLockEnabled = GeneratedColumn<bool>(
    'app_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("app_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    morningReminderEnabled,
    eveningReminderEnabled,
    morningHour,
    morningMinute,
    eveningHour,
    eveningMinute,
    calendarSyncEnabled,
    calendarId,
    calendarIncludeTitle,
    appLockEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('morning_reminder_enabled')) {
      context.handle(
        _morningReminderEnabledMeta,
        morningReminderEnabled.isAcceptableOrUnknown(
          data['morning_reminder_enabled']!,
          _morningReminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('evening_reminder_enabled')) {
      context.handle(
        _eveningReminderEnabledMeta,
        eveningReminderEnabled.isAcceptableOrUnknown(
          data['evening_reminder_enabled']!,
          _eveningReminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('morning_hour')) {
      context.handle(
        _morningHourMeta,
        morningHour.isAcceptableOrUnknown(
          data['morning_hour']!,
          _morningHourMeta,
        ),
      );
    }
    if (data.containsKey('morning_minute')) {
      context.handle(
        _morningMinuteMeta,
        morningMinute.isAcceptableOrUnknown(
          data['morning_minute']!,
          _morningMinuteMeta,
        ),
      );
    }
    if (data.containsKey('evening_hour')) {
      context.handle(
        _eveningHourMeta,
        eveningHour.isAcceptableOrUnknown(
          data['evening_hour']!,
          _eveningHourMeta,
        ),
      );
    }
    if (data.containsKey('evening_minute')) {
      context.handle(
        _eveningMinuteMeta,
        eveningMinute.isAcceptableOrUnknown(
          data['evening_minute']!,
          _eveningMinuteMeta,
        ),
      );
    }
    if (data.containsKey('calendar_sync_enabled')) {
      context.handle(
        _calendarSyncEnabledMeta,
        calendarSyncEnabled.isAcceptableOrUnknown(
          data['calendar_sync_enabled']!,
          _calendarSyncEnabledMeta,
        ),
      );
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    }
    if (data.containsKey('calendar_include_title')) {
      context.handle(
        _calendarIncludeTitleMeta,
        calendarIncludeTitle.isAcceptableOrUnknown(
          data['calendar_include_title']!,
          _calendarIncludeTitleMeta,
        ),
      );
    }
    if (data.containsKey('app_lock_enabled')) {
      context.handle(
        _appLockEnabledMeta,
        appLockEnabled.isAcceptableOrUnknown(
          data['app_lock_enabled']!,
          _appLockEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      morningReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}morning_reminder_enabled'],
      )!,
      eveningReminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evening_reminder_enabled'],
      )!,
      morningHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_hour'],
      )!,
      morningMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_minute'],
      )!,
      eveningHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_hour'],
      )!,
      eveningMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_minute'],
      )!,
      calendarSyncEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calendar_sync_enabled'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_id'],
      ),
      calendarIncludeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calendar_include_title'],
      )!,
      appLockEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}app_lock_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final bool morningReminderEnabled;
  final bool eveningReminderEnabled;
  final int morningHour;
  final int morningMinute;
  final int eveningHour;
  final int eveningMinute;
  final bool calendarSyncEnabled;
  final String? calendarId;
  final bool calendarIncludeTitle;
  final bool appLockEnabled;
  const AppSetting({
    required this.id,
    required this.morningReminderEnabled,
    required this.eveningReminderEnabled,
    required this.morningHour,
    required this.morningMinute,
    required this.eveningHour,
    required this.eveningMinute,
    required this.calendarSyncEnabled,
    this.calendarId,
    required this.calendarIncludeTitle,
    required this.appLockEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['morning_reminder_enabled'] = Variable<bool>(morningReminderEnabled);
    map['evening_reminder_enabled'] = Variable<bool>(eveningReminderEnabled);
    map['morning_hour'] = Variable<int>(morningHour);
    map['morning_minute'] = Variable<int>(morningMinute);
    map['evening_hour'] = Variable<int>(eveningHour);
    map['evening_minute'] = Variable<int>(eveningMinute);
    map['calendar_sync_enabled'] = Variable<bool>(calendarSyncEnabled);
    if (!nullToAbsent || calendarId != null) {
      map['calendar_id'] = Variable<String>(calendarId);
    }
    map['calendar_include_title'] = Variable<bool>(calendarIncludeTitle);
    map['app_lock_enabled'] = Variable<bool>(appLockEnabled);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      morningReminderEnabled: Value(morningReminderEnabled),
      eveningReminderEnabled: Value(eveningReminderEnabled),
      morningHour: Value(morningHour),
      morningMinute: Value(morningMinute),
      eveningHour: Value(eveningHour),
      eveningMinute: Value(eveningMinute),
      calendarSyncEnabled: Value(calendarSyncEnabled),
      calendarId: calendarId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarId),
      calendarIncludeTitle: Value(calendarIncludeTitle),
      appLockEnabled: Value(appLockEnabled),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      morningReminderEnabled: serializer.fromJson<bool>(
        json['morningReminderEnabled'],
      ),
      eveningReminderEnabled: serializer.fromJson<bool>(
        json['eveningReminderEnabled'],
      ),
      morningHour: serializer.fromJson<int>(json['morningHour']),
      morningMinute: serializer.fromJson<int>(json['morningMinute']),
      eveningHour: serializer.fromJson<int>(json['eveningHour']),
      eveningMinute: serializer.fromJson<int>(json['eveningMinute']),
      calendarSyncEnabled: serializer.fromJson<bool>(
        json['calendarSyncEnabled'],
      ),
      calendarId: serializer.fromJson<String?>(json['calendarId']),
      calendarIncludeTitle: serializer.fromJson<bool>(
        json['calendarIncludeTitle'],
      ),
      appLockEnabled: serializer.fromJson<bool>(json['appLockEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'morningReminderEnabled': serializer.toJson<bool>(morningReminderEnabled),
      'eveningReminderEnabled': serializer.toJson<bool>(eveningReminderEnabled),
      'morningHour': serializer.toJson<int>(morningHour),
      'morningMinute': serializer.toJson<int>(morningMinute),
      'eveningHour': serializer.toJson<int>(eveningHour),
      'eveningMinute': serializer.toJson<int>(eveningMinute),
      'calendarSyncEnabled': serializer.toJson<bool>(calendarSyncEnabled),
      'calendarId': serializer.toJson<String?>(calendarId),
      'calendarIncludeTitle': serializer.toJson<bool>(calendarIncludeTitle),
      'appLockEnabled': serializer.toJson<bool>(appLockEnabled),
    };
  }

  AppSetting copyWith({
    int? id,
    bool? morningReminderEnabled,
    bool? eveningReminderEnabled,
    int? morningHour,
    int? morningMinute,
    int? eveningHour,
    int? eveningMinute,
    bool? calendarSyncEnabled,
    Value<String?> calendarId = const Value.absent(),
    bool? calendarIncludeTitle,
    bool? appLockEnabled,
  }) => AppSetting(
    id: id ?? this.id,
    morningReminderEnabled:
        morningReminderEnabled ?? this.morningReminderEnabled,
    eveningReminderEnabled:
        eveningReminderEnabled ?? this.eveningReminderEnabled,
    morningHour: morningHour ?? this.morningHour,
    morningMinute: morningMinute ?? this.morningMinute,
    eveningHour: eveningHour ?? this.eveningHour,
    eveningMinute: eveningMinute ?? this.eveningMinute,
    calendarSyncEnabled: calendarSyncEnabled ?? this.calendarSyncEnabled,
    calendarId: calendarId.present ? calendarId.value : this.calendarId,
    calendarIncludeTitle: calendarIncludeTitle ?? this.calendarIncludeTitle,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      morningReminderEnabled: data.morningReminderEnabled.present
          ? data.morningReminderEnabled.value
          : this.morningReminderEnabled,
      eveningReminderEnabled: data.eveningReminderEnabled.present
          ? data.eveningReminderEnabled.value
          : this.eveningReminderEnabled,
      morningHour: data.morningHour.present
          ? data.morningHour.value
          : this.morningHour,
      morningMinute: data.morningMinute.present
          ? data.morningMinute.value
          : this.morningMinute,
      eveningHour: data.eveningHour.present
          ? data.eveningHour.value
          : this.eveningHour,
      eveningMinute: data.eveningMinute.present
          ? data.eveningMinute.value
          : this.eveningMinute,
      calendarSyncEnabled: data.calendarSyncEnabled.present
          ? data.calendarSyncEnabled.value
          : this.calendarSyncEnabled,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      calendarIncludeTitle: data.calendarIncludeTitle.present
          ? data.calendarIncludeTitle.value
          : this.calendarIncludeTitle,
      appLockEnabled: data.appLockEnabled.present
          ? data.appLockEnabled.value
          : this.appLockEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('morningReminderEnabled: $morningReminderEnabled, ')
          ..write('eveningReminderEnabled: $eveningReminderEnabled, ')
          ..write('morningHour: $morningHour, ')
          ..write('morningMinute: $morningMinute, ')
          ..write('eveningHour: $eveningHour, ')
          ..write('eveningMinute: $eveningMinute, ')
          ..write('calendarSyncEnabled: $calendarSyncEnabled, ')
          ..write('calendarId: $calendarId, ')
          ..write('calendarIncludeTitle: $calendarIncludeTitle, ')
          ..write('appLockEnabled: $appLockEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    morningReminderEnabled,
    eveningReminderEnabled,
    morningHour,
    morningMinute,
    eveningHour,
    eveningMinute,
    calendarSyncEnabled,
    calendarId,
    calendarIncludeTitle,
    appLockEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.morningReminderEnabled == this.morningReminderEnabled &&
          other.eveningReminderEnabled == this.eveningReminderEnabled &&
          other.morningHour == this.morningHour &&
          other.morningMinute == this.morningMinute &&
          other.eveningHour == this.eveningHour &&
          other.eveningMinute == this.eveningMinute &&
          other.calendarSyncEnabled == this.calendarSyncEnabled &&
          other.calendarId == this.calendarId &&
          other.calendarIncludeTitle == this.calendarIncludeTitle &&
          other.appLockEnabled == this.appLockEnabled);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<bool> morningReminderEnabled;
  final Value<bool> eveningReminderEnabled;
  final Value<int> morningHour;
  final Value<int> morningMinute;
  final Value<int> eveningHour;
  final Value<int> eveningMinute;
  final Value<bool> calendarSyncEnabled;
  final Value<String?> calendarId;
  final Value<bool> calendarIncludeTitle;
  final Value<bool> appLockEnabled;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.morningReminderEnabled = const Value.absent(),
    this.eveningReminderEnabled = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.morningMinute = const Value.absent(),
    this.eveningHour = const Value.absent(),
    this.eveningMinute = const Value.absent(),
    this.calendarSyncEnabled = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.calendarIncludeTitle = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.morningReminderEnabled = const Value.absent(),
    this.eveningReminderEnabled = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.morningMinute = const Value.absent(),
    this.eveningHour = const Value.absent(),
    this.eveningMinute = const Value.absent(),
    this.calendarSyncEnabled = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.calendarIncludeTitle = const Value.absent(),
    this.appLockEnabled = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<bool>? morningReminderEnabled,
    Expression<bool>? eveningReminderEnabled,
    Expression<int>? morningHour,
    Expression<int>? morningMinute,
    Expression<int>? eveningHour,
    Expression<int>? eveningMinute,
    Expression<bool>? calendarSyncEnabled,
    Expression<String>? calendarId,
    Expression<bool>? calendarIncludeTitle,
    Expression<bool>? appLockEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (morningReminderEnabled != null)
        'morning_reminder_enabled': morningReminderEnabled,
      if (eveningReminderEnabled != null)
        'evening_reminder_enabled': eveningReminderEnabled,
      if (morningHour != null) 'morning_hour': morningHour,
      if (morningMinute != null) 'morning_minute': morningMinute,
      if (eveningHour != null) 'evening_hour': eveningHour,
      if (eveningMinute != null) 'evening_minute': eveningMinute,
      if (calendarSyncEnabled != null)
        'calendar_sync_enabled': calendarSyncEnabled,
      if (calendarId != null) 'calendar_id': calendarId,
      if (calendarIncludeTitle != null)
        'calendar_include_title': calendarIncludeTitle,
      if (appLockEnabled != null) 'app_lock_enabled': appLockEnabled,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? morningReminderEnabled,
    Value<bool>? eveningReminderEnabled,
    Value<int>? morningHour,
    Value<int>? morningMinute,
    Value<int>? eveningHour,
    Value<int>? eveningMinute,
    Value<bool>? calendarSyncEnabled,
    Value<String?>? calendarId,
    Value<bool>? calendarIncludeTitle,
    Value<bool>? appLockEnabled,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      morningReminderEnabled:
          morningReminderEnabled ?? this.morningReminderEnabled,
      eveningReminderEnabled:
          eveningReminderEnabled ?? this.eveningReminderEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
      calendarSyncEnabled: calendarSyncEnabled ?? this.calendarSyncEnabled,
      calendarId: calendarId ?? this.calendarId,
      calendarIncludeTitle: calendarIncludeTitle ?? this.calendarIncludeTitle,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (morningReminderEnabled.present) {
      map['morning_reminder_enabled'] = Variable<bool>(
        morningReminderEnabled.value,
      );
    }
    if (eveningReminderEnabled.present) {
      map['evening_reminder_enabled'] = Variable<bool>(
        eveningReminderEnabled.value,
      );
    }
    if (morningHour.present) {
      map['morning_hour'] = Variable<int>(morningHour.value);
    }
    if (morningMinute.present) {
      map['morning_minute'] = Variable<int>(morningMinute.value);
    }
    if (eveningHour.present) {
      map['evening_hour'] = Variable<int>(eveningHour.value);
    }
    if (eveningMinute.present) {
      map['evening_minute'] = Variable<int>(eveningMinute.value);
    }
    if (calendarSyncEnabled.present) {
      map['calendar_sync_enabled'] = Variable<bool>(calendarSyncEnabled.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<String>(calendarId.value);
    }
    if (calendarIncludeTitle.present) {
      map['calendar_include_title'] = Variable<bool>(
        calendarIncludeTitle.value,
      );
    }
    if (appLockEnabled.present) {
      map['app_lock_enabled'] = Variable<bool>(appLockEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('morningReminderEnabled: $morningReminderEnabled, ')
          ..write('eveningReminderEnabled: $eveningReminderEnabled, ')
          ..write('morningHour: $morningHour, ')
          ..write('morningMinute: $morningMinute, ')
          ..write('eveningHour: $eveningHour, ')
          ..write('eveningMinute: $eveningMinute, ')
          ..write('calendarSyncEnabled: $calendarSyncEnabled, ')
          ..write('calendarId: $calendarId, ')
          ..write('calendarIncludeTitle: $calendarIncludeTitle, ')
          ..write('appLockEnabled: $appLockEnabled')
          ..write(')'))
        .toString();
  }
}

class $CalendarLinksTable extends CalendarLinks
    with TableInfo<$CalendarLinksTable, CalendarLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<String> calendarId = GeneratedColumn<String>(
    'calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalEventIdMeta = const VerificationMeta(
    'externalEventId',
  );
  @override
  late final GeneratedColumn<String> externalEventId = GeneratedColumn<String>(
    'external_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadHashMeta = const VerificationMeta(
    'payloadHash',
  );
  @override
  late final GeneratedColumn<String> payloadHash = GeneratedColumn<String>(
    'payload_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    appointmentId,
    calendarId,
    externalEventId,
    payloadHash,
    syncedAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_calendarIdMeta);
    }
    if (data.containsKey('external_event_id')) {
      context.handle(
        _externalEventIdMeta,
        externalEventId.isAcceptableOrUnknown(
          data['external_event_id']!,
          _externalEventIdMeta,
        ),
      );
    }
    if (data.containsKey('payload_hash')) {
      context.handle(
        _payloadHashMeta,
        payloadHash.isAcceptableOrUnknown(
          data['payload_hash']!,
          _payloadHashMeta,
        ),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appointmentId};
  @override
  CalendarLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarLink(
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_id'],
      )!,
      externalEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_event_id'],
      ),
      payloadHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_hash'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $CalendarLinksTable createAlias(String alias) {
    return $CalendarLinksTable(attachedDatabase, alias);
  }
}

class CalendarLink extends DataClass implements Insertable<CalendarLink> {
  final String appointmentId;
  final String calendarId;
  final String? externalEventId;
  final String? payloadHash;
  final DateTime? syncedAt;
  final String? lastError;
  const CalendarLink({
    required this.appointmentId,
    required this.calendarId,
    this.externalEventId,
    this.payloadHash,
    this.syncedAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['appointment_id'] = Variable<String>(appointmentId);
    map['calendar_id'] = Variable<String>(calendarId);
    if (!nullToAbsent || externalEventId != null) {
      map['external_event_id'] = Variable<String>(externalEventId);
    }
    if (!nullToAbsent || payloadHash != null) {
      map['payload_hash'] = Variable<String>(payloadHash);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  CalendarLinksCompanion toCompanion(bool nullToAbsent) {
    return CalendarLinksCompanion(
      appointmentId: Value(appointmentId),
      calendarId: Value(calendarId),
      externalEventId: externalEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalEventId),
      payloadHash: payloadHash == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadHash),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory CalendarLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarLink(
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      calendarId: serializer.fromJson<String>(json['calendarId']),
      externalEventId: serializer.fromJson<String?>(json['externalEventId']),
      payloadHash: serializer.fromJson<String?>(json['payloadHash']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appointmentId': serializer.toJson<String>(appointmentId),
      'calendarId': serializer.toJson<String>(calendarId),
      'externalEventId': serializer.toJson<String?>(externalEventId),
      'payloadHash': serializer.toJson<String?>(payloadHash),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  CalendarLink copyWith({
    String? appointmentId,
    String? calendarId,
    Value<String?> externalEventId = const Value.absent(),
    Value<String?> payloadHash = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => CalendarLink(
    appointmentId: appointmentId ?? this.appointmentId,
    calendarId: calendarId ?? this.calendarId,
    externalEventId: externalEventId.present
        ? externalEventId.value
        : this.externalEventId,
    payloadHash: payloadHash.present ? payloadHash.value : this.payloadHash,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  CalendarLink copyWithCompanion(CalendarLinksCompanion data) {
    return CalendarLink(
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      externalEventId: data.externalEventId.present
          ? data.externalEventId.value
          : this.externalEventId,
      payloadHash: data.payloadHash.present
          ? data.payloadHash.value
          : this.payloadHash,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarLink(')
          ..write('appointmentId: $appointmentId, ')
          ..write('calendarId: $calendarId, ')
          ..write('externalEventId: $externalEventId, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    appointmentId,
    calendarId,
    externalEventId,
    payloadHash,
    syncedAt,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarLink &&
          other.appointmentId == this.appointmentId &&
          other.calendarId == this.calendarId &&
          other.externalEventId == this.externalEventId &&
          other.payloadHash == this.payloadHash &&
          other.syncedAt == this.syncedAt &&
          other.lastError == this.lastError);
}

class CalendarLinksCompanion extends UpdateCompanion<CalendarLink> {
  final Value<String> appointmentId;
  final Value<String> calendarId;
  final Value<String?> externalEventId;
  final Value<String?> payloadHash;
  final Value<DateTime?> syncedAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const CalendarLinksCompanion({
    this.appointmentId = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.externalEventId = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarLinksCompanion.insert({
    required String appointmentId,
    required String calendarId,
    this.externalEventId = const Value.absent(),
    this.payloadHash = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : appointmentId = Value(appointmentId),
       calendarId = Value(calendarId);
  static Insertable<CalendarLink> custom({
    Expression<String>? appointmentId,
    Expression<String>? calendarId,
    Expression<String>? externalEventId,
    Expression<String>? payloadHash,
    Expression<DateTime>? syncedAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (calendarId != null) 'calendar_id': calendarId,
      if (externalEventId != null) 'external_event_id': externalEventId,
      if (payloadHash != null) 'payload_hash': payloadHash,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarLinksCompanion copyWith({
    Value<String>? appointmentId,
    Value<String>? calendarId,
    Value<String?>? externalEventId,
    Value<String?>? payloadHash,
    Value<DateTime?>? syncedAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return CalendarLinksCompanion(
      appointmentId: appointmentId ?? this.appointmentId,
      calendarId: calendarId ?? this.calendarId,
      externalEventId: externalEventId ?? this.externalEventId,
      payloadHash: payloadHash ?? this.payloadHash,
      syncedAt: syncedAt ?? this.syncedAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<String>(calendarId.value);
    }
    if (externalEventId.present) {
      map['external_event_id'] = Variable<String>(externalEventId.value);
    }
    if (payloadHash.present) {
      map['payload_hash'] = Variable<String>(payloadHash.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarLinksCompanion(')
          ..write('appointmentId: $appointmentId, ')
          ..write('calendarId: $calendarId, ')
          ..write('externalEventId: $externalEventId, ')
          ..write('payloadHash: $payloadHash, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DoctorsTable doctors = $DoctorsTable(this);
  late final $DiagnosesTable diagnoses = $DiagnosesTable(this);
  late final $SymptomsTable symptoms = $SymptomsTable(this);
  late final $SymptomObservationsTable symptomObservations =
      $SymptomObservationsTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $AppointmentDiagnosesTable appointmentDiagnoses =
      $AppointmentDiagnosesTable(this);
  late final $AppointmentSymptomsTable appointmentSymptoms =
      $AppointmentSymptomsTable(this);
  late final $ReportsTable reports = $ReportsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CalendarLinksTable calendarLinks = $CalendarLinksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    doctors,
    diagnoses,
    symptoms,
    symptomObservations,
    appointments,
    appointmentDiagnoses,
    appointmentSymptoms,
    reports,
    medications,
    notes,
    appSettings,
    calendarLinks,
  ];
}

typedef $$DoctorsTableCreateCompanionBuilder = DoctorsCompanion Function({
  required String id,
  required String name,
  Value<String?> specialty,
  Value<String?> practiceName,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DoctorsTableUpdateCompanionBuilder = DoctorsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> specialty,
  Value<String?> practiceName,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DoctorsTableReferences
    extends BaseReferences<_$AppDatabase, $DoctorsTable, Doctor> {
  $$DoctorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
  _appointmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: 'doctors__id__appointments__doctor_id',
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.doctorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DoctorsTableFilterComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get practiceName => $composableBuilder(
    column: $table.practiceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DoctorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get practiceName => $composableBuilder(
    column: $table.practiceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DoctorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<String> get practiceName => $composableBuilder(
    column: $table.practiceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DoctorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoctorsTable,
          Doctor,
          $$DoctorsTableFilterComposer,
          $$DoctorsTableOrderingComposer,
          $$DoctorsTableAnnotationComposer,
          $$DoctorsTableCreateCompanionBuilder,
          $$DoctorsTableUpdateCompanionBuilder,
          (Doctor, $$DoctorsTableReferences),
          Doctor,
          PrefetchHooks Function({bool appointmentsRefs})
        > {
  $$DoctorsTableTableManager(_$AppDatabase db, $DoctorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<String?> practiceName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion(
                id: id,
                name: name,
                specialty: specialty,
                practiceName: practiceName,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> specialty = const Value.absent(),
                Value<String?> practiceName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DoctorsCompanion.insert(
                id: id,
                name: name,
                specialty: specialty,
                practiceName: practiceName,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoctorsTable, Doctor>(table),
                  $$DoctorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appointmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (appointmentsRefs) db.appointments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (appointmentsRefs)
                    await $_getPrefetchedData<
                      Doctor,
                      $DoctorsTable,
                      Appointment
                    >(
                      currentTable: table,
                      referencedTable: $$DoctorsTableReferences
                          ._appointmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$DoctorsTableReferences(
                        db,
                        table,
                        p0,
                      ).appointmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.doctorId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DoctorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoctorsTable,
      Doctor,
      $$DoctorsTableFilterComposer,
      $$DoctorsTableOrderingComposer,
      $$DoctorsTableAnnotationComposer,
      $$DoctorsTableCreateCompanionBuilder,
      $$DoctorsTableUpdateCompanionBuilder,
      (Doctor, $$DoctorsTableReferences),
      Doctor,
      PrefetchHooks Function({bool appointmentsRefs})
    >;
typedef $$DiagnosesTableCreateCompanionBuilder = DiagnosesCompanion Function({
  required String id,
  required String title,
  Value<String?> notes,
  Value<DateTime?> startedAt,
  Value<DateTime?> endedAt,
  required DiagnosisStatus status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DiagnosesTableUpdateCompanionBuilder = DiagnosesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> notes,
  Value<DateTime?> startedAt,
  Value<DateTime?> endedAt,
  Value<DiagnosisStatus> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$DiagnosesTableReferences
    extends BaseReferences<_$AppDatabase, $DiagnosesTable, Diagnose> {
  $$DiagnosesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SymptomsTable, List<Symptom>> _symptomsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.symptoms,
    aliasName: 'diagnoses__id__symptoms__diagnosis_id',
  );

  $$SymptomsTableProcessedTableManager get symptomsRefs {
    final manager = $$SymptomsTableTableManager(
      $_db,
      $_db.symptoms,
    ).filter((f) => f.diagnosisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentDiagnosesTable,
    List<AppointmentDiagnose>
  >
  _appointmentDiagnosesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentDiagnoses,
        aliasName: 'diagnoses__id__appointment_diagnoses__diagnosis_id',
      );

  $$AppointmentDiagnosesTableProcessedTableManager
  get appointmentDiagnosesRefs {
    final manager = $$AppointmentDiagnosesTableTableManager(
      $_db,
      $_db.appointmentDiagnoses,
    ).filter((f) => f.diagnosisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentDiagnosesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicationsTable, List<Medication>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: 'diagnoses__id__medications__diagnosis_id',
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.diagnosisId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'diagnoses__id__notes__related_diagnosis_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager($_db, $_db.notes).filter(
      (f) => f.relatedDiagnosisId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiagnosesTableFilterComposer
    extends Composer<_$AppDatabase, $DiagnosesTable> {
  $$DiagnosesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DiagnosisStatus, DiagnosisStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> symptomsRefs(
    Expression<bool> Function($$SymptomsTableFilterComposer f) f,
  ) {
    final $$SymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableFilterComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentDiagnosesRefs(
    Expression<bool> Function($$AppointmentDiagnosesTableFilterComposer f) f,
  ) {
    final $$AppointmentDiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentDiagnoses,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentDiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.appointmentDiagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.relatedDiagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagnosesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiagnosesTable> {
  $$DiagnosesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiagnosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiagnosesTable> {
  $$DiagnosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DiagnosisStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> symptomsRefs<T extends Object>(
    Expression<T> Function($$SymptomsTableAnnotationComposer a) f,
  ) {
    final $$SymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentDiagnosesRefs<T extends Object>(
    Expression<T> Function($$AppointmentDiagnosesTableAnnotationComposer a) f,
  ) {
    final $$AppointmentDiagnosesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentDiagnoses,
          getReferencedColumn: (t) => t.diagnosisId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentDiagnosesTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentDiagnoses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.diagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.relatedDiagnosisId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiagnosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiagnosesTable,
          Diagnose,
          $$DiagnosesTableFilterComposer,
          $$DiagnosesTableOrderingComposer,
          $$DiagnosesTableAnnotationComposer,
          $$DiagnosesTableCreateCompanionBuilder,
          $$DiagnosesTableUpdateCompanionBuilder,
          (Diagnose, $$DiagnosesTableReferences),
          Diagnose,
          PrefetchHooks Function({
            bool symptomsRefs,
            bool appointmentDiagnosesRefs,
            bool medicationsRefs,
            bool notesRefs,
          })
        > {
  $$DiagnosesTableTableManager(_$AppDatabase db, $DiagnosesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiagnosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiagnosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiagnosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<DiagnosisStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiagnosesCompanion(
                id: id,
                title: title,
                notes: notes,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                required DiagnosisStatus status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DiagnosesCompanion.insert(
                id: id,
                title: title,
                notes: notes,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiagnosesTable, Diagnose>(table),
                  $$DiagnosesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                symptomsRefs = false,
                appointmentDiagnosesRefs = false,
                medicationsRefs = false,
                notesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomsRefs) db.symptoms,
                    if (appointmentDiagnosesRefs) db.appointmentDiagnoses,
                    if (medicationsRefs) db.medications,
                    if (notesRefs) db.notes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (symptomsRefs)
                        await $_getPrefetchedData<
                          Diagnose,
                          $DiagnosesTable,
                          Symptom
                        >(
                          currentTable: table,
                          referencedTable: $$DiagnosesTableReferences
                              ._symptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagnosesTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diagnosisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentDiagnosesRefs)
                        await $_getPrefetchedData<
                          Diagnose,
                          $DiagnosesTable,
                          AppointmentDiagnose
                        >(
                          currentTable: table,
                          referencedTable: $$DiagnosesTableReferences
                              ._appointmentDiagnosesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagnosesTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentDiagnosesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diagnosisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicationsRefs)
                        await $_getPrefetchedData<
                          Diagnose,
                          $DiagnosesTable,
                          Medication
                        >(
                          currentTable: table,
                          referencedTable: $$DiagnosesTableReferences
                              ._medicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagnosesTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diagnosisId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          Diagnose,
                          $DiagnosesTable,
                          Note
                        >(
                          currentTable: table,
                          referencedTable: $$DiagnosesTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiagnosesTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedDiagnosisId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DiagnosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiagnosesTable,
      Diagnose,
      $$DiagnosesTableFilterComposer,
      $$DiagnosesTableOrderingComposer,
      $$DiagnosesTableAnnotationComposer,
      $$DiagnosesTableCreateCompanionBuilder,
      $$DiagnosesTableUpdateCompanionBuilder,
      (Diagnose, $$DiagnosesTableReferences),
      Diagnose,
      PrefetchHooks Function({
        bool symptomsRefs,
        bool appointmentDiagnosesRefs,
        bool medicationsRefs,
        bool notesRefs,
      })
    >;
typedef $$SymptomsTableCreateCompanionBuilder = SymptomsCompanion Function({
  required String id,
  required String label,
  Value<String?> diagnosisId,
  Value<String?> bodyRegion,
  Value<DateTime?> healedAt,
  required CheckInCadence checkInCadence,
  Value<String> reminderTimesJson,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SymptomsTableUpdateCompanionBuilder = SymptomsCompanion Function({
  Value<String> id,
  Value<String> label,
  Value<String?> diagnosisId,
  Value<String?> bodyRegion,
  Value<DateTime?> healedAt,
  Value<CheckInCadence> checkInCadence,
  Value<String> reminderTimesJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SymptomsTableReferences
    extends BaseReferences<_$AppDatabase, $SymptomsTable, Symptom> {
  $$SymptomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiagnosesTable _diagnosisIdTable(_$AppDatabase db) =>
      db.diagnoses.createAlias('symptoms__diagnosis_id__diagnoses__id');

  $$DiagnosesTableProcessedTableManager? get diagnosisId {
    final $_column = $_itemColumn<String>('diagnosis_id');
    if ($_column == null) return null;
    final manager = $$DiagnosesTableTableManager(
      $_db,
      $_db.diagnoses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $SymptomObservationsTable,
    List<SymptomObservation>
  >
  _symptomObservationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.symptomObservations,
        aliasName: 'symptoms__id__symptom_observations__symptom_id',
      );

  $$SymptomObservationsTableProcessedTableManager get symptomObservationsRefs {
    final manager = $$SymptomObservationsTableTableManager(
      $_db,
      $_db.symptomObservations,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _symptomObservationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentSymptomsTable,
    List<AppointmentSymptom>
  >
  _appointmentSymptomsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentSymptoms,
        aliasName: 'symptoms__id__appointment_symptoms__symptom_id',
      );

  $$AppointmentSymptomsTableProcessedTableManager get appointmentSymptomsRefs {
    final manager = $$AppointmentSymptomsTableTableManager(
      $_db,
      $_db.appointmentSymptoms,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentSymptomsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get healedAt => $composableBuilder(
    column: $table.healedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CheckInCadence, CheckInCadence, int>
  get checkInCadence => $composableBuilder(
    column: $table.checkInCadence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get reminderTimesJson => $composableBuilder(
    column: $table.reminderTimesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DiagnosesTableFilterComposer get diagnosisId {
    final $$DiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> symptomObservationsRefs(
    Expression<bool> Function($$SymptomObservationsTableFilterComposer f) f,
  ) {
    final $$SymptomObservationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomObservations,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomObservationsTableFilterComposer(
            $db: $db,
            $table: $db.symptomObservations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentSymptomsRefs(
    Expression<bool> Function($$AppointmentSymptomsTableFilterComposer f) f,
  ) {
    final $$AppointmentSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentSymptoms,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.appointmentSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get healedAt => $composableBuilder(
    column: $table.healedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkInCadence => $composableBuilder(
    column: $table.checkInCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTimesJson => $composableBuilder(
    column: $table.reminderTimesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagnosesTableOrderingComposer get diagnosisId {
    final $$DiagnosesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableOrderingComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomsTable> {
  $$SymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get bodyRegion => $composableBuilder(
    column: $table.bodyRegion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get healedAt =>
      $composableBuilder(column: $table.healedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CheckInCadence, int> get checkInCadence =>
      $composableBuilder(
        column: $table.checkInCadence,
        builder: (column) => column,
      );

  GeneratedColumn<String> get reminderTimesJson => $composableBuilder(
    column: $table.reminderTimesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DiagnosesTableAnnotationComposer get diagnosisId {
    final $$DiagnosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> symptomObservationsRefs<T extends Object>(
    Expression<T> Function($$SymptomObservationsTableAnnotationComposer a) f,
  ) {
    final $$SymptomObservationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.symptomObservations,
          getReferencedColumn: (t) => t.symptomId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SymptomObservationsTableAnnotationComposer(
                $db: $db,
                $table: $db.symptomObservations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> appointmentSymptomsRefs<T extends Object>(
    Expression<T> Function($$AppointmentSymptomsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentSymptomsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentSymptoms,
          getReferencedColumn: (t) => t.symptomId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentSymptomsTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentSymptoms,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomsTable,
          Symptom,
          $$SymptomsTableFilterComposer,
          $$SymptomsTableOrderingComposer,
          $$SymptomsTableAnnotationComposer,
          $$SymptomsTableCreateCompanionBuilder,
          $$SymptomsTableUpdateCompanionBuilder,
          (Symptom, $$SymptomsTableReferences),
          Symptom,
          PrefetchHooks Function({
            bool diagnosisId,
            bool symptomObservationsRefs,
            bool appointmentSymptomsRefs,
          })
        > {
  $$SymptomsTableTableManager(_$AppDatabase db, $SymptomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<String?> bodyRegion = const Value.absent(),
                Value<DateTime?> healedAt = const Value.absent(),
                Value<CheckInCadence> checkInCadence = const Value.absent(),
                Value<String> reminderTimesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion(
                id: id,
                label: label,
                diagnosisId: diagnosisId,
                bodyRegion: bodyRegion,
                healedAt: healedAt,
                checkInCadence: checkInCadence,
                reminderTimesJson: reminderTimesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String?> diagnosisId = const Value.absent(),
                Value<String?> bodyRegion = const Value.absent(),
                Value<DateTime?> healedAt = const Value.absent(),
                required CheckInCadence checkInCadence,
                Value<String> reminderTimesJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion.insert(
                id: id,
                label: label,
                diagnosisId: diagnosisId,
                bodyRegion: bodyRegion,
                healedAt: healedAt,
                checkInCadence: checkInCadence,
                reminderTimesJson: reminderTimesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SymptomsTable, Symptom>(table),
                  $$SymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                diagnosisId = false,
                symptomObservationsRefs = false,
                appointmentSymptomsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomObservationsRefs) db.symptomObservations,
                    if (appointmentSymptomsRefs) db.appointmentSymptoms,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (diagnosisId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.diagnosisId,
                            referencedTable: $$SymptomsTableReferences
                                ._diagnosisIdTable(db),
                            referencedColumn: $$SymptomsTableReferences
                                ._diagnosisIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (symptomObservationsRefs)
                        await $_getPrefetchedData<
                          Symptom,
                          $SymptomsTable,
                          SymptomObservation
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomsTableReferences
                              ._symptomObservationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomObservationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentSymptomsRefs)
                        await $_getPrefetchedData<
                          Symptom,
                          $SymptomsTable,
                          AppointmentSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomsTableReferences
                              ._appointmentSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomsTable,
      Symptom,
      $$SymptomsTableFilterComposer,
      $$SymptomsTableOrderingComposer,
      $$SymptomsTableAnnotationComposer,
      $$SymptomsTableCreateCompanionBuilder,
      $$SymptomsTableUpdateCompanionBuilder,
      (Symptom, $$SymptomsTableReferences),
      Symptom,
      PrefetchHooks Function({
        bool diagnosisId,
        bool symptomObservationsRefs,
        bool appointmentSymptomsRefs,
      })
    >;
typedef $$SymptomObservationsTableCreateCompanionBuilder =
    SymptomObservationsCompanion Function({
      required String id,
      required String symptomId,
      required DateTime recordedAt,
      required ObservationKind kind,
      Value<double?> valueNumber,
      Value<String?> valueText,
      Value<String?> valueColor,
      Value<String?> unit,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SymptomObservationsTableUpdateCompanionBuilder =
    SymptomObservationsCompanion Function({
      Value<String> id,
      Value<String> symptomId,
      Value<DateTime> recordedAt,
      Value<ObservationKind> kind,
      Value<double?> valueNumber,
      Value<String?> valueText,
      Value<String?> valueColor,
      Value<String?> unit,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$SymptomObservationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SymptomObservationsTable,
          SymptomObservation
        > {
  $$SymptomObservationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias('symptom_observations__symptom_id__symptoms__id');

  $$SymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$SymptomsTableTableManager(
      $_db,
      $_db.symptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomObservationsTable> {
  $$SymptomObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ObservationKind, ObservationKind, int>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueColor => $composableBuilder(
    column: $table.valueColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$SymptomsTableFilterComposer get symptomId {
    final $$SymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableFilterComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomObservationsTable> {
  $$SymptomObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueColor => $composableBuilder(
    column: $table.valueColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$SymptomsTableOrderingComposer get symptomId {
    final $$SymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomObservationsTable> {
  $$SymptomObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ObservationKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueText =>
      $composableBuilder(column: $table.valueText, builder: (column) => column);

  GeneratedColumn<String> get valueColor => $composableBuilder(
    column: $table.valueColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$SymptomsTableAnnotationComposer get symptomId {
    final $$SymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SymptomObservationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomObservationsTable,
          SymptomObservation,
          $$SymptomObservationsTableFilterComposer,
          $$SymptomObservationsTableOrderingComposer,
          $$SymptomObservationsTableAnnotationComposer,
          $$SymptomObservationsTableCreateCompanionBuilder,
          $$SymptomObservationsTableUpdateCompanionBuilder,
          (SymptomObservation, $$SymptomObservationsTableReferences),
          SymptomObservation,
          PrefetchHooks Function({bool symptomId})
        > {
  $$SymptomObservationsTableTableManager(
    _$AppDatabase db,
    $SymptomObservationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomObservationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SymptomObservationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<ObservationKind> kind = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<String?> valueColor = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomObservationsCompanion(
                id: id,
                symptomId: symptomId,
                recordedAt: recordedAt,
                kind: kind,
                valueNumber: valueNumber,
                valueText: valueText,
                valueColor: valueColor,
                unit: unit,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String symptomId,
                required DateTime recordedAt,
                required ObservationKind kind,
                Value<double?> valueNumber = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<String?> valueColor = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomObservationsCompanion.insert(
                id: id,
                symptomId: symptomId,
                recordedAt: recordedAt,
                kind: kind,
                valueNumber: valueNumber,
                valueText: valueText,
                valueColor: valueColor,
                unit: unit,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SymptomObservationsTable, SymptomObservation>(
                    table,
                  ),
                  $$SymptomObservationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (symptomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.symptomId,
                        referencedTable: $$SymptomObservationsTableReferences
                            ._symptomIdTable(db),
                        referencedColumn: $$SymptomObservationsTableReferences
                            ._symptomIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SymptomObservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomObservationsTable,
      SymptomObservation,
      $$SymptomObservationsTableFilterComposer,
      $$SymptomObservationsTableOrderingComposer,
      $$SymptomObservationsTableAnnotationComposer,
      $$SymptomObservationsTableCreateCompanionBuilder,
      $$SymptomObservationsTableUpdateCompanionBuilder,
      (SymptomObservation, $$SymptomObservationsTableReferences),
      SymptomObservation,
      PrefetchHooks Function({bool symptomId})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      required String id,
      required String doctorId,
      required DateTime scheduledAt,
      Value<int?> durationMin,
      Value<String?> title,
      Value<String?> notes,
      required AppointmentStatus status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<String> id,
      Value<String> doctorId,
      Value<DateTime> scheduledAt,
      Value<int?> durationMin,
      Value<String?> title,
      Value<String?> notes,
      Value<AppointmentStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AppointmentsTable, Appointment> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DoctorsTable _doctorIdTable(_$AppDatabase db) =>
      db.doctors.createAlias('appointments__doctor_id__doctors__id');

  $$DoctorsTableProcessedTableManager get doctorId {
    final $_column = $_itemColumn<String>('doctor_id')!;

    final manager = $$DoctorsTableTableManager(
      $_db,
      $_db.doctors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_doctorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $AppointmentDiagnosesTable,
    List<AppointmentDiagnose>
  >
  _appointmentDiagnosesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentDiagnoses,
        aliasName: 'appointments__id__appointment_diagnoses__appointment_id',
      );

  $$AppointmentDiagnosesTableProcessedTableManager
  get appointmentDiagnosesRefs {
    final manager = $$AppointmentDiagnosesTableTableManager(
      $_db,
      $_db.appointmentDiagnoses,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentDiagnosesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentSymptomsTable,
    List<AppointmentSymptom>
  >
  _appointmentSymptomsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentSymptoms,
        aliasName: 'appointments__id__appointment_symptoms__appointment_id',
      );

  $$AppointmentSymptomsTableProcessedTableManager get appointmentSymptomsRefs {
    final manager = $$AppointmentSymptomsTableTableManager(
      $_db,
      $_db.appointmentSymptoms,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentSymptomsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReportsTable, List<Report>> _reportsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.reports,
    aliasName: 'appointments__id__reports__appointment_id',
  );

  $$ReportsTableProcessedTableManager get reportsRefs {
    final manager = $$ReportsTableTableManager(
      $_db,
      $_db.reports,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<Note>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'appointments__id__notes__related_appointment_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager($_db, $_db.notes).filter(
      (f) => f.relatedAppointmentId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppointmentStatus, AppointmentStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DoctorsTableFilterComposer get doctorId {
    final $$DoctorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableFilterComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> appointmentDiagnosesRefs(
    Expression<bool> Function($$AppointmentDiagnosesTableFilterComposer f) f,
  ) {
    final $$AppointmentDiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentDiagnoses,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentDiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.appointmentDiagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentSymptomsRefs(
    Expression<bool> Function($$AppointmentSymptomsTableFilterComposer f) f,
  ) {
    final $$AppointmentSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentSymptoms,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.appointmentSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reportsRefs(
    Expression<bool> Function($$ReportsTableFilterComposer f) f,
  ) {
    final $$ReportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableFilterComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.relatedAppointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DoctorsTableOrderingComposer get doctorId {
    final $$DoctorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableOrderingComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppointmentStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DoctorsTableAnnotationComposer get doctorId {
    final $$DoctorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.doctorId,
      referencedTable: $db.doctors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorsTableAnnotationComposer(
            $db: $db,
            $table: $db.doctors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> appointmentDiagnosesRefs<T extends Object>(
    Expression<T> Function($$AppointmentDiagnosesTableAnnotationComposer a) f,
  ) {
    final $$AppointmentDiagnosesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentDiagnoses,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentDiagnosesTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentDiagnoses,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> appointmentSymptomsRefs<T extends Object>(
    Expression<T> Function($$AppointmentSymptomsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentSymptomsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentSymptoms,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentSymptomsTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentSymptoms,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> reportsRefs<T extends Object>(
    Expression<T> Function($$ReportsTableAnnotationComposer a) f,
  ) {
    final $$ReportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reports,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReportsTableAnnotationComposer(
            $db: $db,
            $table: $db.reports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.relatedAppointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentsTable,
          Appointment,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (Appointment, $$AppointmentsTableReferences),
          Appointment,
          PrefetchHooks Function({
            bool doctorId,
            bool appointmentDiagnosesRefs,
            bool appointmentSymptomsRefs,
            bool reportsRefs,
            bool notesRefs,
          })
        > {
  $$AppointmentsTableTableManager(_$AppDatabase db, $AppointmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> doctorId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int?> durationMin = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<AppointmentStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                doctorId: doctorId,
                scheduledAt: scheduledAt,
                durationMin: durationMin,
                title: title,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String doctorId,
                required DateTime scheduledAt,
                Value<int?> durationMin = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required AppointmentStatus status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                doctorId: doctorId,
                scheduledAt: scheduledAt,
                durationMin: durationMin,
                title: title,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentsTable, Appointment>(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                doctorId = false,
                appointmentDiagnosesRefs = false,
                appointmentSymptomsRefs = false,
                reportsRefs = false,
                notesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appointmentDiagnosesRefs) db.appointmentDiagnoses,
                    if (appointmentSymptomsRefs) db.appointmentSymptoms,
                    if (reportsRefs) db.reports,
                    if (notesRefs) db.notes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (doctorId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.doctorId,
                            referencedTable: $$AppointmentsTableReferences
                                ._doctorIdTable(db),
                            referencedColumn: $$AppointmentsTableReferences
                                ._doctorIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appointmentDiagnosesRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          AppointmentDiagnose
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._appointmentDiagnosesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentDiagnosesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentSymptomsRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          AppointmentSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._appointmentSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reportsRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          Report
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._reportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).reportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          Note
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedAppointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentsTable,
      Appointment,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (Appointment, $$AppointmentsTableReferences),
      Appointment,
      PrefetchHooks Function({
        bool doctorId,
        bool appointmentDiagnosesRefs,
        bool appointmentSymptomsRefs,
        bool reportsRefs,
        bool notesRefs,
      })
    >;
typedef $$AppointmentDiagnosesTableCreateCompanionBuilder =
    AppointmentDiagnosesCompanion Function({
      required String appointmentId,
      required String diagnosisId,
      Value<int> rowid,
    });
typedef $$AppointmentDiagnosesTableUpdateCompanionBuilder =
    AppointmentDiagnosesCompanion Function({
      Value<String> appointmentId,
      Value<String> diagnosisId,
      Value<int> rowid,
    });

final class $$AppointmentDiagnosesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AppointmentDiagnosesTable,
          AppointmentDiagnose
        > {
  $$AppointmentDiagnosesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppointmentsTable _appointmentIdTable(_$AppDatabase db) => db
      .appointments
      .createAlias('appointment_diagnoses__appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager get appointmentId {
    final $_column = $_itemColumn<String>('appointment_id')!;

    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DiagnosesTable _diagnosisIdTable(_$AppDatabase db) => db.diagnoses
      .createAlias('appointment_diagnoses__diagnosis_id__diagnoses__id');

  $$DiagnosesTableProcessedTableManager get diagnosisId {
    final $_column = $_itemColumn<String>('diagnosis_id')!;

    final manager = $$DiagnosesTableTableManager(
      $_db,
      $_db.diagnoses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentDiagnosesTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentDiagnosesTable> {
  $$AppointmentDiagnosesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableFilterComposer get diagnosisId {
    final $$DiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentDiagnosesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentDiagnosesTable> {
  $$AppointmentDiagnosesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableOrderingComposer get diagnosisId {
    final $$DiagnosesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableOrderingComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentDiagnosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentDiagnosesTable> {
  $$AppointmentDiagnosesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableAnnotationComposer get diagnosisId {
    final $$DiagnosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentDiagnosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentDiagnosesTable,
          AppointmentDiagnose,
          $$AppointmentDiagnosesTableFilterComposer,
          $$AppointmentDiagnosesTableOrderingComposer,
          $$AppointmentDiagnosesTableAnnotationComposer,
          $$AppointmentDiagnosesTableCreateCompanionBuilder,
          $$AppointmentDiagnosesTableUpdateCompanionBuilder,
          (AppointmentDiagnose, $$AppointmentDiagnosesTableReferences),
          AppointmentDiagnose,
          PrefetchHooks Function({bool appointmentId, bool diagnosisId})
        > {
  $$AppointmentDiagnosesTableTableManager(
    _$AppDatabase db,
    $AppointmentDiagnosesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentDiagnosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentDiagnosesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AppointmentDiagnosesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> appointmentId = const Value.absent(),
                Value<String> diagnosisId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentDiagnosesCompanion(
                appointmentId: appointmentId,
                diagnosisId: diagnosisId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appointmentId,
                required String diagnosisId,
                Value<int> rowid = const Value.absent(),
              }) => AppointmentDiagnosesCompanion.insert(
                appointmentId: appointmentId,
                diagnosisId: diagnosisId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentDiagnosesTable, AppointmentDiagnose>(
                    table,
                  ),
                  $$AppointmentDiagnosesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({appointmentId = false, diagnosisId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (appointmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.appointmentId,
                            referencedTable:
                                $$AppointmentDiagnosesTableReferences
                                    ._appointmentIdTable(db),
                            referencedColumn:
                                $$AppointmentDiagnosesTableReferences
                                    ._appointmentIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (diagnosisId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.diagnosisId,
                            referencedTable:
                                $$AppointmentDiagnosesTableReferences
                                    ._diagnosisIdTable(db),
                            referencedColumn:
                                $$AppointmentDiagnosesTableReferences
                                    ._diagnosisIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AppointmentDiagnosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentDiagnosesTable,
      AppointmentDiagnose,
      $$AppointmentDiagnosesTableFilterComposer,
      $$AppointmentDiagnosesTableOrderingComposer,
      $$AppointmentDiagnosesTableAnnotationComposer,
      $$AppointmentDiagnosesTableCreateCompanionBuilder,
      $$AppointmentDiagnosesTableUpdateCompanionBuilder,
      (AppointmentDiagnose, $$AppointmentDiagnosesTableReferences),
      AppointmentDiagnose,
      PrefetchHooks Function({bool appointmentId, bool diagnosisId})
    >;
typedef $$AppointmentSymptomsTableCreateCompanionBuilder =
    AppointmentSymptomsCompanion Function({
      required String appointmentId,
      required String symptomId,
      Value<int> rowid,
    });
typedef $$AppointmentSymptomsTableUpdateCompanionBuilder =
    AppointmentSymptomsCompanion Function({
      Value<String> appointmentId,
      Value<String> symptomId,
      Value<int> rowid,
    });

final class $$AppointmentSymptomsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AppointmentSymptomsTable,
          AppointmentSymptom
        > {
  $$AppointmentSymptomsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppointmentsTable _appointmentIdTable(_$AppDatabase db) => db
      .appointments
      .createAlias('appointment_symptoms__appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager get appointmentId {
    final $_column = $_itemColumn<String>('appointment_id')!;

    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias('appointment_symptoms__symptom_id__symptoms__id');

  $$SymptomsTableProcessedTableManager get symptomId {
    final $_column = $_itemColumn<String>('symptom_id')!;

    final manager = $$SymptomsTableTableManager(
      $_db,
      $_db.symptoms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_symptomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $AppointmentSymptomsTable> {
  $$AppointmentSymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableFilterComposer get symptomId {
    final $$SymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableFilterComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppointmentSymptomsTable> {
  $$AppointmentSymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableOrderingComposer get symptomId {
    final $$SymptomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableOrderingComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppointmentSymptomsTable> {
  $$AppointmentSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SymptomsTableAnnotationComposer get symptomId {
    final $$SymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.symptomId,
      referencedTable: $db.symptoms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.symptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppointmentSymptomsTable,
          AppointmentSymptom,
          $$AppointmentSymptomsTableFilterComposer,
          $$AppointmentSymptomsTableOrderingComposer,
          $$AppointmentSymptomsTableAnnotationComposer,
          $$AppointmentSymptomsTableCreateCompanionBuilder,
          $$AppointmentSymptomsTableUpdateCompanionBuilder,
          (AppointmentSymptom, $$AppointmentSymptomsTableReferences),
          AppointmentSymptom,
          PrefetchHooks Function({bool appointmentId, bool symptomId})
        > {
  $$AppointmentSymptomsTableTableManager(
    _$AppDatabase db,
    $AppointmentSymptomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentSymptomsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AppointmentSymptomsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> appointmentId = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentSymptomsCompanion(
                appointmentId: appointmentId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appointmentId,
                required String symptomId,
                Value<int> rowid = const Value.absent(),
              }) => AppointmentSymptomsCompanion.insert(
                appointmentId: appointmentId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppointmentSymptomsTable, AppointmentSymptom>(
                    table,
                  ),
                  $$AppointmentSymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appointmentId = false, symptomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (appointmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.appointmentId,
                        referencedTable: $$AppointmentSymptomsTableReferences
                            ._appointmentIdTable(db),
                        referencedColumn: $$AppointmentSymptomsTableReferences
                            ._appointmentIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (symptomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.symptomId,
                        referencedTable: $$AppointmentSymptomsTableReferences
                            ._symptomIdTable(db),
                        referencedColumn: $$AppointmentSymptomsTableReferences
                            ._symptomIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AppointmentSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppointmentSymptomsTable,
      AppointmentSymptom,
      $$AppointmentSymptomsTableFilterComposer,
      $$AppointmentSymptomsTableOrderingComposer,
      $$AppointmentSymptomsTableAnnotationComposer,
      $$AppointmentSymptomsTableCreateCompanionBuilder,
      $$AppointmentSymptomsTableUpdateCompanionBuilder,
      (AppointmentSymptom, $$AppointmentSymptomsTableReferences),
      AppointmentSymptom,
      PrefetchHooks Function({bool appointmentId, bool symptomId})
    >;
typedef $$ReportsTableCreateCompanionBuilder = ReportsCompanion Function({
  required String id,
  Value<String?> appointmentId,
  required String title,
  required String mimeType,
  required String localPath,
  Value<String?> extractedText,
  Value<int?> pageCount,
  required ReportSource source,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ReportsTableUpdateCompanionBuilder = ReportsCompanion Function({
  Value<String> id,
  Value<String?> appointmentId,
  Value<String> title,
  Value<String> mimeType,
  Value<String> localPath,
  Value<String?> extractedText,
  Value<int?> pageCount,
  Value<ReportSource> source,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ReportsTableReferences
    extends BaseReferences<_$AppDatabase, $ReportsTable, Report> {
  $$ReportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppointmentsTable _appointmentIdTable(_$AppDatabase db) =>
      db.appointments.createAlias('reports__appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager? get appointmentId {
    final $_column = $_itemColumn<String>('appointment_id');
    if ($_column == null) return null;
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReportSource, ReportSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsTable> {
  $$ReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReportSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsTable,
          Report,
          $$ReportsTableFilterComposer,
          $$ReportsTableOrderingComposer,
          $$ReportsTableAnnotationComposer,
          $$ReportsTableCreateCompanionBuilder,
          $$ReportsTableUpdateCompanionBuilder,
          (Report, $$ReportsTableReferences),
          Report,
          PrefetchHooks Function({bool appointmentId})
        > {
  $$ReportsTableTableManager(_$AppDatabase db, $ReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<ReportSource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion(
                id: id,
                appointmentId: appointmentId,
                title: title,
                mimeType: mimeType,
                localPath: localPath,
                extractedText: extractedText,
                pageCount: pageCount,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> appointmentId = const Value.absent(),
                required String title,
                required String mimeType,
                required String localPath,
                Value<String?> extractedText = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                required ReportSource source,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReportsCompanion.insert(
                id: id,
                appointmentId: appointmentId,
                title: title,
                mimeType: mimeType,
                localPath: localPath,
                extractedText: extractedText,
                pageCount: pageCount,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReportsTable, Report>(table),
                  $$ReportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({appointmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (appointmentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.appointmentId,
                        referencedTable: $$ReportsTableReferences
                            ._appointmentIdTable(db),
                        referencedColumn: $$ReportsTableReferences
                            ._appointmentIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsTable,
      Report,
      $$ReportsTableFilterComposer,
      $$ReportsTableOrderingComposer,
      $$ReportsTableAnnotationComposer,
      $$ReportsTableCreateCompanionBuilder,
      $$ReportsTableUpdateCompanionBuilder,
      (Report, $$ReportsTableReferences),
      Report,
      PrefetchHooks Function({bool appointmentId})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String name,
      Value<String?> dosage,
      Value<String?> scheduleText,
      Value<String?> diagnosisId,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> dosage,
      Value<String?> scheduleText,
      Value<String?> diagnosisId,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiagnosesTable _diagnosisIdTable(_$AppDatabase db) =>
      db.diagnoses.createAlias('medications__diagnosis_id__diagnoses__id');

  $$DiagnosesTableProcessedTableManager? get diagnosisId {
    final $_column = $_itemColumn<String>('diagnosis_id');
    if ($_column == null) return null;
    final manager = $$DiagnosesTableTableManager(
      $_db,
      $_db.diagnoses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleText => $composableBuilder(
    column: $table.scheduleText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DiagnosesTableFilterComposer get diagnosisId {
    final $$DiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleText => $composableBuilder(
    column: $table.scheduleText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiagnosesTableOrderingComposer get diagnosisId {
    final $$DiagnosesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableOrderingComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get scheduleText => $composableBuilder(
    column: $table.scheduleText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DiagnosesTableAnnotationComposer get diagnosisId {
    final $$DiagnosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool diagnosisId})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleText = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                name: name,
                dosage: dosage,
                scheduleText: scheduleText,
                diagnosisId: diagnosisId,
                startedAt: startedAt,
                endedAt: endedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleText = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                name: name,
                dosage: dosage,
                scheduleText: scheduleText,
                diagnosisId: diagnosisId,
                startedAt: startedAt,
                endedAt: endedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, Medication>(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diagnosisId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diagnosisId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.diagnosisId,
                        referencedTable: $$MedicationsTableReferences
                            ._diagnosisIdTable(db),
                        referencedColumn: $$MedicationsTableReferences
                            ._diagnosisIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool diagnosisId})
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String body,
  Value<String?> relatedAppointmentId,
  Value<String?> relatedDiagnosisId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> body,
  Value<String?> relatedAppointmentId,
  Value<String?> relatedDiagnosisId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, Note> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AppointmentsTable _relatedAppointmentIdTable(_$AppDatabase db) => db
      .appointments
      .createAlias('notes__related_appointment_id__appointments__id');

  $$AppointmentsTableProcessedTableManager? get relatedAppointmentId {
    final $_column = $_itemColumn<String>('related_appointment_id');
    if ($_column == null) return null;
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _relatedAppointmentIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DiagnosesTable _relatedDiagnosisIdTable(_$AppDatabase db) =>
      db.diagnoses.createAlias('notes__related_diagnosis_id__diagnoses__id');

  $$DiagnosesTableProcessedTableManager? get relatedDiagnosisId {
    final $_column = $_itemColumn<String>('related_diagnosis_id');
    if ($_column == null) return null;
    final manager = $$DiagnosesTableTableManager(
      $_db,
      $_db.diagnoses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedDiagnosisIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AppointmentsTableFilterComposer get relatedAppointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedAppointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableFilterComposer get relatedDiagnosisId {
    final $$DiagnosesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedDiagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableFilterComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppointmentsTableOrderingComposer get relatedAppointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedAppointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableOrderingComposer get relatedDiagnosisId {
    final $$DiagnosesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedDiagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableOrderingComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AppointmentsTableAnnotationComposer get relatedAppointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedAppointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DiagnosesTableAnnotationComposer get relatedDiagnosisId {
    final $$DiagnosesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedDiagnosisId,
      referencedTable: $db.diagnoses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiagnosesTableAnnotationComposer(
            $db: $db,
            $table: $db.diagnoses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, $$NotesTableReferences),
          Note,
          PrefetchHooks Function({
            bool relatedAppointmentId,
            bool relatedDiagnosisId,
          })
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> relatedAppointmentId = const Value.absent(),
                Value<String?> relatedDiagnosisId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                body: body,
                relatedAppointmentId: relatedAppointmentId,
                relatedDiagnosisId: relatedDiagnosisId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String body,
                Value<String?> relatedAppointmentId = const Value.absent(),
                Value<String?> relatedDiagnosisId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                body: body,
                relatedAppointmentId: relatedAppointmentId,
                relatedDiagnosisId: relatedDiagnosisId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotesTable, Note>(table),
                  $$NotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({relatedAppointmentId = false, relatedDiagnosisId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (relatedAppointmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.relatedAppointmentId,
                            referencedTable: $$NotesTableReferences
                                ._relatedAppointmentIdTable(db),
                            referencedColumn: $$NotesTableReferences
                                ._relatedAppointmentIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (relatedDiagnosisId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.relatedDiagnosisId,
                            referencedTable: $$NotesTableReferences
                                ._relatedDiagnosisIdTable(db),
                            referencedColumn: $$NotesTableReferences
                                ._relatedDiagnosisIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, $$NotesTableReferences),
      Note,
      PrefetchHooks Function({
        bool relatedAppointmentId,
        bool relatedDiagnosisId,
      })
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> morningReminderEnabled,
      Value<bool> eveningReminderEnabled,
      Value<int> morningHour,
      Value<int> morningMinute,
      Value<int> eveningHour,
      Value<int> eveningMinute,
      Value<bool> calendarSyncEnabled,
      Value<String?> calendarId,
      Value<bool> calendarIncludeTitle,
      Value<bool> appLockEnabled,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<bool> morningReminderEnabled,
      Value<bool> eveningReminderEnabled,
      Value<int> morningHour,
      Value<int> morningMinute,
      Value<int> eveningHour,
      Value<int> eveningMinute,
      Value<bool> calendarSyncEnabled,
      Value<String?> calendarId,
      Value<bool> calendarIncludeTitle,
      Value<bool> appLockEnabled,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get morningReminderEnabled => $composableBuilder(
    column: $table.morningReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eveningReminderEnabled => $composableBuilder(
    column: $table.eveningReminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calendarSyncEnabled => $composableBuilder(
    column: $table.calendarSyncEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calendarIncludeTitle => $composableBuilder(
    column: $table.calendarIncludeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get morningReminderEnabled => $composableBuilder(
    column: $table.morningReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eveningReminderEnabled => $composableBuilder(
    column: $table.eveningReminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calendarSyncEnabled => $composableBuilder(
    column: $table.calendarSyncEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calendarIncludeTitle => $composableBuilder(
    column: $table.calendarIncludeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get morningReminderEnabled => $composableBuilder(
    column: $table.morningReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eveningReminderEnabled => $composableBuilder(
    column: $table.eveningReminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get calendarSyncEnabled => $composableBuilder(
    column: $table.calendarSyncEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get calendarIncludeTitle => $composableBuilder(
    column: $table.calendarIncludeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appLockEnabled => $composableBuilder(
    column: $table.appLockEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> morningReminderEnabled = const Value.absent(),
                Value<bool> eveningReminderEnabled = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> morningMinute = const Value.absent(),
                Value<int> eveningHour = const Value.absent(),
                Value<int> eveningMinute = const Value.absent(),
                Value<bool> calendarSyncEnabled = const Value.absent(),
                Value<String?> calendarId = const Value.absent(),
                Value<bool> calendarIncludeTitle = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                morningReminderEnabled: morningReminderEnabled,
                eveningReminderEnabled: eveningReminderEnabled,
                morningHour: morningHour,
                morningMinute: morningMinute,
                eveningHour: eveningHour,
                eveningMinute: eveningMinute,
                calendarSyncEnabled: calendarSyncEnabled,
                calendarId: calendarId,
                calendarIncludeTitle: calendarIncludeTitle,
                appLockEnabled: appLockEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> morningReminderEnabled = const Value.absent(),
                Value<bool> eveningReminderEnabled = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> morningMinute = const Value.absent(),
                Value<int> eveningHour = const Value.absent(),
                Value<int> eveningMinute = const Value.absent(),
                Value<bool> calendarSyncEnabled = const Value.absent(),
                Value<String?> calendarId = const Value.absent(),
                Value<bool> calendarIncludeTitle = const Value.absent(),
                Value<bool> appLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                morningReminderEnabled: morningReminderEnabled,
                eveningReminderEnabled: eveningReminderEnabled,
                morningHour: morningHour,
                morningMinute: morningMinute,
                eveningHour: eveningHour,
                eveningMinute: eveningMinute,
                calendarSyncEnabled: calendarSyncEnabled,
                calendarId: calendarId,
                calendarIncludeTitle: calendarIncludeTitle,
                appLockEnabled: appLockEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$CalendarLinksTableCreateCompanionBuilder =
    CalendarLinksCompanion Function({
      required String appointmentId,
      required String calendarId,
      Value<String?> externalEventId,
      Value<String?> payloadHash,
      Value<DateTime?> syncedAt,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$CalendarLinksTableUpdateCompanionBuilder =
    CalendarLinksCompanion Function({
      Value<String> appointmentId,
      Value<String> calendarId,
      Value<String?> externalEventId,
      Value<String?> payloadHash,
      Value<DateTime?> syncedAt,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$CalendarLinksTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarLinksTable> {
  $$CalendarLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalEventId => $composableBuilder(
    column: $table.externalEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarLinksTable> {
  $$CalendarLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalEventId => $composableBuilder(
    column: $table.externalEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarLinksTable> {
  $$CalendarLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalEventId => $composableBuilder(
    column: $table.externalEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadHash => $composableBuilder(
    column: $table.payloadHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$CalendarLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarLinksTable,
          CalendarLink,
          $$CalendarLinksTableFilterComposer,
          $$CalendarLinksTableOrderingComposer,
          $$CalendarLinksTableAnnotationComposer,
          $$CalendarLinksTableCreateCompanionBuilder,
          $$CalendarLinksTableUpdateCompanionBuilder,
          (
            CalendarLink,
            BaseReferences<_$AppDatabase, $CalendarLinksTable, CalendarLink>,
          ),
          CalendarLink,
          PrefetchHooks Function()
        > {
  $$CalendarLinksTableTableManager(_$AppDatabase db, $CalendarLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> appointmentId = const Value.absent(),
                Value<String> calendarId = const Value.absent(),
                Value<String?> externalEventId = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarLinksCompanion(
                appointmentId: appointmentId,
                calendarId: calendarId,
                externalEventId: externalEventId,
                payloadHash: payloadHash,
                syncedAt: syncedAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appointmentId,
                required String calendarId,
                Value<String?> externalEventId = const Value.absent(),
                Value<String?> payloadHash = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarLinksCompanion.insert(
                appointmentId: appointmentId,
                calendarId: calendarId,
                externalEventId: externalEventId,
                payloadHash: payloadHash,
                syncedAt: syncedAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalendarLinksTable, CalendarLink>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CalendarLinksTable,
                    CalendarLink
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarLinksTable,
      CalendarLink,
      $$CalendarLinksTableFilterComposer,
      $$CalendarLinksTableOrderingComposer,
      $$CalendarLinksTableAnnotationComposer,
      $$CalendarLinksTableCreateCompanionBuilder,
      $$CalendarLinksTableUpdateCompanionBuilder,
      (
        CalendarLink,
        BaseReferences<_$AppDatabase, $CalendarLinksTable, CalendarLink>,
      ),
      CalendarLink,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DoctorsTableTableManager get doctors =>
      $$DoctorsTableTableManager(_db, _db.doctors);
  $$DiagnosesTableTableManager get diagnoses =>
      $$DiagnosesTableTableManager(_db, _db.diagnoses);
  $$SymptomsTableTableManager get symptoms =>
      $$SymptomsTableTableManager(_db, _db.symptoms);
  $$SymptomObservationsTableTableManager get symptomObservations =>
      $$SymptomObservationsTableTableManager(_db, _db.symptomObservations);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$AppointmentDiagnosesTableTableManager get appointmentDiagnoses =>
      $$AppointmentDiagnosesTableTableManager(_db, _db.appointmentDiagnoses);
  $$AppointmentSymptomsTableTableManager get appointmentSymptoms =>
      $$AppointmentSymptomsTableTableManager(_db, _db.appointmentSymptoms);
  $$ReportsTableTableManager get reports =>
      $$ReportsTableTableManager(_db, _db.reports);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CalendarLinksTableTableManager get calendarLinks =>
      $$CalendarLinksTableTableManager(_db, _db.calendarLinks);
}
