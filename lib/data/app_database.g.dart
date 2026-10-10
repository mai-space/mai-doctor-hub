// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    archivedAt,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
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
    this.archivedAt,
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
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
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
    Value<DateTime?> archivedAt = const Value.absent(),
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
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
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
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
          ..write('archivedAt: $archivedAt, ')
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
    archivedAt,
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
          other.archivedAt == this.archivedAt &&
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
  final Value<DateTime?> archivedAt;
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
    this.archivedAt = const Value.absent(),
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
    this.archivedAt = const Value.absent(),
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
    Expression<DateTime>? archivedAt,
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
      if (archivedAt != null) 'archived_at': archivedAt,
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
    Value<DateTime?>? archivedAt,
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
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
          ..write('archivedAt: $archivedAt, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    archivedAt,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;
  final String title;
  final String? notes;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DiagnosisStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Diagnose({
    this.archivedAt,
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
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
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
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    DiagnosisStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Diagnose(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
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
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
          ..write('archivedAt: $archivedAt, ')
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
    archivedAt,
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
          other.archivedAt == this.archivedAt &&
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
  final Value<DateTime?> archivedAt;
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
    this.archivedAt = const Value.absent(),
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
    this.archivedAt = const Value.absent(),
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
    Expression<DateTime>? archivedAt,
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
      if (archivedAt != null) 'archived_at': archivedAt,
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
    Value<DateTime?>? archivedAt,
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
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
          ..write('archivedAt: $archivedAt, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
  static const VerificationMeta _sensationMeta = const VerificationMeta(
    'sensation',
  );
  @override
  late final GeneratedColumn<String> sensation = GeneratedColumn<String>(
    'sensation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<String> side = GeneratedColumn<String>(
    'side',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measureMeta = const VerificationMeta(
    'measure',
  );
  @override
  late final GeneratedColumn<String> measure = GeneratedColumn<String>(
    'measure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measure2Meta = const VerificationMeta(
    'measure2',
  );
  @override
  late final GeneratedColumn<String> measure2 = GeneratedColumn<String>(
    'measure2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    archivedAt,
    id,
    label,
    diagnosisId,
    bodyRegion,
    healedAt,
    checkInCadence,
    reminderTimesJson,
    createdAt,
    updatedAt,
    sensation,
    quality,
    side,
    measure,
    measure2,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
    if (data.containsKey('sensation')) {
      context.handle(
        _sensationMeta,
        sensation.isAcceptableOrUnknown(data['sensation']!, _sensationMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('side')) {
      context.handle(
        _sideMeta,
        side.isAcceptableOrUnknown(data['side']!, _sideMeta),
      );
    }
    if (data.containsKey('measure')) {
      context.handle(
        _measureMeta,
        measure.isAcceptableOrUnknown(data['measure']!, _measureMeta),
      );
    }
    if (data.containsKey('measure2')) {
      context.handle(
        _measure2Meta,
        measure2.isAcceptableOrUnknown(data['measure2']!, _measure2Meta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Symptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Symptom(
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
      sensation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sensation'],
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      ),
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}side'],
      ),
      measure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure'],
      ),
      measure2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure2'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;
  final String label;
  final String? diagnosisId;
  final String? bodyRegion;
  final DateTime? healedAt;
  final CheckInCadence checkInCadence;
  final String reminderTimesJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Empfindungsart, z. B. „Schmerz“, „Juckreiz“ (Freitext).
  final String? sensation;

  /// Qualität(en), kommagetrennt, z. B. „brennend, pochend“ (Freitext).
  final String? quality;

  /// Seite als Code: `left`, `right`, `both`, `center` (siehe [BodySide]).
  final String? side;
  final String? measure;
  final String? measure2;
  const Symptom({
    this.archivedAt,
    required this.id,
    required this.label,
    this.diagnosisId,
    this.bodyRegion,
    this.healedAt,
    required this.checkInCadence,
    required this.reminderTimesJson,
    required this.createdAt,
    required this.updatedAt,
    this.sensation,
    this.quality,
    this.side,
    this.measure,
    this.measure2,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
    if (!nullToAbsent || sensation != null) {
      map['sensation'] = Variable<String>(sensation);
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<String>(quality);
    }
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<String>(side);
    }
    if (!nullToAbsent || measure != null) {
      map['measure'] = Variable<String>(measure);
    }
    if (!nullToAbsent || measure2 != null) {
      map['measure2'] = Variable<String>(measure2);
    }
    return map;
  }

  SymptomsCompanion toCompanion(bool nullToAbsent) {
    return SymptomsCompanion(
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      sensation: sensation == null && nullToAbsent
          ? const Value.absent()
          : Value(sensation),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
      measure: measure == null && nullToAbsent
          ? const Value.absent()
          : Value(measure),
      measure2: measure2 == null && nullToAbsent
          ? const Value.absent()
          : Value(measure2),
    );
  }

  factory Symptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Symptom(
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      sensation: serializer.fromJson<String?>(json['sensation']),
      quality: serializer.fromJson<String?>(json['quality']),
      side: serializer.fromJson<String?>(json['side']),
      measure: serializer.fromJson<String?>(json['measure']),
      measure2: serializer.fromJson<String?>(json['measure2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
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
      'sensation': serializer.toJson<String?>(sensation),
      'quality': serializer.toJson<String?>(quality),
      'side': serializer.toJson<String?>(side),
      'measure': serializer.toJson<String?>(measure),
      'measure2': serializer.toJson<String?>(measure2),
    };
  }

  Symptom copyWith({
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? label,
    Value<String?> diagnosisId = const Value.absent(),
    Value<String?> bodyRegion = const Value.absent(),
    Value<DateTime?> healedAt = const Value.absent(),
    CheckInCadence? checkInCadence,
    String? reminderTimesJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> sensation = const Value.absent(),
    Value<String?> quality = const Value.absent(),
    Value<String?> side = const Value.absent(),
    Value<String?> measure = const Value.absent(),
    Value<String?> measure2 = const Value.absent(),
  }) => Symptom(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    label: label ?? this.label,
    diagnosisId: diagnosisId.present ? diagnosisId.value : this.diagnosisId,
    bodyRegion: bodyRegion.present ? bodyRegion.value : this.bodyRegion,
    healedAt: healedAt.present ? healedAt.value : this.healedAt,
    checkInCadence: checkInCadence ?? this.checkInCadence,
    reminderTimesJson: reminderTimesJson ?? this.reminderTimesJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sensation: sensation.present ? sensation.value : this.sensation,
    quality: quality.present ? quality.value : this.quality,
    side: side.present ? side.value : this.side,
    measure: measure.present ? measure.value : this.measure,
    measure2: measure2.present ? measure2.value : this.measure2,
  );
  Symptom copyWithCompanion(SymptomsCompanion data) {
    return Symptom(
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
      sensation: data.sensation.present ? data.sensation.value : this.sensation,
      quality: data.quality.present ? data.quality.value : this.quality,
      side: data.side.present ? data.side.value : this.side,
      measure: data.measure.present ? data.measure.value : this.measure,
      measure2: data.measure2.present ? data.measure2.value : this.measure2,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Symptom(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('healedAt: $healedAt, ')
          ..write('checkInCadence: $checkInCadence, ')
          ..write('reminderTimesJson: $reminderTimesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sensation: $sensation, ')
          ..write('quality: $quality, ')
          ..write('side: $side, ')
          ..write('measure: $measure, ')
          ..write('measure2: $measure2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    archivedAt,
    id,
    label,
    diagnosisId,
    bodyRegion,
    healedAt,
    checkInCadence,
    reminderTimesJson,
    createdAt,
    updatedAt,
    sensation,
    quality,
    side,
    measure,
    measure2,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Symptom &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.label == this.label &&
          other.diagnosisId == this.diagnosisId &&
          other.bodyRegion == this.bodyRegion &&
          other.healedAt == this.healedAt &&
          other.checkInCadence == this.checkInCadence &&
          other.reminderTimesJson == this.reminderTimesJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sensation == this.sensation &&
          other.quality == this.quality &&
          other.side == this.side &&
          other.measure == this.measure &&
          other.measure2 == this.measure2);
}

class SymptomsCompanion extends UpdateCompanion<Symptom> {
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> label;
  final Value<String?> diagnosisId;
  final Value<String?> bodyRegion;
  final Value<DateTime?> healedAt;
  final Value<CheckInCadence> checkInCadence;
  final Value<String> reminderTimesJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> sensation;
  final Value<String?> quality;
  final Value<String?> side;
  final Value<String?> measure;
  final Value<String?> measure2;
  final Value<int> rowid;
  const SymptomsCompanion({
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.healedAt = const Value.absent(),
    this.checkInCadence = const Value.absent(),
    this.reminderTimesJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sensation = const Value.absent(),
    this.quality = const Value.absent(),
    this.side = const Value.absent(),
    this.measure = const Value.absent(),
    this.measure2 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomsCompanion.insert({
    this.archivedAt = const Value.absent(),
    required String id,
    required String label,
    this.diagnosisId = const Value.absent(),
    this.bodyRegion = const Value.absent(),
    this.healedAt = const Value.absent(),
    required CheckInCadence checkInCadence,
    this.reminderTimesJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sensation = const Value.absent(),
    this.quality = const Value.absent(),
    this.side = const Value.absent(),
    this.measure = const Value.absent(),
    this.measure2 = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       checkInCadence = Value(checkInCadence),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Symptom> custom({
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? diagnosisId,
    Expression<String>? bodyRegion,
    Expression<DateTime>? healedAt,
    Expression<int>? checkInCadence,
    Expression<String>? reminderTimesJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? sensation,
    Expression<String>? quality,
    Expression<String>? side,
    Expression<String>? measure,
    Expression<String>? measure2,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (bodyRegion != null) 'body_region': bodyRegion,
      if (healedAt != null) 'healed_at': healedAt,
      if (checkInCadence != null) 'check_in_cadence': checkInCadence,
      if (reminderTimesJson != null) 'reminder_times_json': reminderTimesJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sensation != null) 'sensation': sensation,
      if (quality != null) 'quality': quality,
      if (side != null) 'side': side,
      if (measure != null) 'measure': measure,
      if (measure2 != null) 'measure2': measure2,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomsCompanion copyWith({
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? label,
    Value<String?>? diagnosisId,
    Value<String?>? bodyRegion,
    Value<DateTime?>? healedAt,
    Value<CheckInCadence>? checkInCadence,
    Value<String>? reminderTimesJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? sensation,
    Value<String?>? quality,
    Value<String?>? side,
    Value<String?>? measure,
    Value<String?>? measure2,
    Value<int>? rowid,
  }) {
    return SymptomsCompanion(
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      label: label ?? this.label,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      healedAt: healedAt ?? this.healedAt,
      checkInCadence: checkInCadence ?? this.checkInCadence,
      reminderTimesJson: reminderTimesJson ?? this.reminderTimesJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sensation: sensation ?? this.sensation,
      quality: quality ?? this.quality,
      side: side ?? this.side,
      measure: measure ?? this.measure,
      measure2: measure2 ?? this.measure2,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
    if (sensation.present) {
      map['sensation'] = Variable<String>(sensation.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (measure.present) {
      map['measure'] = Variable<String>(measure.value);
    }
    if (measure2.present) {
      map['measure2'] = Variable<String>(measure2.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomsCompanion(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('bodyRegion: $bodyRegion, ')
          ..write('healedAt: $healedAt, ')
          ..write('checkInCadence: $checkInCadence, ')
          ..write('reminderTimesJson: $reminderTimesJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sensation: $sensation, ')
          ..write('quality: $quality, ')
          ..write('side: $side, ')
          ..write('measure: $measure, ')
          ..write('measure2: $measure2, ')
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
  static const VerificationMeta _sensationMeta = const VerificationMeta(
    'sensation',
  );
  @override
  late final GeneratedColumn<String> sensation = GeneratedColumn<String>(
    'sensation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<String> side = GeneratedColumn<String>(
    'side',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measureMeta = const VerificationMeta(
    'measure',
  );
  @override
  late final GeneratedColumn<String> measure = GeneratedColumn<String>(
    'measure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueNumber2Meta = const VerificationMeta(
    'valueNumber2',
  );
  @override
  late final GeneratedColumn<double> valueNumber2 = GeneratedColumn<double>(
    'value_number2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measure2Meta = const VerificationMeta(
    'measure2',
  );
  @override
  late final GeneratedColumn<String> measure2 = GeneratedColumn<String>(
    'measure2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _secondaryValueMeta = const VerificationMeta(
    'secondaryValue',
  );
  @override
  late final GeneratedColumn<double> secondaryValue = GeneratedColumn<double>(
    'secondary_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
    'energy',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anxietyMeta = const VerificationMeta(
    'anxiety',
  );
  @override
  late final GeneratedColumn<int> anxiety = GeneratedColumn<int>(
    'anxiety',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalMeta = const VerificationMeta(
    'journal',
  );
  @override
  late final GeneratedColumn<String> journal = GeneratedColumn<String>(
    'journal',
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
    sensation,
    quality,
    location,
    side,
    pattern,
    measure,
    valueNumber2,
    measure2,
    secondaryValue,
    energy,
    sleepHours,
    anxiety,
    journal,
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
    if (data.containsKey('sensation')) {
      context.handle(
        _sensationMeta,
        sensation.isAcceptableOrUnknown(data['sensation']!, _sensationMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('side')) {
      context.handle(
        _sideMeta,
        side.isAcceptableOrUnknown(data['side']!, _sideMeta),
      );
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    }
    if (data.containsKey('measure')) {
      context.handle(
        _measureMeta,
        measure.isAcceptableOrUnknown(data['measure']!, _measureMeta),
      );
    }
    if (data.containsKey('value_number2')) {
      context.handle(
        _valueNumber2Meta,
        valueNumber2.isAcceptableOrUnknown(
          data['value_number2']!,
          _valueNumber2Meta,
        ),
      );
    }
    if (data.containsKey('measure2')) {
      context.handle(
        _measure2Meta,
        measure2.isAcceptableOrUnknown(data['measure2']!, _measure2Meta),
      );
    }
    if (data.containsKey('secondary_value')) {
      context.handle(
        _secondaryValueMeta,
        secondaryValue.isAcceptableOrUnknown(
          data['secondary_value']!,
          _secondaryValueMeta,
        ),
      );
    }
    if (data.containsKey('energy')) {
      context.handle(
        _energyMeta,
        energy.isAcceptableOrUnknown(data['energy']!, _energyMeta),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('anxiety')) {
      context.handle(
        _anxietyMeta,
        anxiety.isAcceptableOrUnknown(data['anxiety']!, _anxietyMeta),
      );
    }
    if (data.containsKey('journal')) {
      context.handle(
        _journalMeta,
        journal.isAcceptableOrUnknown(data['journal']!, _journalMeta),
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
      sensation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sensation'],
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      side: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}side'],
      ),
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      ),
      measure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure'],
      ),
      valueNumber2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_number2'],
      ),
      measure2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measure2'],
      ),
      secondaryValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}secondary_value'],
      ),
      energy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      anxiety: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anxiety'],
      ),
      journal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal'],
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
  final String? sensation;
  final String? quality;
  final String? location;
  final String? side;

  /// Verlauf/Muster, z. B. „anfallsartig“, „nachts“ (kommagetrennt).
  final String? pattern;

  /// Messgröße von [valueNumber]; leer = aus [kind] (Skala = Stärke 0–10).
  final String? measure;

  /// Zweiter Wert derselben Größe (Blutdruck: diastolisch).
  final double? valueNumber2;

  /// Optionale zweite Messgröße des Check-ins und ihr Wert.
  final String? measure2;
  final double? secondaryValue;

  /// Stimmungs-Extras: Energie 0–10, Schlaf in Stunden, Angst/Anspannung 0–10.
  final int? energy;
  final double? sleepHours;
  final int? anxiety;

  /// Kurzer Tagebuch-Eintrag. Bewusst getrennt von [note]: [note] steht im
  /// Arzt-PDF, das Tagebuch nur auf ausdrücklichen Wunsch.
  final String? journal;
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
    this.sensation,
    this.quality,
    this.location,
    this.side,
    this.pattern,
    this.measure,
    this.valueNumber2,
    this.measure2,
    this.secondaryValue,
    this.energy,
    this.sleepHours,
    this.anxiety,
    this.journal,
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
    if (!nullToAbsent || sensation != null) {
      map['sensation'] = Variable<String>(sensation);
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<String>(quality);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || side != null) {
      map['side'] = Variable<String>(side);
    }
    if (!nullToAbsent || pattern != null) {
      map['pattern'] = Variable<String>(pattern);
    }
    if (!nullToAbsent || measure != null) {
      map['measure'] = Variable<String>(measure);
    }
    if (!nullToAbsent || valueNumber2 != null) {
      map['value_number2'] = Variable<double>(valueNumber2);
    }
    if (!nullToAbsent || measure2 != null) {
      map['measure2'] = Variable<String>(measure2);
    }
    if (!nullToAbsent || secondaryValue != null) {
      map['secondary_value'] = Variable<double>(secondaryValue);
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<int>(energy);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || anxiety != null) {
      map['anxiety'] = Variable<int>(anxiety);
    }
    if (!nullToAbsent || journal != null) {
      map['journal'] = Variable<String>(journal);
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
      sensation: sensation == null && nullToAbsent
          ? const Value.absent()
          : Value(sensation),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      side: side == null && nullToAbsent ? const Value.absent() : Value(side),
      pattern: pattern == null && nullToAbsent
          ? const Value.absent()
          : Value(pattern),
      measure: measure == null && nullToAbsent
          ? const Value.absent()
          : Value(measure),
      valueNumber2: valueNumber2 == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNumber2),
      measure2: measure2 == null && nullToAbsent
          ? const Value.absent()
          : Value(measure2),
      secondaryValue: secondaryValue == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryValue),
      energy: energy == null && nullToAbsent
          ? const Value.absent()
          : Value(energy),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      anxiety: anxiety == null && nullToAbsent
          ? const Value.absent()
          : Value(anxiety),
      journal: journal == null && nullToAbsent
          ? const Value.absent()
          : Value(journal),
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
      sensation: serializer.fromJson<String?>(json['sensation']),
      quality: serializer.fromJson<String?>(json['quality']),
      location: serializer.fromJson<String?>(json['location']),
      side: serializer.fromJson<String?>(json['side']),
      pattern: serializer.fromJson<String?>(json['pattern']),
      measure: serializer.fromJson<String?>(json['measure']),
      valueNumber2: serializer.fromJson<double?>(json['valueNumber2']),
      measure2: serializer.fromJson<String?>(json['measure2']),
      secondaryValue: serializer.fromJson<double?>(json['secondaryValue']),
      energy: serializer.fromJson<int?>(json['energy']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      anxiety: serializer.fromJson<int?>(json['anxiety']),
      journal: serializer.fromJson<String?>(json['journal']),
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
      'sensation': serializer.toJson<String?>(sensation),
      'quality': serializer.toJson<String?>(quality),
      'location': serializer.toJson<String?>(location),
      'side': serializer.toJson<String?>(side),
      'pattern': serializer.toJson<String?>(pattern),
      'measure': serializer.toJson<String?>(measure),
      'valueNumber2': serializer.toJson<double?>(valueNumber2),
      'measure2': serializer.toJson<String?>(measure2),
      'secondaryValue': serializer.toJson<double?>(secondaryValue),
      'energy': serializer.toJson<int?>(energy),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'anxiety': serializer.toJson<int?>(anxiety),
      'journal': serializer.toJson<String?>(journal),
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
    Value<String?> sensation = const Value.absent(),
    Value<String?> quality = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> side = const Value.absent(),
    Value<String?> pattern = const Value.absent(),
    Value<String?> measure = const Value.absent(),
    Value<double?> valueNumber2 = const Value.absent(),
    Value<String?> measure2 = const Value.absent(),
    Value<double?> secondaryValue = const Value.absent(),
    Value<int?> energy = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<int?> anxiety = const Value.absent(),
    Value<String?> journal = const Value.absent(),
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
    sensation: sensation.present ? sensation.value : this.sensation,
    quality: quality.present ? quality.value : this.quality,
    location: location.present ? location.value : this.location,
    side: side.present ? side.value : this.side,
    pattern: pattern.present ? pattern.value : this.pattern,
    measure: measure.present ? measure.value : this.measure,
    valueNumber2: valueNumber2.present ? valueNumber2.value : this.valueNumber2,
    measure2: measure2.present ? measure2.value : this.measure2,
    secondaryValue: secondaryValue.present
        ? secondaryValue.value
        : this.secondaryValue,
    energy: energy.present ? energy.value : this.energy,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    anxiety: anxiety.present ? anxiety.value : this.anxiety,
    journal: journal.present ? journal.value : this.journal,
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
      sensation: data.sensation.present ? data.sensation.value : this.sensation,
      quality: data.quality.present ? data.quality.value : this.quality,
      location: data.location.present ? data.location.value : this.location,
      side: data.side.present ? data.side.value : this.side,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      measure: data.measure.present ? data.measure.value : this.measure,
      valueNumber2: data.valueNumber2.present
          ? data.valueNumber2.value
          : this.valueNumber2,
      measure2: data.measure2.present ? data.measure2.value : this.measure2,
      secondaryValue: data.secondaryValue.present
          ? data.secondaryValue.value
          : this.secondaryValue,
      energy: data.energy.present ? data.energy.value : this.energy,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      anxiety: data.anxiety.present ? data.anxiety.value : this.anxiety,
      journal: data.journal.present ? data.journal.value : this.journal,
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
          ..write('note: $note, ')
          ..write('sensation: $sensation, ')
          ..write('quality: $quality, ')
          ..write('location: $location, ')
          ..write('side: $side, ')
          ..write('pattern: $pattern, ')
          ..write('measure: $measure, ')
          ..write('valueNumber2: $valueNumber2, ')
          ..write('measure2: $measure2, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('energy: $energy, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('anxiety: $anxiety, ')
          ..write('journal: $journal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    symptomId,
    recordedAt,
    kind,
    valueNumber,
    valueText,
    valueColor,
    unit,
    note,
    sensation,
    quality,
    location,
    side,
    pattern,
    measure,
    valueNumber2,
    measure2,
    secondaryValue,
    energy,
    sleepHours,
    anxiety,
    journal,
  ]);
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
          other.note == this.note &&
          other.sensation == this.sensation &&
          other.quality == this.quality &&
          other.location == this.location &&
          other.side == this.side &&
          other.pattern == this.pattern &&
          other.measure == this.measure &&
          other.valueNumber2 == this.valueNumber2 &&
          other.measure2 == this.measure2 &&
          other.secondaryValue == this.secondaryValue &&
          other.energy == this.energy &&
          other.sleepHours == this.sleepHours &&
          other.anxiety == this.anxiety &&
          other.journal == this.journal);
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
  final Value<String?> sensation;
  final Value<String?> quality;
  final Value<String?> location;
  final Value<String?> side;
  final Value<String?> pattern;
  final Value<String?> measure;
  final Value<double?> valueNumber2;
  final Value<String?> measure2;
  final Value<double?> secondaryValue;
  final Value<int?> energy;
  final Value<double?> sleepHours;
  final Value<int?> anxiety;
  final Value<String?> journal;
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
    this.sensation = const Value.absent(),
    this.quality = const Value.absent(),
    this.location = const Value.absent(),
    this.side = const Value.absent(),
    this.pattern = const Value.absent(),
    this.measure = const Value.absent(),
    this.valueNumber2 = const Value.absent(),
    this.measure2 = const Value.absent(),
    this.secondaryValue = const Value.absent(),
    this.energy = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.anxiety = const Value.absent(),
    this.journal = const Value.absent(),
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
    this.sensation = const Value.absent(),
    this.quality = const Value.absent(),
    this.location = const Value.absent(),
    this.side = const Value.absent(),
    this.pattern = const Value.absent(),
    this.measure = const Value.absent(),
    this.valueNumber2 = const Value.absent(),
    this.measure2 = const Value.absent(),
    this.secondaryValue = const Value.absent(),
    this.energy = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.anxiety = const Value.absent(),
    this.journal = const Value.absent(),
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
    Expression<String>? sensation,
    Expression<String>? quality,
    Expression<String>? location,
    Expression<String>? side,
    Expression<String>? pattern,
    Expression<String>? measure,
    Expression<double>? valueNumber2,
    Expression<String>? measure2,
    Expression<double>? secondaryValue,
    Expression<int>? energy,
    Expression<double>? sleepHours,
    Expression<int>? anxiety,
    Expression<String>? journal,
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
      if (sensation != null) 'sensation': sensation,
      if (quality != null) 'quality': quality,
      if (location != null) 'location': location,
      if (side != null) 'side': side,
      if (pattern != null) 'pattern': pattern,
      if (measure != null) 'measure': measure,
      if (valueNumber2 != null) 'value_number2': valueNumber2,
      if (measure2 != null) 'measure2': measure2,
      if (secondaryValue != null) 'secondary_value': secondaryValue,
      if (energy != null) 'energy': energy,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (anxiety != null) 'anxiety': anxiety,
      if (journal != null) 'journal': journal,
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
    Value<String?>? sensation,
    Value<String?>? quality,
    Value<String?>? location,
    Value<String?>? side,
    Value<String?>? pattern,
    Value<String?>? measure,
    Value<double?>? valueNumber2,
    Value<String?>? measure2,
    Value<double?>? secondaryValue,
    Value<int?>? energy,
    Value<double?>? sleepHours,
    Value<int?>? anxiety,
    Value<String?>? journal,
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
      sensation: sensation ?? this.sensation,
      quality: quality ?? this.quality,
      location: location ?? this.location,
      side: side ?? this.side,
      pattern: pattern ?? this.pattern,
      measure: measure ?? this.measure,
      valueNumber2: valueNumber2 ?? this.valueNumber2,
      measure2: measure2 ?? this.measure2,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      energy: energy ?? this.energy,
      sleepHours: sleepHours ?? this.sleepHours,
      anxiety: anxiety ?? this.anxiety,
      journal: journal ?? this.journal,
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
    if (sensation.present) {
      map['sensation'] = Variable<String>(sensation.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (measure.present) {
      map['measure'] = Variable<String>(measure.value);
    }
    if (valueNumber2.present) {
      map['value_number2'] = Variable<double>(valueNumber2.value);
    }
    if (measure2.present) {
      map['measure2'] = Variable<String>(measure2.value);
    }
    if (secondaryValue.present) {
      map['secondary_value'] = Variable<double>(secondaryValue.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (anxiety.present) {
      map['anxiety'] = Variable<int>(anxiety.value);
    }
    if (journal.present) {
      map['journal'] = Variable<String>(journal.value);
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
          ..write('sensation: $sensation, ')
          ..write('quality: $quality, ')
          ..write('location: $location, ')
          ..write('side: $side, ')
          ..write('pattern: $pattern, ')
          ..write('measure: $measure, ')
          ..write('valueNumber2: $valueNumber2, ')
          ..write('measure2: $measure2, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('energy: $energy, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('anxiety: $anxiety, ')
          ..write('journal: $journal, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    archivedAt,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
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
    this.archivedAt,
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
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
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
    Value<DateTime?> archivedAt = const Value.absent(),
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
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
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
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
          ..write('archivedAt: $archivedAt, ')
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
    archivedAt,
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
          other.archivedAt == this.archivedAt &&
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
  final Value<DateTime?> archivedAt;
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
    this.archivedAt = const Value.absent(),
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
    this.archivedAt = const Value.absent(),
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
    Expression<DateTime>? archivedAt,
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
      if (archivedAt != null) 'archived_at': archivedAt,
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
    Value<DateTime?>? archivedAt,
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
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
          ..write('archivedAt: $archivedAt, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    archivedAt,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
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
    this.archivedAt,
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
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
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
    Value<DateTime?> archivedAt = const Value.absent(),
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
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
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
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
          ..write('archivedAt: $archivedAt, ')
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
    archivedAt,
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
          other.archivedAt == this.archivedAt &&
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
  final Value<DateTime?> archivedAt;
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
    this.archivedAt = const Value.absent(),
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
    this.archivedAt = const Value.absent(),
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
    Expression<DateTime>? archivedAt,
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
      if (archivedAt != null) 'archived_at': archivedAt,
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
    Value<DateTime?>? archivedAt,
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
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
          ..write('archivedAt: $archivedAt, ')
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

class $PharmaciesTable extends Pharmacies
    with TableInfo<$PharmaciesTable, Pharmacy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PharmaciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
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
    archivedAt,
    id,
    name,
    address,
    phone,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pharmacies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pharmacy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
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
  Pharmacy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pharmacy(
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
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
  $PharmaciesTable createAlias(String alias) {
    return $PharmaciesTable(attachedDatabase, alias);
  }
}

class Pharmacy extends DataClass implements Insertable<Pharmacy> {
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Pharmacy({
    this.archivedAt,
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PharmaciesCompanion toCompanion(bool nullToAbsent) {
    return PharmaciesCompanion(
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Pharmacy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pharmacy(
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Pharmacy copyWith({
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Pharmacy(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Pharmacy copyWithCompanion(PharmaciesCompanion data) {
    return Pharmacy(
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pharmacy(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    archivedAt,
    id,
    name,
    address,
    phone,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pharmacy &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PharmaciesCompanion extends UpdateCompanion<Pharmacy> {
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PharmaciesCompanion({
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PharmaciesCompanion.insert({
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Pharmacy> custom({
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PharmaciesCompanion copyWith({
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PharmaciesCompanion(
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
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
    return (StringBuffer('PharmaciesCompanion(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
  late final GeneratedColumnWithTypeConverter<MedicationForm?, int> form =
      GeneratedColumn<int>(
        'form',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<MedicationForm?>($MedicationsTable.$converterformn);
  static const VerificationMeta _doseAmountMeta = const VerificationMeta(
    'doseAmount',
  );
  @override
  late final GeneratedColumn<double> doseAmount = GeneratedColumn<double>(
    'dose_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doseUnitMeta = const VerificationMeta(
    'doseUnit',
  );
  @override
  late final GeneratedColumn<String> doseUnit = GeneratedColumn<String>(
    'dose_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescriberIdMeta = const VerificationMeta(
    'prescriberId',
  );
  @override
  late final GeneratedColumn<String> prescriberId = GeneratedColumn<String>(
    'prescriber_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES doctors (id)',
    ),
  );
  static const VerificationMeta _pharmacyIdMeta = const VerificationMeta(
    'pharmacyId',
  );
  @override
  late final GeneratedColumn<String> pharmacyId = GeneratedColumn<String>(
    'pharmacy_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pharmacies (id)',
    ),
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    archivedAt,
    id,
    name,
    dosage,
    scheduleText,
    diagnosisId,
    startedAt,
    endedAt,
    notes,
    createdAt,
    form,
    doseAmount,
    doseUnit,
    instructions,
    prescriberId,
    pharmacyId,
    remindersEnabled,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
    if (data.containsKey('dose_amount')) {
      context.handle(
        _doseAmountMeta,
        doseAmount.isAcceptableOrUnknown(data['dose_amount']!, _doseAmountMeta),
      );
    }
    if (data.containsKey('dose_unit')) {
      context.handle(
        _doseUnitMeta,
        doseUnit.isAcceptableOrUnknown(data['dose_unit']!, _doseUnitMeta),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('prescriber_id')) {
      context.handle(
        _prescriberIdMeta,
        prescriberId.isAcceptableOrUnknown(
          data['prescriber_id']!,
          _prescriberIdMeta,
        ),
      );
    }
    if (data.containsKey('pharmacy_id')) {
      context.handle(
        _pharmacyIdMeta,
        pharmacyId.isAcceptableOrUnknown(data['pharmacy_id']!, _pharmacyIdMeta),
      );
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
      form: $MedicationsTable.$converterformn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}form'],
        ),
      ),
      doseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_amount'],
      ),
      doseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_unit'],
      ),
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      prescriberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescriber_id'],
      ),
      pharmacyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pharmacy_id'],
      ),
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MedicationForm, int, int> $converterform =
      const EnumIndexConverter<MedicationForm>(MedicationForm.values);
  static JsonTypeConverter2<MedicationForm?, int?, int?> $converterformn =
      JsonTypeConverter2.asNullable($converterform);
}

class Medication extends DataClass implements Insertable<Medication> {
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;
  final String name;
  final String? dosage;
  final String? scheduleText;
  final String? diagnosisId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String? notes;
  final DateTime createdAt;

  /// Darreichungsform (Tablette, Tropfen …).
  final MedicationForm? form;

  /// Menge pro Einnahme, z. B. 1 (Stück) oder 20 (Tropfen).
  final double? doseAmount;
  final String? doseUnit;

  /// Hinweise wie „nach dem Essen“.
  final String? instructions;
  final String? prescriberId;
  final String? pharmacyId;
  final bool remindersEnabled;
  const Medication({
    this.archivedAt,
    required this.id,
    required this.name,
    this.dosage,
    this.scheduleText,
    this.diagnosisId,
    this.startedAt,
    this.endedAt,
    this.notes,
    required this.createdAt,
    this.form,
    this.doseAmount,
    this.doseUnit,
    this.instructions,
    this.prescriberId,
    this.pharmacyId,
    required this.remindersEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
    if (!nullToAbsent || form != null) {
      map['form'] = Variable<int>(
        $MedicationsTable.$converterformn.toSql(form),
      );
    }
    if (!nullToAbsent || doseAmount != null) {
      map['dose_amount'] = Variable<double>(doseAmount);
    }
    if (!nullToAbsent || doseUnit != null) {
      map['dose_unit'] = Variable<String>(doseUnit);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || prescriberId != null) {
      map['prescriber_id'] = Variable<String>(prescriberId);
    }
    if (!nullToAbsent || pharmacyId != null) {
      map['pharmacy_id'] = Variable<String>(pharmacyId);
    }
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      form: form == null && nullToAbsent ? const Value.absent() : Value(form),
      doseAmount: doseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(doseAmount),
      doseUnit: doseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(doseUnit),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      prescriberId: prescriberId == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriberId),
      pharmacyId: pharmacyId == null && nullToAbsent
          ? const Value.absent()
          : Value(pharmacyId),
      remindersEnabled: Value(remindersEnabled),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      scheduleText: serializer.fromJson<String?>(json['scheduleText']),
      diagnosisId: serializer.fromJson<String?>(json['diagnosisId']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      form: $MedicationsTable.$converterformn.fromJson(
        serializer.fromJson<int?>(json['form']),
      ),
      doseAmount: serializer.fromJson<double?>(json['doseAmount']),
      doseUnit: serializer.fromJson<String?>(json['doseUnit']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      prescriberId: serializer.fromJson<String?>(json['prescriberId']),
      pharmacyId: serializer.fromJson<String?>(json['pharmacyId']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'scheduleText': serializer.toJson<String?>(scheduleText),
      'diagnosisId': serializer.toJson<String?>(diagnosisId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'form': serializer.toJson<int?>(
        $MedicationsTable.$converterformn.toJson(form),
      ),
      'doseAmount': serializer.toJson<double?>(doseAmount),
      'doseUnit': serializer.toJson<String?>(doseUnit),
      'instructions': serializer.toJson<String?>(instructions),
      'prescriberId': serializer.toJson<String?>(prescriberId),
      'pharmacyId': serializer.toJson<String?>(pharmacyId),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
    };
  }

  Medication copyWith({
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? name,
    Value<String?> dosage = const Value.absent(),
    Value<String?> scheduleText = const Value.absent(),
    Value<String?> diagnosisId = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<MedicationForm?> form = const Value.absent(),
    Value<double?> doseAmount = const Value.absent(),
    Value<String?> doseUnit = const Value.absent(),
    Value<String?> instructions = const Value.absent(),
    Value<String?> prescriberId = const Value.absent(),
    Value<String?> pharmacyId = const Value.absent(),
    bool? remindersEnabled,
  }) => Medication(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    dosage: dosage.present ? dosage.value : this.dosage,
    scheduleText: scheduleText.present ? scheduleText.value : this.scheduleText,
    diagnosisId: diagnosisId.present ? diagnosisId.value : this.diagnosisId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    form: form.present ? form.value : this.form,
    doseAmount: doseAmount.present ? doseAmount.value : this.doseAmount,
    doseUnit: doseUnit.present ? doseUnit.value : this.doseUnit,
    instructions: instructions.present ? instructions.value : this.instructions,
    prescriberId: prescriberId.present ? prescriberId.value : this.prescriberId,
    pharmacyId: pharmacyId.present ? pharmacyId.value : this.pharmacyId,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
      form: data.form.present ? data.form.value : this.form,
      doseAmount: data.doseAmount.present
          ? data.doseAmount.value
          : this.doseAmount,
      doseUnit: data.doseUnit.present ? data.doseUnit.value : this.doseUnit,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      prescriberId: data.prescriberId.present
          ? data.prescriberId.value
          : this.prescriberId,
      pharmacyId: data.pharmacyId.present
          ? data.pharmacyId.value
          : this.pharmacyId,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleText: $scheduleText, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('form: $form, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructions: $instructions, ')
          ..write('prescriberId: $prescriberId, ')
          ..write('pharmacyId: $pharmacyId, ')
          ..write('remindersEnabled: $remindersEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    archivedAt,
    id,
    name,
    dosage,
    scheduleText,
    diagnosisId,
    startedAt,
    endedAt,
    notes,
    createdAt,
    form,
    doseAmount,
    doseUnit,
    instructions,
    prescriberId,
    pharmacyId,
    remindersEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.scheduleText == this.scheduleText &&
          other.diagnosisId == this.diagnosisId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.form == this.form &&
          other.doseAmount == this.doseAmount &&
          other.doseUnit == this.doseUnit &&
          other.instructions == this.instructions &&
          other.prescriberId == this.prescriberId &&
          other.pharmacyId == this.pharmacyId &&
          other.remindersEnabled == this.remindersEnabled);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> scheduleText;
  final Value<String?> diagnosisId;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<MedicationForm?> form;
  final Value<double?> doseAmount;
  final Value<String?> doseUnit;
  final Value<String?> instructions;
  final Value<String?> prescriberId;
  final Value<String?> pharmacyId;
  final Value<bool> remindersEnabled;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.scheduleText = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.form = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructions = const Value.absent(),
    this.prescriberId = const Value.absent(),
    this.pharmacyId = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.archivedAt = const Value.absent(),
    required String id,
    required String name,
    this.dosage = const Value.absent(),
    this.scheduleText = const Value.absent(),
    this.diagnosisId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.form = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.doseUnit = const Value.absent(),
    this.instructions = const Value.absent(),
    this.prescriberId = const Value.absent(),
    this.pharmacyId = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Medication> custom({
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? scheduleText,
    Expression<String>? diagnosisId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? form,
    Expression<double>? doseAmount,
    Expression<String>? doseUnit,
    Expression<String>? instructions,
    Expression<String>? prescriberId,
    Expression<String>? pharmacyId,
    Expression<bool>? remindersEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (scheduleText != null) 'schedule_text': scheduleText,
      if (diagnosisId != null) 'diagnosis_id': diagnosisId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (form != null) 'form': form,
      if (doseAmount != null) 'dose_amount': doseAmount,
      if (doseUnit != null) 'dose_unit': doseUnit,
      if (instructions != null) 'instructions': instructions,
      if (prescriberId != null) 'prescriber_id': prescriberId,
      if (pharmacyId != null) 'pharmacy_id': pharmacyId,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? name,
    Value<String?>? dosage,
    Value<String?>? scheduleText,
    Value<String?>? diagnosisId,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<MedicationForm?>? form,
    Value<double?>? doseAmount,
    Value<String?>? doseUnit,
    Value<String?>? instructions,
    Value<String?>? prescriberId,
    Value<String?>? pharmacyId,
    Value<bool>? remindersEnabled,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      scheduleText: scheduleText ?? this.scheduleText,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      form: form ?? this.form,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      instructions: instructions ?? this.instructions,
      prescriberId: prescriberId ?? this.prescriberId,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
    if (form.present) {
      map['form'] = Variable<int>(
        $MedicationsTable.$converterformn.toSql(form.value),
      );
    }
    if (doseAmount.present) {
      map['dose_amount'] = Variable<double>(doseAmount.value);
    }
    if (doseUnit.present) {
      map['dose_unit'] = Variable<String>(doseUnit.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (prescriberId.present) {
      map['prescriber_id'] = Variable<String>(prescriberId.value);
    }
    if (pharmacyId.present) {
      map['pharmacy_id'] = Variable<String>(pharmacyId.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('scheduleText: $scheduleText, ')
          ..write('diagnosisId: $diagnosisId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('form: $form, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('doseUnit: $doseUnit, ')
          ..write('instructions: $instructions, ')
          ..write('prescriberId: $prescriberId, ')
          ..write('pharmacyId: $pharmacyId, ')
          ..write('remindersEnabled: $remindersEnabled, ')
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
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
    archivedAt,
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
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
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
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
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;
  final String body;
  final String? relatedAppointmentId;
  final String? relatedDiagnosisId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    this.archivedAt,
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
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
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
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
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
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
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
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'body': serializer.toJson<String>(body),
      'relatedAppointmentId': serializer.toJson<String?>(relatedAppointmentId),
      'relatedDiagnosisId': serializer.toJson<String?>(relatedDiagnosisId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? body,
    Value<String?> relatedAppointmentId = const Value.absent(),
    Value<String?> relatedDiagnosisId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
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
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
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
          ..write('archivedAt: $archivedAt, ')
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
    archivedAt,
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
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.body == this.body &&
          other.relatedAppointmentId == this.relatedAppointmentId &&
          other.relatedDiagnosisId == this.relatedDiagnosisId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> body;
  final Value<String?> relatedAppointmentId;
  final Value<String?> relatedDiagnosisId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.relatedAppointmentId = const Value.absent(),
    this.relatedDiagnosisId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    this.archivedAt = const Value.absent(),
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
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? body,
    Expression<String>? relatedAppointmentId,
    Expression<String>? relatedDiagnosisId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (archivedAt != null) 'archived_at': archivedAt,
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
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? body,
    Value<String?>? relatedAppointmentId,
    Value<String?>? relatedDiagnosisId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
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
          ..write('archivedAt: $archivedAt, ')
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
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _appointmentRemindersEnabledMeta =
      const VerificationMeta('appointmentRemindersEnabled');
  @override
  late final GeneratedColumn<bool> appointmentRemindersEnabled =
      GeneratedColumn<bool>(
        'appointment_reminders_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("appointment_reminders_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _appointmentReminderLeadsMeta =
      const VerificationMeta('appointmentReminderLeads');
  @override
  late final GeneratedColumn<String> appointmentReminderLeads =
      GeneratedColumn<String>(
        'appointment_reminder_leads',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('1440,60'),
      );
  static const VerificationMeta _notificationTopicsMeta =
      const VerificationMeta('notificationTopics');
  @override
  late final GeneratedColumn<String> notificationTopics =
      GeneratedColumn<String>(
        'notification_topics',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _cycleTrackingMeta = const VerificationMeta(
    'cycleTracking',
  );
  @override
  late final GeneratedColumn<bool> cycleTracking = GeneratedColumn<bool>(
    'cycle_tracking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cycle_tracking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _menopauseTrackingMeta = const VerificationMeta(
    'menopauseTracking',
  );
  @override
  late final GeneratedColumn<bool> menopauseTracking = GeneratedColumn<bool>(
    'menopause_tracking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("menopause_tracking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pregnancyTrackingMeta = const VerificationMeta(
    'pregnancyTracking',
  );
  @override
  late final GeneratedColumn<bool> pregnancyTracking = GeneratedColumn<bool>(
    'pregnancy_tracking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pregnancy_tracking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showFertileWindowMeta = const VerificationMeta(
    'showFertileWindow',
  );
  @override
  late final GeneratedColumn<bool> showFertileWindow = GeneratedColumn<bool>(
    'show_fertile_window',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_fertile_window" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _temperatureUnitMeta = const VerificationMeta(
    'temperatureUnit',
  );
  @override
  late final GeneratedColumn<String> temperatureUnit = GeneratedColumn<String>(
    'temperature_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glucoseUnitMeta = const VerificationMeta(
    'glucoseUnit',
  );
  @override
  late final GeneratedColumn<String> glucoseUnit = GeneratedColumn<String>(
    'glucose_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _psychQuestionnairesMeta =
      const VerificationMeta('psychQuestionnaires');
  @override
  late final GeneratedColumn<bool> psychQuestionnaires = GeneratedColumn<bool>(
    'psych_questionnaires',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("psych_questionnaires" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _typicalCycleLengthMeta =
      const VerificationMeta('typicalCycleLength');
  @override
  late final GeneratedColumn<int> typicalCycleLength = GeneratedColumn<int>(
    'typical_cycle_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleSetupDoneMeta = const VerificationMeta(
    'cycleSetupDone',
  );
  @override
  late final GeneratedColumn<bool> cycleSetupDone = GeneratedColumn<bool>(
    'cycle_setup_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cycle_setup_done" IN (0, 1))',
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
    onboardingCompleted,
    appointmentRemindersEnabled,
    appointmentReminderLeads,
    notificationTopics,
    cycleTracking,
    menopauseTracking,
    pregnancyTracking,
    showFertileWindow,
    temperatureUnit,
    glucoseUnit,
    weightUnit,
    psychQuestionnaires,
    typicalCycleLength,
    cycleSetupDone,
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
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('appointment_reminders_enabled')) {
      context.handle(
        _appointmentRemindersEnabledMeta,
        appointmentRemindersEnabled.isAcceptableOrUnknown(
          data['appointment_reminders_enabled']!,
          _appointmentRemindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('appointment_reminder_leads')) {
      context.handle(
        _appointmentReminderLeadsMeta,
        appointmentReminderLeads.isAcceptableOrUnknown(
          data['appointment_reminder_leads']!,
          _appointmentReminderLeadsMeta,
        ),
      );
    }
    if (data.containsKey('notification_topics')) {
      context.handle(
        _notificationTopicsMeta,
        notificationTopics.isAcceptableOrUnknown(
          data['notification_topics']!,
          _notificationTopicsMeta,
        ),
      );
    }
    if (data.containsKey('cycle_tracking')) {
      context.handle(
        _cycleTrackingMeta,
        cycleTracking.isAcceptableOrUnknown(
          data['cycle_tracking']!,
          _cycleTrackingMeta,
        ),
      );
    }
    if (data.containsKey('menopause_tracking')) {
      context.handle(
        _menopauseTrackingMeta,
        menopauseTracking.isAcceptableOrUnknown(
          data['menopause_tracking']!,
          _menopauseTrackingMeta,
        ),
      );
    }
    if (data.containsKey('pregnancy_tracking')) {
      context.handle(
        _pregnancyTrackingMeta,
        pregnancyTracking.isAcceptableOrUnknown(
          data['pregnancy_tracking']!,
          _pregnancyTrackingMeta,
        ),
      );
    }
    if (data.containsKey('show_fertile_window')) {
      context.handle(
        _showFertileWindowMeta,
        showFertileWindow.isAcceptableOrUnknown(
          data['show_fertile_window']!,
          _showFertileWindowMeta,
        ),
      );
    }
    if (data.containsKey('temperature_unit')) {
      context.handle(
        _temperatureUnitMeta,
        temperatureUnit.isAcceptableOrUnknown(
          data['temperature_unit']!,
          _temperatureUnitMeta,
        ),
      );
    }
    if (data.containsKey('glucose_unit')) {
      context.handle(
        _glucoseUnitMeta,
        glucoseUnit.isAcceptableOrUnknown(
          data['glucose_unit']!,
          _glucoseUnitMeta,
        ),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('psych_questionnaires')) {
      context.handle(
        _psychQuestionnairesMeta,
        psychQuestionnaires.isAcceptableOrUnknown(
          data['psych_questionnaires']!,
          _psychQuestionnairesMeta,
        ),
      );
    }
    if (data.containsKey('typical_cycle_length')) {
      context.handle(
        _typicalCycleLengthMeta,
        typicalCycleLength.isAcceptableOrUnknown(
          data['typical_cycle_length']!,
          _typicalCycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('cycle_setup_done')) {
      context.handle(
        _cycleSetupDoneMeta,
        cycleSetupDone.isAcceptableOrUnknown(
          data['cycle_setup_done']!,
          _cycleSetupDoneMeta,
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
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      appointmentRemindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}appointment_reminders_enabled'],
      )!,
      appointmentReminderLeads: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_reminder_leads'],
      )!,
      notificationTopics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_topics'],
      )!,
      cycleTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cycle_tracking'],
      )!,
      menopauseTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}menopause_tracking'],
      )!,
      pregnancyTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pregnancy_tracking'],
      )!,
      showFertileWindow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_fertile_window'],
      )!,
      temperatureUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}temperature_unit'],
      ),
      glucoseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glucose_unit'],
      ),
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      ),
      psychQuestionnaires: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}psych_questionnaires'],
      )!,
      typicalCycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typical_cycle_length'],
      ),
      cycleSetupDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cycle_setup_done'],
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
  final bool onboardingCompleted;
  final bool appointmentRemindersEnabled;
  final String appointmentReminderLeads;
  final String notificationTopics;
  final bool cycleTracking;
  final bool menopauseTracking;
  final bool pregnancyTracking;

  /// Grob geschätztes fruchtbares Fenster im Kalender zeigen.
  final bool showFertileWindow;
  final String? temperatureUnit;
  final String? glucoseUnit;
  final String? weightUnit;
  final bool psychQuestionnaires;

  /// Übliche Zykluslänge laut Angabe (21–45); `null` = unbekannt/unregelmäßig.
  final int? typicalCycleLength;

  /// Zyklus-Start erledigt oder übersprungen (nicht erneut nachfragen).
  final bool cycleSetupDone;
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
    required this.onboardingCompleted,
    required this.appointmentRemindersEnabled,
    required this.appointmentReminderLeads,
    required this.notificationTopics,
    required this.cycleTracking,
    required this.menopauseTracking,
    required this.pregnancyTracking,
    required this.showFertileWindow,
    this.temperatureUnit,
    this.glucoseUnit,
    this.weightUnit,
    required this.psychQuestionnaires,
    this.typicalCycleLength,
    required this.cycleSetupDone,
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
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['appointment_reminders_enabled'] = Variable<bool>(
      appointmentRemindersEnabled,
    );
    map['appointment_reminder_leads'] = Variable<String>(
      appointmentReminderLeads,
    );
    map['notification_topics'] = Variable<String>(notificationTopics);
    map['cycle_tracking'] = Variable<bool>(cycleTracking);
    map['menopause_tracking'] = Variable<bool>(menopauseTracking);
    map['pregnancy_tracking'] = Variable<bool>(pregnancyTracking);
    map['show_fertile_window'] = Variable<bool>(showFertileWindow);
    if (!nullToAbsent || temperatureUnit != null) {
      map['temperature_unit'] = Variable<String>(temperatureUnit);
    }
    if (!nullToAbsent || glucoseUnit != null) {
      map['glucose_unit'] = Variable<String>(glucoseUnit);
    }
    if (!nullToAbsent || weightUnit != null) {
      map['weight_unit'] = Variable<String>(weightUnit);
    }
    map['psych_questionnaires'] = Variable<bool>(psychQuestionnaires);
    if (!nullToAbsent || typicalCycleLength != null) {
      map['typical_cycle_length'] = Variable<int>(typicalCycleLength);
    }
    map['cycle_setup_done'] = Variable<bool>(cycleSetupDone);
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
      onboardingCompleted: Value(onboardingCompleted),
      appointmentRemindersEnabled: Value(appointmentRemindersEnabled),
      appointmentReminderLeads: Value(appointmentReminderLeads),
      notificationTopics: Value(notificationTopics),
      cycleTracking: Value(cycleTracking),
      menopauseTracking: Value(menopauseTracking),
      pregnancyTracking: Value(pregnancyTracking),
      showFertileWindow: Value(showFertileWindow),
      temperatureUnit: temperatureUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureUnit),
      glucoseUnit: glucoseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(glucoseUnit),
      weightUnit: weightUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(weightUnit),
      psychQuestionnaires: Value(psychQuestionnaires),
      typicalCycleLength: typicalCycleLength == null && nullToAbsent
          ? const Value.absent()
          : Value(typicalCycleLength),
      cycleSetupDone: Value(cycleSetupDone),
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
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      appointmentRemindersEnabled: serializer.fromJson<bool>(
        json['appointmentRemindersEnabled'],
      ),
      appointmentReminderLeads: serializer.fromJson<String>(
        json['appointmentReminderLeads'],
      ),
      notificationTopics: serializer.fromJson<String>(
        json['notificationTopics'],
      ),
      cycleTracking: serializer.fromJson<bool>(json['cycleTracking']),
      menopauseTracking: serializer.fromJson<bool>(json['menopauseTracking']),
      pregnancyTracking: serializer.fromJson<bool>(json['pregnancyTracking']),
      showFertileWindow: serializer.fromJson<bool>(json['showFertileWindow']),
      temperatureUnit: serializer.fromJson<String?>(json['temperatureUnit']),
      glucoseUnit: serializer.fromJson<String?>(json['glucoseUnit']),
      weightUnit: serializer.fromJson<String?>(json['weightUnit']),
      psychQuestionnaires: serializer.fromJson<bool>(
        json['psychQuestionnaires'],
      ),
      typicalCycleLength: serializer.fromJson<int?>(json['typicalCycleLength']),
      cycleSetupDone: serializer.fromJson<bool>(json['cycleSetupDone']),
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
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'appointmentRemindersEnabled': serializer.toJson<bool>(
        appointmentRemindersEnabled,
      ),
      'appointmentReminderLeads': serializer.toJson<String>(
        appointmentReminderLeads,
      ),
      'notificationTopics': serializer.toJson<String>(notificationTopics),
      'cycleTracking': serializer.toJson<bool>(cycleTracking),
      'menopauseTracking': serializer.toJson<bool>(menopauseTracking),
      'pregnancyTracking': serializer.toJson<bool>(pregnancyTracking),
      'showFertileWindow': serializer.toJson<bool>(showFertileWindow),
      'temperatureUnit': serializer.toJson<String?>(temperatureUnit),
      'glucoseUnit': serializer.toJson<String?>(glucoseUnit),
      'weightUnit': serializer.toJson<String?>(weightUnit),
      'psychQuestionnaires': serializer.toJson<bool>(psychQuestionnaires),
      'typicalCycleLength': serializer.toJson<int?>(typicalCycleLength),
      'cycleSetupDone': serializer.toJson<bool>(cycleSetupDone),
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
    bool? onboardingCompleted,
    bool? appointmentRemindersEnabled,
    String? appointmentReminderLeads,
    String? notificationTopics,
    bool? cycleTracking,
    bool? menopauseTracking,
    bool? pregnancyTracking,
    bool? showFertileWindow,
    Value<String?> temperatureUnit = const Value.absent(),
    Value<String?> glucoseUnit = const Value.absent(),
    Value<String?> weightUnit = const Value.absent(),
    bool? psychQuestionnaires,
    Value<int?> typicalCycleLength = const Value.absent(),
    bool? cycleSetupDone,
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
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    appointmentRemindersEnabled:
        appointmentRemindersEnabled ?? this.appointmentRemindersEnabled,
    appointmentReminderLeads:
        appointmentReminderLeads ?? this.appointmentReminderLeads,
    notificationTopics: notificationTopics ?? this.notificationTopics,
    cycleTracking: cycleTracking ?? this.cycleTracking,
    menopauseTracking: menopauseTracking ?? this.menopauseTracking,
    pregnancyTracking: pregnancyTracking ?? this.pregnancyTracking,
    showFertileWindow: showFertileWindow ?? this.showFertileWindow,
    temperatureUnit: temperatureUnit.present
        ? temperatureUnit.value
        : this.temperatureUnit,
    glucoseUnit: glucoseUnit.present ? glucoseUnit.value : this.glucoseUnit,
    weightUnit: weightUnit.present ? weightUnit.value : this.weightUnit,
    psychQuestionnaires: psychQuestionnaires ?? this.psychQuestionnaires,
    typicalCycleLength: typicalCycleLength.present
        ? typicalCycleLength.value
        : this.typicalCycleLength,
    cycleSetupDone: cycleSetupDone ?? this.cycleSetupDone,
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
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      appointmentRemindersEnabled: data.appointmentRemindersEnabled.present
          ? data.appointmentRemindersEnabled.value
          : this.appointmentRemindersEnabled,
      appointmentReminderLeads: data.appointmentReminderLeads.present
          ? data.appointmentReminderLeads.value
          : this.appointmentReminderLeads,
      notificationTopics: data.notificationTopics.present
          ? data.notificationTopics.value
          : this.notificationTopics,
      cycleTracking: data.cycleTracking.present
          ? data.cycleTracking.value
          : this.cycleTracking,
      menopauseTracking: data.menopauseTracking.present
          ? data.menopauseTracking.value
          : this.menopauseTracking,
      pregnancyTracking: data.pregnancyTracking.present
          ? data.pregnancyTracking.value
          : this.pregnancyTracking,
      showFertileWindow: data.showFertileWindow.present
          ? data.showFertileWindow.value
          : this.showFertileWindow,
      temperatureUnit: data.temperatureUnit.present
          ? data.temperatureUnit.value
          : this.temperatureUnit,
      glucoseUnit: data.glucoseUnit.present
          ? data.glucoseUnit.value
          : this.glucoseUnit,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      psychQuestionnaires: data.psychQuestionnaires.present
          ? data.psychQuestionnaires.value
          : this.psychQuestionnaires,
      typicalCycleLength: data.typicalCycleLength.present
          ? data.typicalCycleLength.value
          : this.typicalCycleLength,
      cycleSetupDone: data.cycleSetupDone.present
          ? data.cycleSetupDone.value
          : this.cycleSetupDone,
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
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('appointmentRemindersEnabled: $appointmentRemindersEnabled, ')
          ..write('appointmentReminderLeads: $appointmentReminderLeads, ')
          ..write('notificationTopics: $notificationTopics, ')
          ..write('cycleTracking: $cycleTracking, ')
          ..write('menopauseTracking: $menopauseTracking, ')
          ..write('pregnancyTracking: $pregnancyTracking, ')
          ..write('showFertileWindow: $showFertileWindow, ')
          ..write('temperatureUnit: $temperatureUnit, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('psychQuestionnaires: $psychQuestionnaires, ')
          ..write('typicalCycleLength: $typicalCycleLength, ')
          ..write('cycleSetupDone: $cycleSetupDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    onboardingCompleted,
    appointmentRemindersEnabled,
    appointmentReminderLeads,
    notificationTopics,
    cycleTracking,
    menopauseTracking,
    pregnancyTracking,
    showFertileWindow,
    temperatureUnit,
    glucoseUnit,
    weightUnit,
    psychQuestionnaires,
    typicalCycleLength,
    cycleSetupDone,
  ]);
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
          other.appLockEnabled == this.appLockEnabled &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.appointmentRemindersEnabled ==
              this.appointmentRemindersEnabled &&
          other.appointmentReminderLeads == this.appointmentReminderLeads &&
          other.notificationTopics == this.notificationTopics &&
          other.cycleTracking == this.cycleTracking &&
          other.menopauseTracking == this.menopauseTracking &&
          other.pregnancyTracking == this.pregnancyTracking &&
          other.showFertileWindow == this.showFertileWindow &&
          other.temperatureUnit == this.temperatureUnit &&
          other.glucoseUnit == this.glucoseUnit &&
          other.weightUnit == this.weightUnit &&
          other.psychQuestionnaires == this.psychQuestionnaires &&
          other.typicalCycleLength == this.typicalCycleLength &&
          other.cycleSetupDone == this.cycleSetupDone);
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
  final Value<bool> onboardingCompleted;
  final Value<bool> appointmentRemindersEnabled;
  final Value<String> appointmentReminderLeads;
  final Value<String> notificationTopics;
  final Value<bool> cycleTracking;
  final Value<bool> menopauseTracking;
  final Value<bool> pregnancyTracking;
  final Value<bool> showFertileWindow;
  final Value<String?> temperatureUnit;
  final Value<String?> glucoseUnit;
  final Value<String?> weightUnit;
  final Value<bool> psychQuestionnaires;
  final Value<int?> typicalCycleLength;
  final Value<bool> cycleSetupDone;
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
    this.onboardingCompleted = const Value.absent(),
    this.appointmentRemindersEnabled = const Value.absent(),
    this.appointmentReminderLeads = const Value.absent(),
    this.notificationTopics = const Value.absent(),
    this.cycleTracking = const Value.absent(),
    this.menopauseTracking = const Value.absent(),
    this.pregnancyTracking = const Value.absent(),
    this.showFertileWindow = const Value.absent(),
    this.temperatureUnit = const Value.absent(),
    this.glucoseUnit = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.psychQuestionnaires = const Value.absent(),
    this.typicalCycleLength = const Value.absent(),
    this.cycleSetupDone = const Value.absent(),
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
    this.onboardingCompleted = const Value.absent(),
    this.appointmentRemindersEnabled = const Value.absent(),
    this.appointmentReminderLeads = const Value.absent(),
    this.notificationTopics = const Value.absent(),
    this.cycleTracking = const Value.absent(),
    this.menopauseTracking = const Value.absent(),
    this.pregnancyTracking = const Value.absent(),
    this.showFertileWindow = const Value.absent(),
    this.temperatureUnit = const Value.absent(),
    this.glucoseUnit = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.psychQuestionnaires = const Value.absent(),
    this.typicalCycleLength = const Value.absent(),
    this.cycleSetupDone = const Value.absent(),
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
    Expression<bool>? onboardingCompleted,
    Expression<bool>? appointmentRemindersEnabled,
    Expression<String>? appointmentReminderLeads,
    Expression<String>? notificationTopics,
    Expression<bool>? cycleTracking,
    Expression<bool>? menopauseTracking,
    Expression<bool>? pregnancyTracking,
    Expression<bool>? showFertileWindow,
    Expression<String>? temperatureUnit,
    Expression<String>? glucoseUnit,
    Expression<String>? weightUnit,
    Expression<bool>? psychQuestionnaires,
    Expression<int>? typicalCycleLength,
    Expression<bool>? cycleSetupDone,
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
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (appointmentRemindersEnabled != null)
        'appointment_reminders_enabled': appointmentRemindersEnabled,
      if (appointmentReminderLeads != null)
        'appointment_reminder_leads': appointmentReminderLeads,
      if (notificationTopics != null) 'notification_topics': notificationTopics,
      if (cycleTracking != null) 'cycle_tracking': cycleTracking,
      if (menopauseTracking != null) 'menopause_tracking': menopauseTracking,
      if (pregnancyTracking != null) 'pregnancy_tracking': pregnancyTracking,
      if (showFertileWindow != null) 'show_fertile_window': showFertileWindow,
      if (temperatureUnit != null) 'temperature_unit': temperatureUnit,
      if (glucoseUnit != null) 'glucose_unit': glucoseUnit,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (psychQuestionnaires != null)
        'psych_questionnaires': psychQuestionnaires,
      if (typicalCycleLength != null)
        'typical_cycle_length': typicalCycleLength,
      if (cycleSetupDone != null) 'cycle_setup_done': cycleSetupDone,
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
    Value<bool>? onboardingCompleted,
    Value<bool>? appointmentRemindersEnabled,
    Value<String>? appointmentReminderLeads,
    Value<String>? notificationTopics,
    Value<bool>? cycleTracking,
    Value<bool>? menopauseTracking,
    Value<bool>? pregnancyTracking,
    Value<bool>? showFertileWindow,
    Value<String?>? temperatureUnit,
    Value<String?>? glucoseUnit,
    Value<String?>? weightUnit,
    Value<bool>? psychQuestionnaires,
    Value<int?>? typicalCycleLength,
    Value<bool>? cycleSetupDone,
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
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      appointmentRemindersEnabled:
          appointmentRemindersEnabled ?? this.appointmentRemindersEnabled,
      appointmentReminderLeads:
          appointmentReminderLeads ?? this.appointmentReminderLeads,
      notificationTopics: notificationTopics ?? this.notificationTopics,
      cycleTracking: cycleTracking ?? this.cycleTracking,
      menopauseTracking: menopauseTracking ?? this.menopauseTracking,
      pregnancyTracking: pregnancyTracking ?? this.pregnancyTracking,
      showFertileWindow: showFertileWindow ?? this.showFertileWindow,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      psychQuestionnaires: psychQuestionnaires ?? this.psychQuestionnaires,
      typicalCycleLength: typicalCycleLength ?? this.typicalCycleLength,
      cycleSetupDone: cycleSetupDone ?? this.cycleSetupDone,
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
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (appointmentRemindersEnabled.present) {
      map['appointment_reminders_enabled'] = Variable<bool>(
        appointmentRemindersEnabled.value,
      );
    }
    if (appointmentReminderLeads.present) {
      map['appointment_reminder_leads'] = Variable<String>(
        appointmentReminderLeads.value,
      );
    }
    if (notificationTopics.present) {
      map['notification_topics'] = Variable<String>(notificationTopics.value);
    }
    if (cycleTracking.present) {
      map['cycle_tracking'] = Variable<bool>(cycleTracking.value);
    }
    if (menopauseTracking.present) {
      map['menopause_tracking'] = Variable<bool>(menopauseTracking.value);
    }
    if (pregnancyTracking.present) {
      map['pregnancy_tracking'] = Variable<bool>(pregnancyTracking.value);
    }
    if (showFertileWindow.present) {
      map['show_fertile_window'] = Variable<bool>(showFertileWindow.value);
    }
    if (temperatureUnit.present) {
      map['temperature_unit'] = Variable<String>(temperatureUnit.value);
    }
    if (glucoseUnit.present) {
      map['glucose_unit'] = Variable<String>(glucoseUnit.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (psychQuestionnaires.present) {
      map['psych_questionnaires'] = Variable<bool>(psychQuestionnaires.value);
    }
    if (typicalCycleLength.present) {
      map['typical_cycle_length'] = Variable<int>(typicalCycleLength.value);
    }
    if (cycleSetupDone.present) {
      map['cycle_setup_done'] = Variable<bool>(cycleSetupDone.value);
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
          ..write('appLockEnabled: $appLockEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('appointmentRemindersEnabled: $appointmentRemindersEnabled, ')
          ..write('appointmentReminderLeads: $appointmentReminderLeads, ')
          ..write('notificationTopics: $notificationTopics, ')
          ..write('cycleTracking: $cycleTracking, ')
          ..write('menopauseTracking: $menopauseTracking, ')
          ..write('pregnancyTracking: $pregnancyTracking, ')
          ..write('showFertileWindow: $showFertileWindow, ')
          ..write('temperatureUnit: $temperatureUnit, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('psychQuestionnaires: $psychQuestionnaires, ')
          ..write('typicalCycleLength: $typicalCycleLength, ')
          ..write('cycleSetupDone: $cycleSetupDone')
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

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    slot,
    title,
    body,
    hour,
    minute,
    weekdays,
    enabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
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
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
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
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;

  /// Stabile Nummer für Benachrichtigungs-IDs (einmalig vergeben).
  final int slot;
  final String title;
  final String? body;
  final int hour;
  final int minute;
  final int weekdays;
  final bool enabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder({
    required this.id,
    required this.slot,
    required this.title,
    this.body,
    required this.hour,
    required this.minute,
    required this.weekdays,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slot'] = Variable<int>(slot);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['weekdays'] = Variable<int>(weekdays);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      slot: Value(slot),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      hour: Value(hour),
      minute: Value(minute),
      weekdays: Value(weekdays),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      slot: serializer.fromJson<int>(json['slot']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slot': serializer.toJson<int>(slot),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'weekdays': serializer.toJson<int>(weekdays),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith({
    String? id,
    int? slot,
    String? title,
    Value<String?> body = const Value.absent(),
    int? hour,
    int? minute,
    int? weekdays,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Reminder(
    id: id ?? this.id,
    slot: slot ?? this.slot,
    title: title ?? this.title,
    body: body.present ? body.value : this.body,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    weekdays: weekdays ?? this.weekdays,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      slot: data.slot.present ? data.slot.value : this.slot,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdays: $weekdays, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slot,
    title,
    body,
    hour,
    minute,
    weekdays,
    enabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.slot == this.slot &&
          other.title == this.title &&
          other.body == this.body &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.weekdays == this.weekdays &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<int> slot;
  final Value<String> title;
  final Value<String?> body;
  final Value<int> hour;
  final Value<int> minute;
  final Value<int> weekdays;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.slot = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required int slot,
    required String title,
    this.body = const Value.absent(),
    required int hour,
    required int minute,
    this.weekdays = const Value.absent(),
    this.enabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       slot = Value(slot),
       title = Value(title),
       hour = Value(hour),
       minute = Value(minute),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<int>? slot,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<int>? weekdays,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slot != null) 'slot': slot,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (weekdays != null) 'weekdays': weekdays,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<int>? slot,
    Value<String>? title,
    Value<String?>? body,
    Value<int>? hour,
    Value<int>? minute,
    Value<int>? weekdays,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      title: title ?? this.title,
      body: body ?? this.body,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
      enabled: enabled ?? this.enabled,
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
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
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
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdays: $weekdays, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderSymptomsTable extends ReminderSymptoms
    with TableInfo<$ReminderSymptomsTable, ReminderSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSymptomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id)',
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
  List<GeneratedColumn> get $columns => [reminderId, symptomId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {reminderId, symptomId};
  @override
  ReminderSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSymptom(
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_id'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
    );
  }

  @override
  $ReminderSymptomsTable createAlias(String alias) {
    return $ReminderSymptomsTable(attachedDatabase, alias);
  }
}

class ReminderSymptom extends DataClass implements Insertable<ReminderSymptom> {
  final String reminderId;
  final String symptomId;
  const ReminderSymptom({required this.reminderId, required this.symptomId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reminder_id'] = Variable<String>(reminderId);
    map['symptom_id'] = Variable<String>(symptomId);
    return map;
  }

  ReminderSymptomsCompanion toCompanion(bool nullToAbsent) {
    return ReminderSymptomsCompanion(
      reminderId: Value(reminderId),
      symptomId: Value(symptomId),
    );
  }

  factory ReminderSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSymptom(
      reminderId: serializer.fromJson<String>(json['reminderId']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'reminderId': serializer.toJson<String>(reminderId),
      'symptomId': serializer.toJson<String>(symptomId),
    };
  }

  ReminderSymptom copyWith({String? reminderId, String? symptomId}) =>
      ReminderSymptom(
        reminderId: reminderId ?? this.reminderId,
        symptomId: symptomId ?? this.symptomId,
      );
  ReminderSymptom copyWithCompanion(ReminderSymptomsCompanion data) {
    return ReminderSymptom(
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSymptom(')
          ..write('reminderId: $reminderId, ')
          ..write('symptomId: $symptomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(reminderId, symptomId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSymptom &&
          other.reminderId == this.reminderId &&
          other.symptomId == this.symptomId);
}

class ReminderSymptomsCompanion extends UpdateCompanion<ReminderSymptom> {
  final Value<String> reminderId;
  final Value<String> symptomId;
  final Value<int> rowid;
  const ReminderSymptomsCompanion({
    this.reminderId = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderSymptomsCompanion.insert({
    required String reminderId,
    required String symptomId,
    this.rowid = const Value.absent(),
  }) : reminderId = Value(reminderId),
       symptomId = Value(symptomId);
  static Insertable<ReminderSymptom> custom({
    Expression<String>? reminderId,
    Expression<String>? symptomId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (reminderId != null) 'reminder_id': reminderId,
      if (symptomId != null) 'symptom_id': symptomId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderSymptomsCompanion copyWith({
    Value<String>? reminderId,
    Value<String>? symptomId,
    Value<int>? rowid,
  }) {
    return ReminderSymptomsCompanion(
      reminderId: reminderId ?? this.reminderId,
      symptomId: symptomId ?? this.symptomId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
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
    return (StringBuffer('ReminderSymptomsCompanion(')
          ..write('reminderId: $reminderId, ')
          ..write('symptomId: $symptomId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoctorSymptomsTable extends DoctorSymptoms
    with TableInfo<$DoctorSymptomsTable, DoctorSymptom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorSymptomsTable(this.attachedDatabase, [this._alias]);
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
  List<GeneratedColumn> get $columns => [doctorId, symptomId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctor_symptoms';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoctorSymptom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_doctorIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {doctorId, symptomId};
  @override
  DoctorSymptom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoctorSymptom(
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
    );
  }

  @override
  $DoctorSymptomsTable createAlias(String alias) {
    return $DoctorSymptomsTable(attachedDatabase, alias);
  }
}

class DoctorSymptom extends DataClass implements Insertable<DoctorSymptom> {
  final String doctorId;
  final String symptomId;
  const DoctorSymptom({required this.doctorId, required this.symptomId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['doctor_id'] = Variable<String>(doctorId);
    map['symptom_id'] = Variable<String>(symptomId);
    return map;
  }

  DoctorSymptomsCompanion toCompanion(bool nullToAbsent) {
    return DoctorSymptomsCompanion(
      doctorId: Value(doctorId),
      symptomId: Value(symptomId),
    );
  }

  factory DoctorSymptom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoctorSymptom(
      doctorId: serializer.fromJson<String>(json['doctorId']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'doctorId': serializer.toJson<String>(doctorId),
      'symptomId': serializer.toJson<String>(symptomId),
    };
  }

  DoctorSymptom copyWith({String? doctorId, String? symptomId}) =>
      DoctorSymptom(
        doctorId: doctorId ?? this.doctorId,
        symptomId: symptomId ?? this.symptomId,
      );
  DoctorSymptom copyWithCompanion(DoctorSymptomsCompanion data) {
    return DoctorSymptom(
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoctorSymptom(')
          ..write('doctorId: $doctorId, ')
          ..write('symptomId: $symptomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(doctorId, symptomId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoctorSymptom &&
          other.doctorId == this.doctorId &&
          other.symptomId == this.symptomId);
}

class DoctorSymptomsCompanion extends UpdateCompanion<DoctorSymptom> {
  final Value<String> doctorId;
  final Value<String> symptomId;
  final Value<int> rowid;
  const DoctorSymptomsCompanion({
    this.doctorId = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorSymptomsCompanion.insert({
    required String doctorId,
    required String symptomId,
    this.rowid = const Value.absent(),
  }) : doctorId = Value(doctorId),
       symptomId = Value(symptomId);
  static Insertable<DoctorSymptom> custom({
    Expression<String>? doctorId,
    Expression<String>? symptomId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (doctorId != null) 'doctor_id': doctorId,
      if (symptomId != null) 'symptom_id': symptomId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorSymptomsCompanion copyWith({
    Value<String>? doctorId,
    Value<String>? symptomId,
    Value<int>? rowid,
  }) {
    return DoctorSymptomsCompanion(
      doctorId: doctorId ?? this.doctorId,
      symptomId: symptomId ?? this.symptomId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
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
    return (StringBuffer('DoctorSymptomsCompanion(')
          ..write('doctorId: $doctorId, ')
          ..write('symptomId: $symptomId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationSchedulesTable extends MedicationSchedules
    with TableInfo<$MedicationSchedulesTable, MedicationSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _doseAmountMeta = const VerificationMeta(
    'doseAmount',
  );
  @override
  late final GeneratedColumn<double> doseAmount = GeneratedColumn<double>(
    'dose_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    slot,
    hour,
    minute,
    weekdays,
    doseAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    }
    if (data.containsKey('dose_amount')) {
      context.handle(
        _doseAmountMeta,
        doseAmount.isAcceptableOrUnknown(data['dose_amount']!, _doseAmountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      doseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_amount'],
      ),
    );
  }

  @override
  $MedicationSchedulesTable createAlias(String alias) {
    return $MedicationSchedulesTable(attachedDatabase, alias);
  }
}

class MedicationSchedule extends DataClass
    implements Insertable<MedicationSchedule> {
  final String id;
  final String medicationId;

  /// Stabile Nummer für Benachrichtigungs-IDs.
  final int slot;
  final int hour;
  final int minute;
  final int weekdays;

  /// Abweichende Menge für diese Einnahme (sonst die des Medikaments).
  final double? doseAmount;
  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.slot,
    required this.hour,
    required this.minute,
    required this.weekdays,
    this.doseAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['slot'] = Variable<int>(slot);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['weekdays'] = Variable<int>(weekdays);
    if (!nullToAbsent || doseAmount != null) {
      map['dose_amount'] = Variable<double>(doseAmount);
    }
    return map;
  }

  MedicationSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MedicationSchedulesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      slot: Value(slot),
      hour: Value(hour),
      minute: Value(minute),
      weekdays: Value(weekdays),
      doseAmount: doseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(doseAmount),
    );
  }

  factory MedicationSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationSchedule(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      slot: serializer.fromJson<int>(json['slot']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      doseAmount: serializer.fromJson<double?>(json['doseAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'slot': serializer.toJson<int>(slot),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'weekdays': serializer.toJson<int>(weekdays),
      'doseAmount': serializer.toJson<double?>(doseAmount),
    };
  }

  MedicationSchedule copyWith({
    String? id,
    String? medicationId,
    int? slot,
    int? hour,
    int? minute,
    int? weekdays,
    Value<double?> doseAmount = const Value.absent(),
  }) => MedicationSchedule(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    slot: slot ?? this.slot,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    weekdays: weekdays ?? this.weekdays,
    doseAmount: doseAmount.present ? doseAmount.value : this.doseAmount,
  );
  MedicationSchedule copyWithCompanion(MedicationSchedulesCompanion data) {
    return MedicationSchedule(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      slot: data.slot.present ? data.slot.value : this.slot,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      doseAmount: data.doseAmount.present
          ? data.doseAmount.value
          : this.doseAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedule(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdays: $weekdays, ')
          ..write('doseAmount: $doseAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medicationId, slot, hour, minute, weekdays, doseAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationSchedule &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.slot == this.slot &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.weekdays == this.weekdays &&
          other.doseAmount == this.doseAmount);
}

class MedicationSchedulesCompanion extends UpdateCompanion<MedicationSchedule> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<int> slot;
  final Value<int> hour;
  final Value<int> minute;
  final Value<int> weekdays;
  final Value<double?> doseAmount;
  final Value<int> rowid;
  const MedicationSchedulesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.slot = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationSchedulesCompanion.insert({
    required String id,
    required String medicationId,
    required int slot,
    required int hour,
    required int minute,
    this.weekdays = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       slot = Value(slot),
       hour = Value(hour),
       minute = Value(minute);
  static Insertable<MedicationSchedule> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<int>? slot,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<int>? weekdays,
    Expression<double>? doseAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (slot != null) 'slot': slot,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (weekdays != null) 'weekdays': weekdays,
      if (doseAmount != null) 'dose_amount': doseAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationSchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<int>? slot,
    Value<int>? hour,
    Value<int>? minute,
    Value<int>? weekdays,
    Value<double?>? doseAmount,
    Value<int>? rowid,
  }) {
    return MedicationSchedulesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      slot: slot ?? this.slot,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
      doseAmount: doseAmount ?? this.doseAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (doseAmount.present) {
      map['dose_amount'] = Variable<double>(doseAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('slot: $slot, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('weekdays: $weekdays, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationIntakesTable extends MedicationIntakes
    with TableInfo<$MedicationIntakesTable, MedicationIntake> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationIntakesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id)',
    ),
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  late final GeneratedColumnWithTypeConverter<IntakeStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<IntakeStatus>($MedicationIntakesTable.$converterstatus);
  static const VerificationMeta _doseAmountMeta = const VerificationMeta(
    'doseAmount',
  );
  @override
  late final GeneratedColumn<double> doseAmount = GeneratedColumn<double>(
    'dose_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
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
    medicationId,
    scheduledFor,
    recordedAt,
    status,
    doseAmount,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_intakes';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationIntake> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('dose_amount')) {
      context.handle(
        _doseAmountMeta,
        doseAmount.isAcceptableOrUnknown(data['dose_amount']!, _doseAmountMeta),
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
  MedicationIntake map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationIntake(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_id'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      status: $MedicationIntakesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      doseAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose_amount'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MedicationIntakesTable createAlias(String alias) {
    return $MedicationIntakesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<IntakeStatus, int, int> $converterstatus =
      const EnumIndexConverter<IntakeStatus>(IntakeStatus.values);
}

class MedicationIntake extends DataClass
    implements Insertable<MedicationIntake> {
  final String id;
  final String medicationId;

  /// Geplanter Einnahmezeitpunkt (null = außerplanmäßig).
  final DateTime? scheduledFor;
  final DateTime recordedAt;
  final IntakeStatus status;
  final double? doseAmount;
  final String? note;
  const MedicationIntake({
    required this.id,
    required this.medicationId,
    this.scheduledFor,
    required this.recordedAt,
    required this.status,
    this.doseAmount,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    if (!nullToAbsent || scheduledFor != null) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    {
      map['status'] = Variable<int>(
        $MedicationIntakesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || doseAmount != null) {
      map['dose_amount'] = Variable<double>(doseAmount);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MedicationIntakesCompanion toCompanion(bool nullToAbsent) {
    return MedicationIntakesCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduledFor: scheduledFor == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledFor),
      recordedAt: Value(recordedAt),
      status: Value(status),
      doseAmount: doseAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(doseAmount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MedicationIntake.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationIntake(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      scheduledFor: serializer.fromJson<DateTime?>(json['scheduledFor']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      status: $MedicationIntakesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      doseAmount: serializer.fromJson<double?>(json['doseAmount']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'scheduledFor': serializer.toJson<DateTime?>(scheduledFor),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'status': serializer.toJson<int>(
        $MedicationIntakesTable.$converterstatus.toJson(status),
      ),
      'doseAmount': serializer.toJson<double?>(doseAmount),
      'note': serializer.toJson<String?>(note),
    };
  }

  MedicationIntake copyWith({
    String? id,
    String? medicationId,
    Value<DateTime?> scheduledFor = const Value.absent(),
    DateTime? recordedAt,
    IntakeStatus? status,
    Value<double?> doseAmount = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => MedicationIntake(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    scheduledFor: scheduledFor.present ? scheduledFor.value : this.scheduledFor,
    recordedAt: recordedAt ?? this.recordedAt,
    status: status ?? this.status,
    doseAmount: doseAmount.present ? doseAmount.value : this.doseAmount,
    note: note.present ? note.value : this.note,
  );
  MedicationIntake copyWithCompanion(MedicationIntakesCompanion data) {
    return MedicationIntake(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      status: data.status.present ? data.status.value : this.status,
      doseAmount: data.doseAmount.present
          ? data.doseAmount.value
          : this.doseAmount,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationIntake(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('status: $status, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    scheduledFor,
    recordedAt,
    status,
    doseAmount,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationIntake &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduledFor == this.scheduledFor &&
          other.recordedAt == this.recordedAt &&
          other.status == this.status &&
          other.doseAmount == this.doseAmount &&
          other.note == this.note);
}

class MedicationIntakesCompanion extends UpdateCompanion<MedicationIntake> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<DateTime?> scheduledFor;
  final Value<DateTime> recordedAt;
  final Value<IntakeStatus> status;
  final Value<double?> doseAmount;
  final Value<String?> note;
  final Value<int> rowid;
  const MedicationIntakesCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.doseAmount = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationIntakesCompanion.insert({
    required String id,
    required String medicationId,
    this.scheduledFor = const Value.absent(),
    required DateTime recordedAt,
    required IntakeStatus status,
    this.doseAmount = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medicationId = Value(medicationId),
       recordedAt = Value(recordedAt),
       status = Value(status);
  static Insertable<MedicationIntake> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<DateTime>? scheduledFor,
    Expression<DateTime>? recordedAt,
    Expression<int>? status,
    Expression<double>? doseAmount,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (status != null) 'status': status,
      if (doseAmount != null) 'dose_amount': doseAmount,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationIntakesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicationId,
    Value<DateTime?>? scheduledFor,
    Value<DateTime>? recordedAt,
    Value<IntakeStatus>? status,
    Value<double?>? doseAmount,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MedicationIntakesCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      recordedAt: recordedAt ?? this.recordedAt,
      status: status ?? this.status,
      doseAmount: doseAmount ?? this.doseAmount,
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
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $MedicationIntakesTable.$converterstatus.toSql(status.value),
      );
    }
    if (doseAmount.present) {
      map['dose_amount'] = Variable<double>(doseAmount.value);
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
    return (StringBuffer('MedicationIntakesCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('status: $status, ')
          ..write('doseAmount: $doseAmount, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaccinationsTable extends Vaccinations
    with TableInfo<$VaccinationsTable, Vaccination> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vaccineMeta = const VerificationMeta(
    'vaccine',
  );
  @override
  late final GeneratedColumn<String> vaccine = GeneratedColumn<String>(
    'vaccine',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productMeta = const VerificationMeta(
    'product',
  );
  @override
  late final GeneratedColumn<String> product = GeneratedColumn<String>(
    'product',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _administeredAtMeta = const VerificationMeta(
    'administeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> administeredAt =
      GeneratedColumn<DateTime>(
        'administered_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _doseNumberMeta = const VerificationMeta(
    'doseNumber',
  );
  @override
  late final GeneratedColumn<int> doseNumber = GeneratedColumn<int>(
    'dose_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batchMeta = const VerificationMeta('batch');
  @override
  late final GeneratedColumn<String> batch = GeneratedColumn<String>(
    'batch',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doctorIdMeta = const VerificationMeta(
    'doctorId',
  );
  @override
  late final GeneratedColumn<String> doctorId = GeneratedColumn<String>(
    'doctor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES doctors (id)',
    ),
  );
  static const VerificationMeta _nextDueAtMeta = const VerificationMeta(
    'nextDueAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueAt = GeneratedColumn<DateTime>(
    'next_due_at',
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
    archivedAt,
    id,
    vaccine,
    product,
    administeredAt,
    doseNumber,
    batch,
    doctorId,
    nextDueAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccinations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vaccination> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vaccine')) {
      context.handle(
        _vaccineMeta,
        vaccine.isAcceptableOrUnknown(data['vaccine']!, _vaccineMeta),
      );
    } else if (isInserting) {
      context.missing(_vaccineMeta);
    }
    if (data.containsKey('product')) {
      context.handle(
        _productMeta,
        product.isAcceptableOrUnknown(data['product']!, _productMeta),
      );
    }
    if (data.containsKey('administered_at')) {
      context.handle(
        _administeredAtMeta,
        administeredAt.isAcceptableOrUnknown(
          data['administered_at']!,
          _administeredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_administeredAtMeta);
    }
    if (data.containsKey('dose_number')) {
      context.handle(
        _doseNumberMeta,
        doseNumber.isAcceptableOrUnknown(data['dose_number']!, _doseNumberMeta),
      );
    }
    if (data.containsKey('batch')) {
      context.handle(
        _batchMeta,
        batch.isAcceptableOrUnknown(data['batch']!, _batchMeta),
      );
    }
    if (data.containsKey('doctor_id')) {
      context.handle(
        _doctorIdMeta,
        doctorId.isAcceptableOrUnknown(data['doctor_id']!, _doctorIdMeta),
      );
    }
    if (data.containsKey('next_due_at')) {
      context.handle(
        _nextDueAtMeta,
        nextDueAt.isAcceptableOrUnknown(data['next_due_at']!, _nextDueAtMeta),
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
  Vaccination map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vaccination(
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vaccine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vaccine'],
      )!,
      product: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product'],
      ),
      administeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}administered_at'],
      )!,
      doseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dose_number'],
      ),
      batch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch'],
      ),
      doctorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doctor_id'],
      ),
      nextDueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_at'],
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
  $VaccinationsTable createAlias(String alias) {
    return $VaccinationsTable(attachedDatabase, alias);
  }
}

class Vaccination extends DataClass implements Insertable<Vaccination> {
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  final DateTime? archivedAt;
  final String id;

  /// Impfstoff bzw. Impfung, z. B. „Tetanus/Diphtherie/Pertussis“.
  final String vaccine;
  final String? product;
  final DateTime administeredAt;
  final int? doseNumber;
  final String? batch;
  final String? doctorId;
  final DateTime? nextDueAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Vaccination({
    this.archivedAt,
    required this.id,
    required this.vaccine,
    this.product,
    required this.administeredAt,
    this.doseNumber,
    this.batch,
    this.doctorId,
    this.nextDueAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['id'] = Variable<String>(id);
    map['vaccine'] = Variable<String>(vaccine);
    if (!nullToAbsent || product != null) {
      map['product'] = Variable<String>(product);
    }
    map['administered_at'] = Variable<DateTime>(administeredAt);
    if (!nullToAbsent || doseNumber != null) {
      map['dose_number'] = Variable<int>(doseNumber);
    }
    if (!nullToAbsent || batch != null) {
      map['batch'] = Variable<String>(batch);
    }
    if (!nullToAbsent || doctorId != null) {
      map['doctor_id'] = Variable<String>(doctorId);
    }
    if (!nullToAbsent || nextDueAt != null) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaccinationsCompanion toCompanion(bool nullToAbsent) {
    return VaccinationsCompanion(
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      id: Value(id),
      vaccine: Value(vaccine),
      product: product == null && nullToAbsent
          ? const Value.absent()
          : Value(product),
      administeredAt: Value(administeredAt),
      doseNumber: doseNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(doseNumber),
      batch: batch == null && nullToAbsent
          ? const Value.absent()
          : Value(batch),
      doctorId: doctorId == null && nullToAbsent
          ? const Value.absent()
          : Value(doctorId),
      nextDueAt: nextDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Vaccination.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vaccination(
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      id: serializer.fromJson<String>(json['id']),
      vaccine: serializer.fromJson<String>(json['vaccine']),
      product: serializer.fromJson<String?>(json['product']),
      administeredAt: serializer.fromJson<DateTime>(json['administeredAt']),
      doseNumber: serializer.fromJson<int?>(json['doseNumber']),
      batch: serializer.fromJson<String?>(json['batch']),
      doctorId: serializer.fromJson<String?>(json['doctorId']),
      nextDueAt: serializer.fromJson<DateTime?>(json['nextDueAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'id': serializer.toJson<String>(id),
      'vaccine': serializer.toJson<String>(vaccine),
      'product': serializer.toJson<String?>(product),
      'administeredAt': serializer.toJson<DateTime>(administeredAt),
      'doseNumber': serializer.toJson<int?>(doseNumber),
      'batch': serializer.toJson<String?>(batch),
      'doctorId': serializer.toJson<String?>(doctorId),
      'nextDueAt': serializer.toJson<DateTime?>(nextDueAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Vaccination copyWith({
    Value<DateTime?> archivedAt = const Value.absent(),
    String? id,
    String? vaccine,
    Value<String?> product = const Value.absent(),
    DateTime? administeredAt,
    Value<int?> doseNumber = const Value.absent(),
    Value<String?> batch = const Value.absent(),
    Value<String?> doctorId = const Value.absent(),
    Value<DateTime?> nextDueAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Vaccination(
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    id: id ?? this.id,
    vaccine: vaccine ?? this.vaccine,
    product: product.present ? product.value : this.product,
    administeredAt: administeredAt ?? this.administeredAt,
    doseNumber: doseNumber.present ? doseNumber.value : this.doseNumber,
    batch: batch.present ? batch.value : this.batch,
    doctorId: doctorId.present ? doctorId.value : this.doctorId,
    nextDueAt: nextDueAt.present ? nextDueAt.value : this.nextDueAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Vaccination copyWithCompanion(VaccinationsCompanion data) {
    return Vaccination(
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      id: data.id.present ? data.id.value : this.id,
      vaccine: data.vaccine.present ? data.vaccine.value : this.vaccine,
      product: data.product.present ? data.product.value : this.product,
      administeredAt: data.administeredAt.present
          ? data.administeredAt.value
          : this.administeredAt,
      doseNumber: data.doseNumber.present
          ? data.doseNumber.value
          : this.doseNumber,
      batch: data.batch.present ? data.batch.value : this.batch,
      doctorId: data.doctorId.present ? data.doctorId.value : this.doctorId,
      nextDueAt: data.nextDueAt.present ? data.nextDueAt.value : this.nextDueAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vaccination(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('vaccine: $vaccine, ')
          ..write('product: $product, ')
          ..write('administeredAt: $administeredAt, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('batch: $batch, ')
          ..write('doctorId: $doctorId, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    archivedAt,
    id,
    vaccine,
    product,
    administeredAt,
    doseNumber,
    batch,
    doctorId,
    nextDueAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vaccination &&
          other.archivedAt == this.archivedAt &&
          other.id == this.id &&
          other.vaccine == this.vaccine &&
          other.product == this.product &&
          other.administeredAt == this.administeredAt &&
          other.doseNumber == this.doseNumber &&
          other.batch == this.batch &&
          other.doctorId == this.doctorId &&
          other.nextDueAt == this.nextDueAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaccinationsCompanion extends UpdateCompanion<Vaccination> {
  final Value<DateTime?> archivedAt;
  final Value<String> id;
  final Value<String> vaccine;
  final Value<String?> product;
  final Value<DateTime> administeredAt;
  final Value<int?> doseNumber;
  final Value<String?> batch;
  final Value<String?> doctorId;
  final Value<DateTime?> nextDueAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VaccinationsCompanion({
    this.archivedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.vaccine = const Value.absent(),
    this.product = const Value.absent(),
    this.administeredAt = const Value.absent(),
    this.doseNumber = const Value.absent(),
    this.batch = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccinationsCompanion.insert({
    this.archivedAt = const Value.absent(),
    required String id,
    required String vaccine,
    this.product = const Value.absent(),
    required DateTime administeredAt,
    this.doseNumber = const Value.absent(),
    this.batch = const Value.absent(),
    this.doctorId = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vaccine = Value(vaccine),
       administeredAt = Value(administeredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Vaccination> custom({
    Expression<DateTime>? archivedAt,
    Expression<String>? id,
    Expression<String>? vaccine,
    Expression<String>? product,
    Expression<DateTime>? administeredAt,
    Expression<int>? doseNumber,
    Expression<String>? batch,
    Expression<String>? doctorId,
    Expression<DateTime>? nextDueAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (archivedAt != null) 'archived_at': archivedAt,
      if (id != null) 'id': id,
      if (vaccine != null) 'vaccine': vaccine,
      if (product != null) 'product': product,
      if (administeredAt != null) 'administered_at': administeredAt,
      if (doseNumber != null) 'dose_number': doseNumber,
      if (batch != null) 'batch': batch,
      if (doctorId != null) 'doctor_id': doctorId,
      if (nextDueAt != null) 'next_due_at': nextDueAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccinationsCompanion copyWith({
    Value<DateTime?>? archivedAt,
    Value<String>? id,
    Value<String>? vaccine,
    Value<String?>? product,
    Value<DateTime>? administeredAt,
    Value<int?>? doseNumber,
    Value<String?>? batch,
    Value<String?>? doctorId,
    Value<DateTime?>? nextDueAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VaccinationsCompanion(
      archivedAt: archivedAt ?? this.archivedAt,
      id: id ?? this.id,
      vaccine: vaccine ?? this.vaccine,
      product: product ?? this.product,
      administeredAt: administeredAt ?? this.administeredAt,
      doseNumber: doseNumber ?? this.doseNumber,
      batch: batch ?? this.batch,
      doctorId: doctorId ?? this.doctorId,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vaccine.present) {
      map['vaccine'] = Variable<String>(vaccine.value);
    }
    if (product.present) {
      map['product'] = Variable<String>(product.value);
    }
    if (administeredAt.present) {
      map['administered_at'] = Variable<DateTime>(administeredAt.value);
    }
    if (doseNumber.present) {
      map['dose_number'] = Variable<int>(doseNumber.value);
    }
    if (batch.present) {
      map['batch'] = Variable<String>(batch.value);
    }
    if (doctorId.present) {
      map['doctor_id'] = Variable<String>(doctorId.value);
    }
    if (nextDueAt.present) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt.value);
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
    return (StringBuffer('VaccinationsCompanion(')
          ..write('archivedAt: $archivedAt, ')
          ..write('id: $id, ')
          ..write('vaccine: $vaccine, ')
          ..write('product: $product, ')
          ..write('administeredAt: $administeredAt, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('batch: $batch, ')
          ..write('doctorId: $doctorId, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SymptomMediaTable extends SymptomMedia
    with TableInfo<$SymptomMediaTable, SymptomMediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomMediaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _observationIdMeta = const VerificationMeta(
    'observationId',
  );
  @override
  late final GeneratedColumn<String> observationId = GeneratedColumn<String>(
    'observation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES symptom_observations (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MediaKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<MediaKind>($SymptomMediaTable.$converterkind);
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
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  List<GeneratedColumn> get $columns => [
    id,
    symptomId,
    observationId,
    kind,
    mimeType,
    localPath,
    durationMs,
    note,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomMediaItem> instance, {
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
    if (data.containsKey('observation_id')) {
      context.handle(
        _observationIdMeta,
        observationId.isAcceptableOrUnknown(
          data['observation_id']!,
          _observationIdMeta,
        ),
      );
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
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomMediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomMediaItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      symptomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptom_id'],
      )!,
      observationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation_id'],
      ),
      kind: $SymptomMediaTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $SymptomMediaTable createAlias(String alias) {
    return $SymptomMediaTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MediaKind, int, int> $converterkind =
      const EnumIndexConverter<MediaKind>(MediaKind.values);
}

class SymptomMediaItem extends DataClass
    implements Insertable<SymptomMediaItem> {
  final String id;
  final String symptomId;

  /// Optional: Beleg gehört zu diesem Check-in.
  final String? observationId;
  final MediaKind kind;
  final String mimeType;
  final String localPath;
  final int? durationMs;
  final String? note;
  final DateTime recordedAt;
  const SymptomMediaItem({
    required this.id,
    required this.symptomId,
    this.observationId,
    required this.kind,
    required this.mimeType,
    required this.localPath,
    this.durationMs,
    this.note,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['symptom_id'] = Variable<String>(symptomId);
    if (!nullToAbsent || observationId != null) {
      map['observation_id'] = Variable<String>(observationId);
    }
    {
      map['kind'] = Variable<int>(
        $SymptomMediaTable.$converterkind.toSql(kind),
      );
    }
    map['mime_type'] = Variable<String>(mimeType);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  SymptomMediaCompanion toCompanion(bool nullToAbsent) {
    return SymptomMediaCompanion(
      id: Value(id),
      symptomId: Value(symptomId),
      observationId: observationId == null && nullToAbsent
          ? const Value.absent()
          : Value(observationId),
      kind: Value(kind),
      mimeType: Value(mimeType),
      localPath: Value(localPath),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recordedAt: Value(recordedAt),
    );
  }

  factory SymptomMediaItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomMediaItem(
      id: serializer.fromJson<String>(json['id']),
      symptomId: serializer.fromJson<String>(json['symptomId']),
      observationId: serializer.fromJson<String?>(json['observationId']),
      kind: $SymptomMediaTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      localPath: serializer.fromJson<String>(json['localPath']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      note: serializer.fromJson<String?>(json['note']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'symptomId': serializer.toJson<String>(symptomId),
      'observationId': serializer.toJson<String?>(observationId),
      'kind': serializer.toJson<int>(
        $SymptomMediaTable.$converterkind.toJson(kind),
      ),
      'mimeType': serializer.toJson<String>(mimeType),
      'localPath': serializer.toJson<String>(localPath),
      'durationMs': serializer.toJson<int?>(durationMs),
      'note': serializer.toJson<String?>(note),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  SymptomMediaItem copyWith({
    String? id,
    String? symptomId,
    Value<String?> observationId = const Value.absent(),
    MediaKind? kind,
    String? mimeType,
    String? localPath,
    Value<int?> durationMs = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? recordedAt,
  }) => SymptomMediaItem(
    id: id ?? this.id,
    symptomId: symptomId ?? this.symptomId,
    observationId: observationId.present
        ? observationId.value
        : this.observationId,
    kind: kind ?? this.kind,
    mimeType: mimeType ?? this.mimeType,
    localPath: localPath ?? this.localPath,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    note: note.present ? note.value : this.note,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  SymptomMediaItem copyWithCompanion(SymptomMediaCompanion data) {
    return SymptomMediaItem(
      id: data.id.present ? data.id.value : this.id,
      symptomId: data.symptomId.present ? data.symptomId.value : this.symptomId,
      observationId: data.observationId.present
          ? data.observationId.value
          : this.observationId,
      kind: data.kind.present ? data.kind.value : this.kind,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      note: data.note.present ? data.note.value : this.note,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomMediaItem(')
          ..write('id: $id, ')
          ..write('symptomId: $symptomId, ')
          ..write('observationId: $observationId, ')
          ..write('kind: $kind, ')
          ..write('mimeType: $mimeType, ')
          ..write('localPath: $localPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    symptomId,
    observationId,
    kind,
    mimeType,
    localPath,
    durationMs,
    note,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomMediaItem &&
          other.id == this.id &&
          other.symptomId == this.symptomId &&
          other.observationId == this.observationId &&
          other.kind == this.kind &&
          other.mimeType == this.mimeType &&
          other.localPath == this.localPath &&
          other.durationMs == this.durationMs &&
          other.note == this.note &&
          other.recordedAt == this.recordedAt);
}

class SymptomMediaCompanion extends UpdateCompanion<SymptomMediaItem> {
  final Value<String> id;
  final Value<String> symptomId;
  final Value<String?> observationId;
  final Value<MediaKind> kind;
  final Value<String> mimeType;
  final Value<String> localPath;
  final Value<int?> durationMs;
  final Value<String?> note;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const SymptomMediaCompanion({
    this.id = const Value.absent(),
    this.symptomId = const Value.absent(),
    this.observationId = const Value.absent(),
    this.kind = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.localPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.note = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymptomMediaCompanion.insert({
    required String id,
    required String symptomId,
    this.observationId = const Value.absent(),
    required MediaKind kind,
    required String mimeType,
    required String localPath,
    this.durationMs = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       symptomId = Value(symptomId),
       kind = Value(kind),
       mimeType = Value(mimeType),
       localPath = Value(localPath),
       recordedAt = Value(recordedAt);
  static Insertable<SymptomMediaItem> custom({
    Expression<String>? id,
    Expression<String>? symptomId,
    Expression<String>? observationId,
    Expression<int>? kind,
    Expression<String>? mimeType,
    Expression<String>? localPath,
    Expression<int>? durationMs,
    Expression<String>? note,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symptomId != null) 'symptom_id': symptomId,
      if (observationId != null) 'observation_id': observationId,
      if (kind != null) 'kind': kind,
      if (mimeType != null) 'mime_type': mimeType,
      if (localPath != null) 'local_path': localPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (note != null) 'note': note,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymptomMediaCompanion copyWith({
    Value<String>? id,
    Value<String>? symptomId,
    Value<String?>? observationId,
    Value<MediaKind>? kind,
    Value<String>? mimeType,
    Value<String>? localPath,
    Value<int?>? durationMs,
    Value<String?>? note,
    Value<DateTime>? recordedAt,
    Value<int>? rowid,
  }) {
    return SymptomMediaCompanion(
      id: id ?? this.id,
      symptomId: symptomId ?? this.symptomId,
      observationId: observationId ?? this.observationId,
      kind: kind ?? this.kind,
      mimeType: mimeType ?? this.mimeType,
      localPath: localPath ?? this.localPath,
      durationMs: durationMs ?? this.durationMs,
      note: note ?? this.note,
      recordedAt: recordedAt ?? this.recordedAt,
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
    if (observationId.present) {
      map['observation_id'] = Variable<String>(observationId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $SymptomMediaTable.$converterkind.toSql(kind.value),
      );
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomMediaCompanion(')
          ..write('id: $id, ')
          ..write('symptomId: $symptomId, ')
          ..write('observationId: $observationId, ')
          ..write('kind: $kind, ')
          ..write('mimeType: $mimeType, ')
          ..write('localPath: $localPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('note: $note, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CycleDaysTable extends CycleDays
    with TableInfo<$CycleDaysTable, CycleDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CycleFlow?, int> flow =
      GeneratedColumn<int>(
        'flow',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<CycleFlow?>($CycleDaysTable.$converterflown);
  static const VerificationMeta _pbacJsonMeta = const VerificationMeta(
    'pbacJson',
  );
  @override
  late final GeneratedColumn<String> pbacJson = GeneratedColumn<String>(
    'pbac_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painMeta = const VerificationMeta('pain');
  @override
  late final GeneratedColumn<int> pain = GeneratedColumn<int>(
    'pain',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painLocationsMeta = const VerificationMeta(
    'painLocations',
  );
  @override
  late final GeneratedColumn<String> painLocations = GeneratedColumn<String>(
    'pain_locations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dischargeMeta = const VerificationMeta(
    'discharge',
  );
  @override
  late final GeneratedColumn<String> discharge = GeneratedColumn<String>(
    'discharge',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painkillerMeta = const VerificationMeta(
    'painkiller',
  );
  @override
  late final GeneratedColumn<bool> painkiller = GeneratedColumn<bool>(
    'painkiller',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("painkiller" IN (0, 1))',
    ),
  );
  static const VerificationMeta _painkillerNameMeta = const VerificationMeta(
    'painkillerName',
  );
  @override
  late final GeneratedColumn<String> painkillerName = GeneratedColumn<String>(
    'painkiller_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painkillerHelpedMeta = const VerificationMeta(
    'painkillerHelped',
  );
  @override
  late final GeneratedColumn<bool> painkillerHelped = GeneratedColumn<bool>(
    'painkiller_helped',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("painkiller_helped" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hotFlashesMeta = const VerificationMeta(
    'hotFlashes',
  );
  @override
  late final GeneratedColumn<int> hotFlashes = GeneratedColumn<int>(
    'hot_flashes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hotFlashIntensityMeta = const VerificationMeta(
    'hotFlashIntensity',
  );
  @override
  late final GeneratedColumn<int> hotFlashIntensity = GeneratedColumn<int>(
    'hot_flash_intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nightSweatsMeta = const VerificationMeta(
    'nightSweats',
  );
  @override
  late final GeneratedColumn<int> nightSweats = GeneratedColumn<int>(
    'night_sweats',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FetalMovement?, int>
  fetalMovement = GeneratedColumn<int>(
    'fetal_movement',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<FetalMovement?>($CycleDaysTable.$converterfetalMovementn);
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpSystolicMeta = const VerificationMeta(
    'bpSystolic',
  );
  @override
  late final GeneratedColumn<int> bpSystolic = GeneratedColumn<int>(
    'bp_systolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bpDiastolicMeta = const VerificationMeta(
    'bpDiastolic',
  );
  @override
  late final GeneratedColumn<int> bpDiastolic = GeneratedColumn<int>(
    'bp_diastolic',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    day,
    flow,
    pbacJson,
    pain,
    painLocations,
    symptoms,
    discharge,
    painkiller,
    painkillerName,
    painkillerHelped,
    hotFlashes,
    hotFlashIntensity,
    nightSweats,
    fetalMovement,
    weightKg,
    bpSystolic,
    bpDiastolic,
    note,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<CycleDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('pbac_json')) {
      context.handle(
        _pbacJsonMeta,
        pbacJson.isAcceptableOrUnknown(data['pbac_json']!, _pbacJsonMeta),
      );
    }
    if (data.containsKey('pain')) {
      context.handle(
        _painMeta,
        pain.isAcceptableOrUnknown(data['pain']!, _painMeta),
      );
    }
    if (data.containsKey('pain_locations')) {
      context.handle(
        _painLocationsMeta,
        painLocations.isAcceptableOrUnknown(
          data['pain_locations']!,
          _painLocationsMeta,
        ),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('discharge')) {
      context.handle(
        _dischargeMeta,
        discharge.isAcceptableOrUnknown(data['discharge']!, _dischargeMeta),
      );
    }
    if (data.containsKey('painkiller')) {
      context.handle(
        _painkillerMeta,
        painkiller.isAcceptableOrUnknown(data['painkiller']!, _painkillerMeta),
      );
    }
    if (data.containsKey('painkiller_name')) {
      context.handle(
        _painkillerNameMeta,
        painkillerName.isAcceptableOrUnknown(
          data['painkiller_name']!,
          _painkillerNameMeta,
        ),
      );
    }
    if (data.containsKey('painkiller_helped')) {
      context.handle(
        _painkillerHelpedMeta,
        painkillerHelped.isAcceptableOrUnknown(
          data['painkiller_helped']!,
          _painkillerHelpedMeta,
        ),
      );
    }
    if (data.containsKey('hot_flashes')) {
      context.handle(
        _hotFlashesMeta,
        hotFlashes.isAcceptableOrUnknown(data['hot_flashes']!, _hotFlashesMeta),
      );
    }
    if (data.containsKey('hot_flash_intensity')) {
      context.handle(
        _hotFlashIntensityMeta,
        hotFlashIntensity.isAcceptableOrUnknown(
          data['hot_flash_intensity']!,
          _hotFlashIntensityMeta,
        ),
      );
    }
    if (data.containsKey('night_sweats')) {
      context.handle(
        _nightSweatsMeta,
        nightSweats.isAcceptableOrUnknown(
          data['night_sweats']!,
          _nightSweatsMeta,
        ),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('bp_systolic')) {
      context.handle(
        _bpSystolicMeta,
        bpSystolic.isAcceptableOrUnknown(data['bp_systolic']!, _bpSystolicMeta),
      );
    }
    if (data.containsKey('bp_diastolic')) {
      context.handle(
        _bpDiastolicMeta,
        bpDiastolic.isAcceptableOrUnknown(
          data['bp_diastolic']!,
          _bpDiastolicMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  CycleDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleDay(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      flow: $CycleDaysTable.$converterflown.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}flow'],
        ),
      ),
      pbacJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pbac_json'],
      ),
      pain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pain'],
      ),
      painLocations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pain_locations'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      discharge: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discharge'],
      ),
      painkiller: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}painkiller'],
      ),
      painkillerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}painkiller_name'],
      ),
      painkillerHelped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}painkiller_helped'],
      ),
      hotFlashes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hot_flashes'],
      ),
      hotFlashIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hot_flash_intensity'],
      ),
      nightSweats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_sweats'],
      ),
      fetalMovement: $CycleDaysTable.$converterfetalMovementn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}fetal_movement'],
        ),
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      bpSystolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bp_systolic'],
      ),
      bpDiastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bp_diastolic'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CycleDaysTable createAlias(String alias) {
    return $CycleDaysTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CycleFlow, int, int> $converterflow =
      const EnumIndexConverter<CycleFlow>(CycleFlow.values);
  static JsonTypeConverter2<CycleFlow?, int?, int?> $converterflown =
      JsonTypeConverter2.asNullable($converterflow);
  static JsonTypeConverter2<FetalMovement, int, int> $converterfetalMovement =
      const EnumIndexConverter<FetalMovement>(FetalMovement.values);
  static JsonTypeConverter2<FetalMovement?, int?, int?>
  $converterfetalMovementn = JsonTypeConverter2.asNullable(
    $converterfetalMovement,
  );
}

class CycleDay extends DataClass implements Insertable<CycleDay> {
  final String day;
  final CycleFlow? flow;

  /// PBAC-Zählungen als JSON (siehe `PbacCounts`).
  final String? pbacJson;

  /// Schmerz 0–10 (gleiche Anker wie bei Symptomen).
  final int? pain;
  final String? painLocations;
  final String? symptoms;
  final String? discharge;
  final bool? painkiller;
  final String? painkillerName;

  /// Hat das Schmerzmittel geholfen? `null` = keine Angabe.
  final bool? painkillerHelped;
  final int? hotFlashes;

  /// Stärke der Hitzewallungen 1–3 (leicht/mittel/stark).
  final int? hotFlashIntensity;

  /// Nachtschweiß 0–3.
  final int? nightSweats;
  final FetalMovement? fetalMovement;
  final double? weightKg;
  final int? bpSystolic;
  final int? bpDiastolic;
  final String? note;
  final DateTime updatedAt;
  const CycleDay({
    required this.day,
    this.flow,
    this.pbacJson,
    this.pain,
    this.painLocations,
    this.symptoms,
    this.discharge,
    this.painkiller,
    this.painkillerName,
    this.painkillerHelped,
    this.hotFlashes,
    this.hotFlashIntensity,
    this.nightSweats,
    this.fetalMovement,
    this.weightKg,
    this.bpSystolic,
    this.bpDiastolic,
    this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    if (!nullToAbsent || flow != null) {
      map['flow'] = Variable<int>($CycleDaysTable.$converterflown.toSql(flow));
    }
    if (!nullToAbsent || pbacJson != null) {
      map['pbac_json'] = Variable<String>(pbacJson);
    }
    if (!nullToAbsent || pain != null) {
      map['pain'] = Variable<int>(pain);
    }
    if (!nullToAbsent || painLocations != null) {
      map['pain_locations'] = Variable<String>(painLocations);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || discharge != null) {
      map['discharge'] = Variable<String>(discharge);
    }
    if (!nullToAbsent || painkiller != null) {
      map['painkiller'] = Variable<bool>(painkiller);
    }
    if (!nullToAbsent || painkillerName != null) {
      map['painkiller_name'] = Variable<String>(painkillerName);
    }
    if (!nullToAbsent || painkillerHelped != null) {
      map['painkiller_helped'] = Variable<bool>(painkillerHelped);
    }
    if (!nullToAbsent || hotFlashes != null) {
      map['hot_flashes'] = Variable<int>(hotFlashes);
    }
    if (!nullToAbsent || hotFlashIntensity != null) {
      map['hot_flash_intensity'] = Variable<int>(hotFlashIntensity);
    }
    if (!nullToAbsent || nightSweats != null) {
      map['night_sweats'] = Variable<int>(nightSweats);
    }
    if (!nullToAbsent || fetalMovement != null) {
      map['fetal_movement'] = Variable<int>(
        $CycleDaysTable.$converterfetalMovementn.toSql(fetalMovement),
      );
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || bpSystolic != null) {
      map['bp_systolic'] = Variable<int>(bpSystolic);
    }
    if (!nullToAbsent || bpDiastolic != null) {
      map['bp_diastolic'] = Variable<int>(bpDiastolic);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CycleDaysCompanion toCompanion(bool nullToAbsent) {
    return CycleDaysCompanion(
      day: Value(day),
      flow: flow == null && nullToAbsent ? const Value.absent() : Value(flow),
      pbacJson: pbacJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pbacJson),
      pain: pain == null && nullToAbsent ? const Value.absent() : Value(pain),
      painLocations: painLocations == null && nullToAbsent
          ? const Value.absent()
          : Value(painLocations),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      discharge: discharge == null && nullToAbsent
          ? const Value.absent()
          : Value(discharge),
      painkiller: painkiller == null && nullToAbsent
          ? const Value.absent()
          : Value(painkiller),
      painkillerName: painkillerName == null && nullToAbsent
          ? const Value.absent()
          : Value(painkillerName),
      painkillerHelped: painkillerHelped == null && nullToAbsent
          ? const Value.absent()
          : Value(painkillerHelped),
      hotFlashes: hotFlashes == null && nullToAbsent
          ? const Value.absent()
          : Value(hotFlashes),
      hotFlashIntensity: hotFlashIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(hotFlashIntensity),
      nightSweats: nightSweats == null && nullToAbsent
          ? const Value.absent()
          : Value(nightSweats),
      fetalMovement: fetalMovement == null && nullToAbsent
          ? const Value.absent()
          : Value(fetalMovement),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      bpSystolic: bpSystolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpSystolic),
      bpDiastolic: bpDiastolic == null && nullToAbsent
          ? const Value.absent()
          : Value(bpDiastolic),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory CycleDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleDay(
      day: serializer.fromJson<String>(json['day']),
      flow: $CycleDaysTable.$converterflown.fromJson(
        serializer.fromJson<int?>(json['flow']),
      ),
      pbacJson: serializer.fromJson<String?>(json['pbacJson']),
      pain: serializer.fromJson<int?>(json['pain']),
      painLocations: serializer.fromJson<String?>(json['painLocations']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      discharge: serializer.fromJson<String?>(json['discharge']),
      painkiller: serializer.fromJson<bool?>(json['painkiller']),
      painkillerName: serializer.fromJson<String?>(json['painkillerName']),
      painkillerHelped: serializer.fromJson<bool?>(json['painkillerHelped']),
      hotFlashes: serializer.fromJson<int?>(json['hotFlashes']),
      hotFlashIntensity: serializer.fromJson<int?>(json['hotFlashIntensity']),
      nightSweats: serializer.fromJson<int?>(json['nightSweats']),
      fetalMovement: $CycleDaysTable.$converterfetalMovementn.fromJson(
        serializer.fromJson<int?>(json['fetalMovement']),
      ),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      bpSystolic: serializer.fromJson<int?>(json['bpSystolic']),
      bpDiastolic: serializer.fromJson<int?>(json['bpDiastolic']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'flow': serializer.toJson<int?>(
        $CycleDaysTable.$converterflown.toJson(flow),
      ),
      'pbacJson': serializer.toJson<String?>(pbacJson),
      'pain': serializer.toJson<int?>(pain),
      'painLocations': serializer.toJson<String?>(painLocations),
      'symptoms': serializer.toJson<String?>(symptoms),
      'discharge': serializer.toJson<String?>(discharge),
      'painkiller': serializer.toJson<bool?>(painkiller),
      'painkillerName': serializer.toJson<String?>(painkillerName),
      'painkillerHelped': serializer.toJson<bool?>(painkillerHelped),
      'hotFlashes': serializer.toJson<int?>(hotFlashes),
      'hotFlashIntensity': serializer.toJson<int?>(hotFlashIntensity),
      'nightSweats': serializer.toJson<int?>(nightSweats),
      'fetalMovement': serializer.toJson<int?>(
        $CycleDaysTable.$converterfetalMovementn.toJson(fetalMovement),
      ),
      'weightKg': serializer.toJson<double?>(weightKg),
      'bpSystolic': serializer.toJson<int?>(bpSystolic),
      'bpDiastolic': serializer.toJson<int?>(bpDiastolic),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CycleDay copyWith({
    String? day,
    Value<CycleFlow?> flow = const Value.absent(),
    Value<String?> pbacJson = const Value.absent(),
    Value<int?> pain = const Value.absent(),
    Value<String?> painLocations = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    Value<String?> discharge = const Value.absent(),
    Value<bool?> painkiller = const Value.absent(),
    Value<String?> painkillerName = const Value.absent(),
    Value<bool?> painkillerHelped = const Value.absent(),
    Value<int?> hotFlashes = const Value.absent(),
    Value<int?> hotFlashIntensity = const Value.absent(),
    Value<int?> nightSweats = const Value.absent(),
    Value<FetalMovement?> fetalMovement = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<int?> bpSystolic = const Value.absent(),
    Value<int?> bpDiastolic = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
  }) => CycleDay(
    day: day ?? this.day,
    flow: flow.present ? flow.value : this.flow,
    pbacJson: pbacJson.present ? pbacJson.value : this.pbacJson,
    pain: pain.present ? pain.value : this.pain,
    painLocations: painLocations.present
        ? painLocations.value
        : this.painLocations,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    discharge: discharge.present ? discharge.value : this.discharge,
    painkiller: painkiller.present ? painkiller.value : this.painkiller,
    painkillerName: painkillerName.present
        ? painkillerName.value
        : this.painkillerName,
    painkillerHelped: painkillerHelped.present
        ? painkillerHelped.value
        : this.painkillerHelped,
    hotFlashes: hotFlashes.present ? hotFlashes.value : this.hotFlashes,
    hotFlashIntensity: hotFlashIntensity.present
        ? hotFlashIntensity.value
        : this.hotFlashIntensity,
    nightSweats: nightSweats.present ? nightSweats.value : this.nightSweats,
    fetalMovement: fetalMovement.present
        ? fetalMovement.value
        : this.fetalMovement,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    bpSystolic: bpSystolic.present ? bpSystolic.value : this.bpSystolic,
    bpDiastolic: bpDiastolic.present ? bpDiastolic.value : this.bpDiastolic,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CycleDay copyWithCompanion(CycleDaysCompanion data) {
    return CycleDay(
      day: data.day.present ? data.day.value : this.day,
      flow: data.flow.present ? data.flow.value : this.flow,
      pbacJson: data.pbacJson.present ? data.pbacJson.value : this.pbacJson,
      pain: data.pain.present ? data.pain.value : this.pain,
      painLocations: data.painLocations.present
          ? data.painLocations.value
          : this.painLocations,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      discharge: data.discharge.present ? data.discharge.value : this.discharge,
      painkiller: data.painkiller.present
          ? data.painkiller.value
          : this.painkiller,
      painkillerName: data.painkillerName.present
          ? data.painkillerName.value
          : this.painkillerName,
      painkillerHelped: data.painkillerHelped.present
          ? data.painkillerHelped.value
          : this.painkillerHelped,
      hotFlashes: data.hotFlashes.present
          ? data.hotFlashes.value
          : this.hotFlashes,
      hotFlashIntensity: data.hotFlashIntensity.present
          ? data.hotFlashIntensity.value
          : this.hotFlashIntensity,
      nightSweats: data.nightSweats.present
          ? data.nightSweats.value
          : this.nightSweats,
      fetalMovement: data.fetalMovement.present
          ? data.fetalMovement.value
          : this.fetalMovement,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bpSystolic: data.bpSystolic.present
          ? data.bpSystolic.value
          : this.bpSystolic,
      bpDiastolic: data.bpDiastolic.present
          ? data.bpDiastolic.value
          : this.bpDiastolic,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleDay(')
          ..write('day: $day, ')
          ..write('flow: $flow, ')
          ..write('pbacJson: $pbacJson, ')
          ..write('pain: $pain, ')
          ..write('painLocations: $painLocations, ')
          ..write('symptoms: $symptoms, ')
          ..write('discharge: $discharge, ')
          ..write('painkiller: $painkiller, ')
          ..write('painkillerName: $painkillerName, ')
          ..write('painkillerHelped: $painkillerHelped, ')
          ..write('hotFlashes: $hotFlashes, ')
          ..write('hotFlashIntensity: $hotFlashIntensity, ')
          ..write('nightSweats: $nightSweats, ')
          ..write('fetalMovement: $fetalMovement, ')
          ..write('weightKg: $weightKg, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    day,
    flow,
    pbacJson,
    pain,
    painLocations,
    symptoms,
    discharge,
    painkiller,
    painkillerName,
    painkillerHelped,
    hotFlashes,
    hotFlashIntensity,
    nightSweats,
    fetalMovement,
    weightKg,
    bpSystolic,
    bpDiastolic,
    note,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleDay &&
          other.day == this.day &&
          other.flow == this.flow &&
          other.pbacJson == this.pbacJson &&
          other.pain == this.pain &&
          other.painLocations == this.painLocations &&
          other.symptoms == this.symptoms &&
          other.discharge == this.discharge &&
          other.painkiller == this.painkiller &&
          other.painkillerName == this.painkillerName &&
          other.painkillerHelped == this.painkillerHelped &&
          other.hotFlashes == this.hotFlashes &&
          other.hotFlashIntensity == this.hotFlashIntensity &&
          other.nightSweats == this.nightSweats &&
          other.fetalMovement == this.fetalMovement &&
          other.weightKg == this.weightKg &&
          other.bpSystolic == this.bpSystolic &&
          other.bpDiastolic == this.bpDiastolic &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class CycleDaysCompanion extends UpdateCompanion<CycleDay> {
  final Value<String> day;
  final Value<CycleFlow?> flow;
  final Value<String?> pbacJson;
  final Value<int?> pain;
  final Value<String?> painLocations;
  final Value<String?> symptoms;
  final Value<String?> discharge;
  final Value<bool?> painkiller;
  final Value<String?> painkillerName;
  final Value<bool?> painkillerHelped;
  final Value<int?> hotFlashes;
  final Value<int?> hotFlashIntensity;
  final Value<int?> nightSweats;
  final Value<FetalMovement?> fetalMovement;
  final Value<double?> weightKg;
  final Value<int?> bpSystolic;
  final Value<int?> bpDiastolic;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CycleDaysCompanion({
    this.day = const Value.absent(),
    this.flow = const Value.absent(),
    this.pbacJson = const Value.absent(),
    this.pain = const Value.absent(),
    this.painLocations = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.discharge = const Value.absent(),
    this.painkiller = const Value.absent(),
    this.painkillerName = const Value.absent(),
    this.painkillerHelped = const Value.absent(),
    this.hotFlashes = const Value.absent(),
    this.hotFlashIntensity = const Value.absent(),
    this.nightSweats = const Value.absent(),
    this.fetalMovement = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CycleDaysCompanion.insert({
    required String day,
    this.flow = const Value.absent(),
    this.pbacJson = const Value.absent(),
    this.pain = const Value.absent(),
    this.painLocations = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.discharge = const Value.absent(),
    this.painkiller = const Value.absent(),
    this.painkillerName = const Value.absent(),
    this.painkillerHelped = const Value.absent(),
    this.hotFlashes = const Value.absent(),
    this.hotFlashIntensity = const Value.absent(),
    this.nightSweats = const Value.absent(),
    this.fetalMovement = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bpSystolic = const Value.absent(),
    this.bpDiastolic = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       updatedAt = Value(updatedAt);
  static Insertable<CycleDay> custom({
    Expression<String>? day,
    Expression<int>? flow,
    Expression<String>? pbacJson,
    Expression<int>? pain,
    Expression<String>? painLocations,
    Expression<String>? symptoms,
    Expression<String>? discharge,
    Expression<bool>? painkiller,
    Expression<String>? painkillerName,
    Expression<bool>? painkillerHelped,
    Expression<int>? hotFlashes,
    Expression<int>? hotFlashIntensity,
    Expression<int>? nightSweats,
    Expression<int>? fetalMovement,
    Expression<double>? weightKg,
    Expression<int>? bpSystolic,
    Expression<int>? bpDiastolic,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (flow != null) 'flow': flow,
      if (pbacJson != null) 'pbac_json': pbacJson,
      if (pain != null) 'pain': pain,
      if (painLocations != null) 'pain_locations': painLocations,
      if (symptoms != null) 'symptoms': symptoms,
      if (discharge != null) 'discharge': discharge,
      if (painkiller != null) 'painkiller': painkiller,
      if (painkillerName != null) 'painkiller_name': painkillerName,
      if (painkillerHelped != null) 'painkiller_helped': painkillerHelped,
      if (hotFlashes != null) 'hot_flashes': hotFlashes,
      if (hotFlashIntensity != null) 'hot_flash_intensity': hotFlashIntensity,
      if (nightSweats != null) 'night_sweats': nightSweats,
      if (fetalMovement != null) 'fetal_movement': fetalMovement,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bpSystolic != null) 'bp_systolic': bpSystolic,
      if (bpDiastolic != null) 'bp_diastolic': bpDiastolic,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CycleDaysCompanion copyWith({
    Value<String>? day,
    Value<CycleFlow?>? flow,
    Value<String?>? pbacJson,
    Value<int?>? pain,
    Value<String?>? painLocations,
    Value<String?>? symptoms,
    Value<String?>? discharge,
    Value<bool?>? painkiller,
    Value<String?>? painkillerName,
    Value<bool?>? painkillerHelped,
    Value<int?>? hotFlashes,
    Value<int?>? hotFlashIntensity,
    Value<int?>? nightSweats,
    Value<FetalMovement?>? fetalMovement,
    Value<double?>? weightKg,
    Value<int?>? bpSystolic,
    Value<int?>? bpDiastolic,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CycleDaysCompanion(
      day: day ?? this.day,
      flow: flow ?? this.flow,
      pbacJson: pbacJson ?? this.pbacJson,
      pain: pain ?? this.pain,
      painLocations: painLocations ?? this.painLocations,
      symptoms: symptoms ?? this.symptoms,
      discharge: discharge ?? this.discharge,
      painkiller: painkiller ?? this.painkiller,
      painkillerName: painkillerName ?? this.painkillerName,
      painkillerHelped: painkillerHelped ?? this.painkillerHelped,
      hotFlashes: hotFlashes ?? this.hotFlashes,
      hotFlashIntensity: hotFlashIntensity ?? this.hotFlashIntensity,
      nightSweats: nightSweats ?? this.nightSweats,
      fetalMovement: fetalMovement ?? this.fetalMovement,
      weightKg: weightKg ?? this.weightKg,
      bpSystolic: bpSystolic ?? this.bpSystolic,
      bpDiastolic: bpDiastolic ?? this.bpDiastolic,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (flow.present) {
      map['flow'] = Variable<int>(
        $CycleDaysTable.$converterflown.toSql(flow.value),
      );
    }
    if (pbacJson.present) {
      map['pbac_json'] = Variable<String>(pbacJson.value);
    }
    if (pain.present) {
      map['pain'] = Variable<int>(pain.value);
    }
    if (painLocations.present) {
      map['pain_locations'] = Variable<String>(painLocations.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (discharge.present) {
      map['discharge'] = Variable<String>(discharge.value);
    }
    if (painkiller.present) {
      map['painkiller'] = Variable<bool>(painkiller.value);
    }
    if (painkillerName.present) {
      map['painkiller_name'] = Variable<String>(painkillerName.value);
    }
    if (painkillerHelped.present) {
      map['painkiller_helped'] = Variable<bool>(painkillerHelped.value);
    }
    if (hotFlashes.present) {
      map['hot_flashes'] = Variable<int>(hotFlashes.value);
    }
    if (hotFlashIntensity.present) {
      map['hot_flash_intensity'] = Variable<int>(hotFlashIntensity.value);
    }
    if (nightSweats.present) {
      map['night_sweats'] = Variable<int>(nightSweats.value);
    }
    if (fetalMovement.present) {
      map['fetal_movement'] = Variable<int>(
        $CycleDaysTable.$converterfetalMovementn.toSql(fetalMovement.value),
      );
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bpSystolic.present) {
      map['bp_systolic'] = Variable<int>(bpSystolic.value);
    }
    if (bpDiastolic.present) {
      map['bp_diastolic'] = Variable<int>(bpDiastolic.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
    return (StringBuffer('CycleDaysCompanion(')
          ..write('day: $day, ')
          ..write('flow: $flow, ')
          ..write('pbacJson: $pbacJson, ')
          ..write('pain: $pain, ')
          ..write('painLocations: $painLocations, ')
          ..write('symptoms: $symptoms, ')
          ..write('discharge: $discharge, ')
          ..write('painkiller: $painkiller, ')
          ..write('painkillerName: $painkillerName, ')
          ..write('painkillerHelped: $painkillerHelped, ')
          ..write('hotFlashes: $hotFlashes, ')
          ..write('hotFlashIntensity: $hotFlashIntensity, ')
          ..write('nightSweats: $nightSweats, ')
          ..write('fetalMovement: $fetalMovement, ')
          ..write('weightKg: $weightKg, ')
          ..write('bpSystolic: $bpSystolic, ')
          ..write('bpDiastolic: $bpDiastolic, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MrsAssessmentsTable extends MrsAssessments
    with TableInfo<$MrsAssessmentsTable, MrsAssessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MrsAssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _scoresMeta = const VerificationMeta('scores');
  @override
  late final GeneratedColumn<String> scores = GeneratedColumn<String>(
    'scores',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, recordedAt, scores, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mrs_assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<MrsAssessment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('scores')) {
      context.handle(
        _scoresMeta,
        scores.isAcceptableOrUnknown(data['scores']!, _scoresMeta),
      );
    } else if (isInserting) {
      context.missing(_scoresMeta);
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
  MrsAssessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MrsAssessment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      scores: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scores'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MrsAssessmentsTable createAlias(String alias) {
    return $MrsAssessmentsTable(attachedDatabase, alias);
  }
}

class MrsAssessment extends DataClass implements Insertable<MrsAssessment> {
  final String id;
  final DateTime recordedAt;
  final String scores;
  final String? note;
  const MrsAssessment({
    required this.id,
    required this.recordedAt,
    required this.scores,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['scores'] = Variable<String>(scores);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MrsAssessmentsCompanion toCompanion(bool nullToAbsent) {
    return MrsAssessmentsCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      scores: Value(scores),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MrsAssessment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MrsAssessment(
      id: serializer.fromJson<String>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      scores: serializer.fromJson<String>(json['scores']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'scores': serializer.toJson<String>(scores),
      'note': serializer.toJson<String?>(note),
    };
  }

  MrsAssessment copyWith({
    String? id,
    DateTime? recordedAt,
    String? scores,
    Value<String?> note = const Value.absent(),
  }) => MrsAssessment(
    id: id ?? this.id,
    recordedAt: recordedAt ?? this.recordedAt,
    scores: scores ?? this.scores,
    note: note.present ? note.value : this.note,
  );
  MrsAssessment copyWithCompanion(MrsAssessmentsCompanion data) {
    return MrsAssessment(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      scores: data.scores.present ? data.scores.value : this.scores,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MrsAssessment(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('scores: $scores, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, scores, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MrsAssessment &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.scores == this.scores &&
          other.note == this.note);
}

class MrsAssessmentsCompanion extends UpdateCompanion<MrsAssessment> {
  final Value<String> id;
  final Value<DateTime> recordedAt;
  final Value<String> scores;
  final Value<String?> note;
  final Value<int> rowid;
  const MrsAssessmentsCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.scores = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MrsAssessmentsCompanion.insert({
    required String id,
    required DateTime recordedAt,
    required String scores,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordedAt = Value(recordedAt),
       scores = Value(scores);
  static Insertable<MrsAssessment> custom({
    Expression<String>? id,
    Expression<DateTime>? recordedAt,
    Expression<String>? scores,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (scores != null) 'scores': scores,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MrsAssessmentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? recordedAt,
    Value<String>? scores,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MrsAssessmentsCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      scores: scores ?? this.scores,
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
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (scores.present) {
      map['scores'] = Variable<String>(scores.value);
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
    return (StringBuffer('MrsAssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('scores: $scores, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PregnanciesTable extends Pregnancies
    with TableInfo<$PregnanciesTable, Pregnancy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PregnanciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lmpMeta = const VerificationMeta('lmp');
  @override
  late final GeneratedColumn<String> lmp = GeneratedColumn<String>(
    'lmp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
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
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
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
    lmp,
    dueDate,
    createdAt,
    endedAt,
    outcome,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pregnancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pregnancy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lmp')) {
      context.handle(
        _lmpMeta,
        lmp.isAcceptableOrUnknown(data['lmp']!, _lmpMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
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
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
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
  Pregnancy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pregnancy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lmp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lmp'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PregnanciesTable createAlias(String alias) {
    return $PregnanciesTable(attachedDatabase, alias);
  }
}

class Pregnancy extends DataClass implements Insertable<Pregnancy> {
  final String id;

  /// Erster Tag der letzten Periode.
  final String? lmp;

  /// Errechneter Termin (z. B. aus dem Ultraschall), sonst aus [lmp].
  final String? dueDate;
  final DateTime createdAt;
  final DateTime? endedAt;

  /// `birth`, `loss` oder `other` — nur, wenn angegeben.
  final String? outcome;
  final String? note;
  const Pregnancy({
    required this.id,
    this.lmp,
    this.dueDate,
    required this.createdAt,
    this.endedAt,
    this.outcome,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || lmp != null) {
      map['lmp'] = Variable<String>(lmp);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PregnanciesCompanion toCompanion(bool nullToAbsent) {
    return PregnanciesCompanion(
      id: Value(id),
      lmp: lmp == null && nullToAbsent ? const Value.absent() : Value(lmp),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      createdAt: Value(createdAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Pregnancy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pregnancy(
      id: serializer.fromJson<String>(json['id']),
      lmp: serializer.fromJson<String?>(json['lmp']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lmp': serializer.toJson<String?>(lmp),
      'dueDate': serializer.toJson<String?>(dueDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'outcome': serializer.toJson<String?>(outcome),
      'note': serializer.toJson<String?>(note),
    };
  }

  Pregnancy copyWith({
    String? id,
    Value<String?> lmp = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> outcome = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Pregnancy(
    id: id ?? this.id,
    lmp: lmp.present ? lmp.value : this.lmp,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    createdAt: createdAt ?? this.createdAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    outcome: outcome.present ? outcome.value : this.outcome,
    note: note.present ? note.value : this.note,
  );
  Pregnancy copyWithCompanion(PregnanciesCompanion data) {
    return Pregnancy(
      id: data.id.present ? data.id.value : this.id,
      lmp: data.lmp.present ? data.lmp.value : this.lmp,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pregnancy(')
          ..write('id: $id, ')
          ..write('lmp: $lmp, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('outcome: $outcome, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lmp, dueDate, createdAt, endedAt, outcome, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregnancy &&
          other.id == this.id &&
          other.lmp == this.lmp &&
          other.dueDate == this.dueDate &&
          other.createdAt == this.createdAt &&
          other.endedAt == this.endedAt &&
          other.outcome == this.outcome &&
          other.note == this.note);
}

class PregnanciesCompanion extends UpdateCompanion<Pregnancy> {
  final Value<String> id;
  final Value<String?> lmp;
  final Value<String?> dueDate;
  final Value<DateTime> createdAt;
  final Value<DateTime?> endedAt;
  final Value<String?> outcome;
  final Value<String?> note;
  final Value<int> rowid;
  const PregnanciesCompanion({
    this.id = const Value.absent(),
    this.lmp = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.outcome = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PregnanciesCompanion.insert({
    required String id,
    this.lmp = const Value.absent(),
    this.dueDate = const Value.absent(),
    required DateTime createdAt,
    this.endedAt = const Value.absent(),
    this.outcome = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<Pregnancy> custom({
    Expression<String>? id,
    Expression<String>? lmp,
    Expression<String>? dueDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? endedAt,
    Expression<String>? outcome,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lmp != null) 'lmp': lmp,
      if (dueDate != null) 'due_date': dueDate,
      if (createdAt != null) 'created_at': createdAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (outcome != null) 'outcome': outcome,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PregnanciesCompanion copyWith({
    Value<String>? id,
    Value<String?>? lmp,
    Value<String?>? dueDate,
    Value<DateTime>? createdAt,
    Value<DateTime?>? endedAt,
    Value<String?>? outcome,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return PregnanciesCompanion(
      id: id ?? this.id,
      lmp: lmp ?? this.lmp,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      endedAt: endedAt ?? this.endedAt,
      outcome: outcome ?? this.outcome,
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
    if (lmp.present) {
      map['lmp'] = Variable<String>(lmp.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
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
    return (StringBuffer('PregnanciesCompanion(')
          ..write('id: $id, ')
          ..write('lmp: $lmp, ')
          ..write('dueDate: $dueDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('outcome: $outcome, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PsychAssessmentsTable extends PsychAssessments
    with TableInfo<$PsychAssessmentsTable, PsychAssessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PsychAssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _instrumentMeta = const VerificationMeta(
    'instrument',
  );
  @override
  late final GeneratedColumn<String> instrument = GeneratedColumn<String>(
    'instrument',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoresMeta = const VerificationMeta('scores');
  @override
  late final GeneratedColumn<String> scores = GeneratedColumn<String>(
    'scores',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    recordedAt,
    instrument,
    scores,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'psych_assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PsychAssessment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('instrument')) {
      context.handle(
        _instrumentMeta,
        instrument.isAcceptableOrUnknown(data['instrument']!, _instrumentMeta),
      );
    } else if (isInserting) {
      context.missing(_instrumentMeta);
    }
    if (data.containsKey('scores')) {
      context.handle(
        _scoresMeta,
        scores.isAcceptableOrUnknown(data['scores']!, _scoresMeta),
      );
    } else if (isInserting) {
      context.missing(_scoresMeta);
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
  PsychAssessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PsychAssessment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      instrument: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument'],
      )!,
      scores: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scores'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PsychAssessmentsTable createAlias(String alias) {
    return $PsychAssessmentsTable(attachedDatabase, alias);
  }
}

class PsychAssessment extends DataClass implements Insertable<PsychAssessment> {
  final String id;
  final DateTime recordedAt;
  final String instrument;
  final String scores;
  final String? note;
  const PsychAssessment({
    required this.id,
    required this.recordedAt,
    required this.instrument,
    required this.scores,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['instrument'] = Variable<String>(instrument);
    map['scores'] = Variable<String>(scores);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PsychAssessmentsCompanion toCompanion(bool nullToAbsent) {
    return PsychAssessmentsCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      instrument: Value(instrument),
      scores: Value(scores),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PsychAssessment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PsychAssessment(
      id: serializer.fromJson<String>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      instrument: serializer.fromJson<String>(json['instrument']),
      scores: serializer.fromJson<String>(json['scores']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'instrument': serializer.toJson<String>(instrument),
      'scores': serializer.toJson<String>(scores),
      'note': serializer.toJson<String?>(note),
    };
  }

  PsychAssessment copyWith({
    String? id,
    DateTime? recordedAt,
    String? instrument,
    String? scores,
    Value<String?> note = const Value.absent(),
  }) => PsychAssessment(
    id: id ?? this.id,
    recordedAt: recordedAt ?? this.recordedAt,
    instrument: instrument ?? this.instrument,
    scores: scores ?? this.scores,
    note: note.present ? note.value : this.note,
  );
  PsychAssessment copyWithCompanion(PsychAssessmentsCompanion data) {
    return PsychAssessment(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      instrument: data.instrument.present
          ? data.instrument.value
          : this.instrument,
      scores: data.scores.present ? data.scores.value : this.scores,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PsychAssessment(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('instrument: $instrument, ')
          ..write('scores: $scores, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, instrument, scores, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PsychAssessment &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.instrument == this.instrument &&
          other.scores == this.scores &&
          other.note == this.note);
}

class PsychAssessmentsCompanion extends UpdateCompanion<PsychAssessment> {
  final Value<String> id;
  final Value<DateTime> recordedAt;
  final Value<String> instrument;
  final Value<String> scores;
  final Value<String?> note;
  final Value<int> rowid;
  const PsychAssessmentsCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.instrument = const Value.absent(),
    this.scores = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PsychAssessmentsCompanion.insert({
    required String id,
    required DateTime recordedAt,
    required String instrument,
    required String scores,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recordedAt = Value(recordedAt),
       instrument = Value(instrument),
       scores = Value(scores);
  static Insertable<PsychAssessment> custom({
    Expression<String>? id,
    Expression<DateTime>? recordedAt,
    Expression<String>? instrument,
    Expression<String>? scores,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (instrument != null) 'instrument': instrument,
      if (scores != null) 'scores': scores,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PsychAssessmentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? recordedAt,
    Value<String>? instrument,
    Value<String>? scores,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return PsychAssessmentsCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      instrument: instrument ?? this.instrument,
      scores: scores ?? this.scores,
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
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (instrument.present) {
      map['instrument'] = Variable<String>(instrument.value);
    }
    if (scores.present) {
      map['scores'] = Variable<String>(scores.value);
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
    return (StringBuffer('PsychAssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('instrument: $instrument, ')
          ..write('scores: $scores, ')
          ..write('note: $note, ')
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
  late final $PharmaciesTable pharmacies = $PharmaciesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $CalendarLinksTable calendarLinks = $CalendarLinksTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ReminderSymptomsTable reminderSymptoms = $ReminderSymptomsTable(
    this,
  );
  late final $DoctorSymptomsTable doctorSymptoms = $DoctorSymptomsTable(this);
  late final $MedicationSchedulesTable medicationSchedules =
      $MedicationSchedulesTable(this);
  late final $MedicationIntakesTable medicationIntakes =
      $MedicationIntakesTable(this);
  late final $VaccinationsTable vaccinations = $VaccinationsTable(this);
  late final $SymptomMediaTable symptomMedia = $SymptomMediaTable(this);
  late final $CycleDaysTable cycleDays = $CycleDaysTable(this);
  late final $MrsAssessmentsTable mrsAssessments = $MrsAssessmentsTable(this);
  late final $PregnanciesTable pregnancies = $PregnanciesTable(this);
  late final $PsychAssessmentsTable psychAssessments = $PsychAssessmentsTable(
    this,
  );
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
    pharmacies,
    medications,
    notes,
    appSettings,
    calendarLinks,
    reminders,
    reminderSymptoms,
    doctorSymptoms,
    medicationSchedules,
    medicationIntakes,
    vaccinations,
    symptomMedia,
    cycleDays,
    mrsAssessments,
    pregnancies,
    psychAssessments,
  ];
}

typedef $$DoctorsTableCreateCompanionBuilder = DoctorsCompanion Function({
  Value<DateTime?> archivedAt,
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
  Value<DateTime?> archivedAt,
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

  static MultiTypedResultKey<$MedicationsTable, List<Medication>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: 'doctors__id__medications__prescriber_id',
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.prescriberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DoctorSymptomsTable, List<DoctorSymptom>>
  _doctorSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.doctorSymptoms,
    aliasName: 'doctors__id__doctor_symptoms__doctor_id',
  );

  $$DoctorSymptomsTableProcessedTableManager get doctorSymptomsRefs {
    final manager = $$DoctorSymptomsTableTableManager(
      $_db,
      $_db.doctorSymptoms,
    ).filter((f) => f.doctorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doctorSymptomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VaccinationsTable, List<Vaccination>>
  _vaccinationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vaccinations,
    aliasName: 'doctors__id__vaccinations__doctor_id',
  );

  $$VaccinationsTableProcessedTableManager get vaccinationsRefs {
    final manager = $$VaccinationsTableTableManager(
      $_db,
      $_db.vaccinations,
    ).filter((f) => f.doctorId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vaccinationsRefsTable($_db));
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.prescriberId,
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

  Expression<bool> doctorSymptomsRefs(
    Expression<bool> Function($$DoctorSymptomsTableFilterComposer f) f,
  ) {
    final $$DoctorSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorSymptoms,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.doctorSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vaccinationsRefs(
    Expression<bool> Function($$VaccinationsTableFilterComposer f) f,
  ) {
    final $$VaccinationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vaccinations,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaccinationsTableFilterComposer(
            $db: $db,
            $table: $db.vaccinations,
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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.prescriberId,
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

  Expression<T> doctorSymptomsRefs<T extends Object>(
    Expression<T> Function($$DoctorSymptomsTableAnnotationComposer a) f,
  ) {
    final $$DoctorSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorSymptoms,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.doctorSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vaccinationsRefs<T extends Object>(
    Expression<T> Function($$VaccinationsTableAnnotationComposer a) f,
  ) {
    final $$VaccinationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vaccinations,
      getReferencedColumn: (t) => t.doctorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VaccinationsTableAnnotationComposer(
            $db: $db,
            $table: $db.vaccinations,
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
          PrefetchHooks Function({
            bool appointmentsRefs,
            bool medicationsRefs,
            bool doctorSymptomsRefs,
            bool vaccinationsRefs,
          })
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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
          prefetchHooksCallback:
              ({
                appointmentsRefs = false,
                medicationsRefs = false,
                doctorSymptomsRefs = false,
                vaccinationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appointmentsRefs) db.appointments,
                    if (medicationsRefs) db.medications,
                    if (doctorSymptomsRefs) db.doctorSymptoms,
                    if (vaccinationsRefs) db.vaccinations,
                  ],
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
                          managerFromTypedResult: (p0) =>
                              $$DoctorsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.doctorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicationsRefs)
                        await $_getPrefetchedData<
                          Doctor,
                          $DoctorsTable,
                          Medication
                        >(
                          currentTable: table,
                          referencedTable: $$DoctorsTableReferences
                              ._medicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DoctorsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.prescriberId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (doctorSymptomsRefs)
                        await $_getPrefetchedData<
                          Doctor,
                          $DoctorsTable,
                          DoctorSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$DoctorsTableReferences
                              ._doctorSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DoctorsTableReferences(
                                db,
                                table,
                                p0,
                              ).doctorSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.doctorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vaccinationsRefs)
                        await $_getPrefetchedData<
                          Doctor,
                          $DoctorsTable,
                          Vaccination
                        >(
                          currentTable: table,
                          referencedTable: $$DoctorsTableReferences
                              ._vaccinationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DoctorsTableReferences(
                                db,
                                table,
                                p0,
                              ).vaccinationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.doctorId == item.id,
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
      PrefetchHooks Function({
        bool appointmentsRefs,
        bool medicationsRefs,
        bool doctorSymptomsRefs,
        bool vaccinationsRefs,
      })
    >;
typedef $$DiagnosesTableCreateCompanionBuilder = DiagnosesCompanion Function({
  Value<DateTime?> archivedAt,
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
  Value<DateTime?> archivedAt,
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
  Value<DateTime?> archivedAt,
  required String id,
  required String label,
  Value<String?> diagnosisId,
  Value<String?> bodyRegion,
  Value<DateTime?> healedAt,
  required CheckInCadence checkInCadence,
  Value<String> reminderTimesJson,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String?> sensation,
  Value<String?> quality,
  Value<String?> side,
  Value<String?> measure,
  Value<String?> measure2,
  Value<int> rowid,
});
typedef $$SymptomsTableUpdateCompanionBuilder = SymptomsCompanion Function({
  Value<DateTime?> archivedAt,
  Value<String> id,
  Value<String> label,
  Value<String?> diagnosisId,
  Value<String?> bodyRegion,
  Value<DateTime?> healedAt,
  Value<CheckInCadence> checkInCadence,
  Value<String> reminderTimesJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String?> sensation,
  Value<String?> quality,
  Value<String?> side,
  Value<String?> measure,
  Value<String?> measure2,
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

  static MultiTypedResultKey<$ReminderSymptomsTable, List<ReminderSymptom>>
  _reminderSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderSymptoms,
    aliasName: 'symptoms__id__reminder_symptoms__symptom_id',
  );

  $$ReminderSymptomsTableProcessedTableManager get reminderSymptomsRefs {
    final manager = $$ReminderSymptomsTableTableManager(
      $_db,
      $_db.reminderSymptoms,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reminderSymptomsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DoctorSymptomsTable, List<DoctorSymptom>>
  _doctorSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.doctorSymptoms,
    aliasName: 'symptoms__id__doctor_symptoms__symptom_id',
  );

  $$DoctorSymptomsTableProcessedTableManager get doctorSymptomsRefs {
    final manager = $$DoctorSymptomsTableTableManager(
      $_db,
      $_db.doctorSymptoms,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doctorSymptomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SymptomMediaTable, List<SymptomMediaItem>>
  _symptomMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomMedia,
    aliasName: 'symptoms__id__symptom_media__symptom_id',
  );

  $$SymptomMediaTableProcessedTableManager get symptomMediaRefs {
    final manager = $$SymptomMediaTableTableManager(
      $_db,
      $_db.symptomMedia,
    ).filter((f) => f.symptomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomMediaRefsTable($_db));
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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

  ColumnFilters<String> get sensation => $composableBuilder(
    column: $table.sensation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measure2 => $composableBuilder(
    column: $table.measure2,
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

  Expression<bool> reminderSymptomsRefs(
    Expression<bool> Function($$ReminderSymptomsTableFilterComposer f) f,
  ) {
    final $$ReminderSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderSymptoms,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.reminderSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> doctorSymptomsRefs(
    Expression<bool> Function($$DoctorSymptomsTableFilterComposer f) f,
  ) {
    final $$DoctorSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorSymptoms,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.doctorSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> symptomMediaRefs(
    Expression<bool> Function($$SymptomMediaTableFilterComposer f) f,
  ) {
    final $$SymptomMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomMedia,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomMediaTableFilterComposer(
            $db: $db,
            $table: $db.symptomMedia,
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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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

  ColumnOrderings<String> get sensation => $composableBuilder(
    column: $table.sensation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measure2 => $composableBuilder(
    column: $table.measure2,
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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get sensation =>
      $composableBuilder(column: $table.sensation, builder: (column) => column);

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<String> get measure =>
      $composableBuilder(column: $table.measure, builder: (column) => column);

  GeneratedColumn<String> get measure2 =>
      $composableBuilder(column: $table.measure2, builder: (column) => column);

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

  Expression<T> reminderSymptomsRefs<T extends Object>(
    Expression<T> Function($$ReminderSymptomsTableAnnotationComposer a) f,
  ) {
    final $$ReminderSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderSymptoms,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> doctorSymptomsRefs<T extends Object>(
    Expression<T> Function($$DoctorSymptomsTableAnnotationComposer a) f,
  ) {
    final $$DoctorSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doctorSymptoms,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoctorSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.doctorSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> symptomMediaRefs<T extends Object>(
    Expression<T> Function($$SymptomMediaTableAnnotationComposer a) f,
  ) {
    final $$SymptomMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomMedia,
      getReferencedColumn: (t) => t.symptomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomMedia,
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
            bool reminderSymptomsRefs,
            bool doctorSymptomsRefs,
            bool symptomMediaRefs,
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
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<String?> bodyRegion = const Value.absent(),
                Value<DateTime?> healedAt = const Value.absent(),
                Value<CheckInCadence> checkInCadence = const Value.absent(),
                Value<String> reminderTimesJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> sensation = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> measure = const Value.absent(),
                Value<String?> measure2 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion(
                archivedAt: archivedAt,
                id: id,
                label: label,
                diagnosisId: diagnosisId,
                bodyRegion: bodyRegion,
                healedAt: healedAt,
                checkInCadence: checkInCadence,
                reminderTimesJson: reminderTimesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sensation: sensation,
                quality: quality,
                side: side,
                measure: measure,
                measure2: measure2,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String label,
                Value<String?> diagnosisId = const Value.absent(),
                Value<String?> bodyRegion = const Value.absent(),
                Value<DateTime?> healedAt = const Value.absent(),
                required CheckInCadence checkInCadence,
                Value<String> reminderTimesJson = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> sensation = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> measure = const Value.absent(),
                Value<String?> measure2 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomsCompanion.insert(
                archivedAt: archivedAt,
                id: id,
                label: label,
                diagnosisId: diagnosisId,
                bodyRegion: bodyRegion,
                healedAt: healedAt,
                checkInCadence: checkInCadence,
                reminderTimesJson: reminderTimesJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sensation: sensation,
                quality: quality,
                side: side,
                measure: measure,
                measure2: measure2,
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
                reminderSymptomsRefs = false,
                doctorSymptomsRefs = false,
                symptomMediaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomObservationsRefs) db.symptomObservations,
                    if (appointmentSymptomsRefs) db.appointmentSymptoms,
                    if (reminderSymptomsRefs) db.reminderSymptoms,
                    if (doctorSymptomsRefs) db.doctorSymptoms,
                    if (symptomMediaRefs) db.symptomMedia,
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
                      if (reminderSymptomsRefs)
                        await $_getPrefetchedData<
                          Symptom,
                          $SymptomsTable,
                          ReminderSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomsTableReferences
                              ._reminderSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).reminderSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (doctorSymptomsRefs)
                        await $_getPrefetchedData<
                          Symptom,
                          $SymptomsTable,
                          DoctorSymptom
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomsTableReferences
                              ._doctorSymptomsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).doctorSymptomsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.symptomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (symptomMediaRefs)
                        await $_getPrefetchedData<
                          Symptom,
                          $SymptomsTable,
                          SymptomMediaItem
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomsTableReferences
                              ._symptomMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomMediaRefs,
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
        bool reminderSymptomsRefs,
        bool doctorSymptomsRefs,
        bool symptomMediaRefs,
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
      Value<String?> sensation,
      Value<String?> quality,
      Value<String?> location,
      Value<String?> side,
      Value<String?> pattern,
      Value<String?> measure,
      Value<double?> valueNumber2,
      Value<String?> measure2,
      Value<double?> secondaryValue,
      Value<int?> energy,
      Value<double?> sleepHours,
      Value<int?> anxiety,
      Value<String?> journal,
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
      Value<String?> sensation,
      Value<String?> quality,
      Value<String?> location,
      Value<String?> side,
      Value<String?> pattern,
      Value<String?> measure,
      Value<double?> valueNumber2,
      Value<String?> measure2,
      Value<double?> secondaryValue,
      Value<int?> energy,
      Value<double?> sleepHours,
      Value<int?> anxiety,
      Value<String?> journal,
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

  static MultiTypedResultKey<$SymptomMediaTable, List<SymptomMediaItem>>
  _symptomMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.symptomMedia,
    aliasName: 'symptom_observations__id__symptom_media__observation_id',
  );

  $$SymptomMediaTableProcessedTableManager get symptomMediaRefs {
    final manager = $$SymptomMediaTableTableManager(
      $_db,
      $_db.symptomMedia,
    ).filter((f) => f.observationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_symptomMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  ColumnFilters<String> get sensation => $composableBuilder(
    column: $table.sensation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueNumber2 => $composableBuilder(
    column: $table.valueNumber2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measure2 => $composableBuilder(
    column: $table.measure2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anxiety => $composableBuilder(
    column: $table.anxiety,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get journal => $composableBuilder(
    column: $table.journal,
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

  Expression<bool> symptomMediaRefs(
    Expression<bool> Function($$SymptomMediaTableFilterComposer f) f,
  ) {
    final $$SymptomMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomMedia,
      getReferencedColumn: (t) => t.observationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomMediaTableFilterComposer(
            $db: $db,
            $table: $db.symptomMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  ColumnOrderings<String> get sensation => $composableBuilder(
    column: $table.sensation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get side => $composableBuilder(
    column: $table.side,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measure => $composableBuilder(
    column: $table.measure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumber2 => $composableBuilder(
    column: $table.valueNumber2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measure2 => $composableBuilder(
    column: $table.measure2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energy => $composableBuilder(
    column: $table.energy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anxiety => $composableBuilder(
    column: $table.anxiety,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journal => $composableBuilder(
    column: $table.journal,
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

  GeneratedColumn<String> get sensation =>
      $composableBuilder(column: $table.sensation, builder: (column) => column);

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<String> get measure =>
      $composableBuilder(column: $table.measure, builder: (column) => column);

  GeneratedColumn<double> get valueNumber2 => $composableBuilder(
    column: $table.valueNumber2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measure2 =>
      $composableBuilder(column: $table.measure2, builder: (column) => column);

  GeneratedColumn<double> get secondaryValue => $composableBuilder(
    column: $table.secondaryValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get anxiety =>
      $composableBuilder(column: $table.anxiety, builder: (column) => column);

  GeneratedColumn<String> get journal =>
      $composableBuilder(column: $table.journal, builder: (column) => column);

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

  Expression<T> symptomMediaRefs<T extends Object>(
    Expression<T> Function($$SymptomMediaTableAnnotationComposer a) f,
  ) {
    final $$SymptomMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.symptomMedia,
      getReferencedColumn: (t) => t.observationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SymptomMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.symptomMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({bool symptomId, bool symptomMediaRefs})
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
                Value<String?> sensation = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<String?> measure = const Value.absent(),
                Value<double?> valueNumber2 = const Value.absent(),
                Value<String?> measure2 = const Value.absent(),
                Value<double?> secondaryValue = const Value.absent(),
                Value<int?> energy = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<int?> anxiety = const Value.absent(),
                Value<String?> journal = const Value.absent(),
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
                sensation: sensation,
                quality: quality,
                location: location,
                side: side,
                pattern: pattern,
                measure: measure,
                valueNumber2: valueNumber2,
                measure2: measure2,
                secondaryValue: secondaryValue,
                energy: energy,
                sleepHours: sleepHours,
                anxiety: anxiety,
                journal: journal,
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
                Value<String?> sensation = const Value.absent(),
                Value<String?> quality = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> side = const Value.absent(),
                Value<String?> pattern = const Value.absent(),
                Value<String?> measure = const Value.absent(),
                Value<double?> valueNumber2 = const Value.absent(),
                Value<String?> measure2 = const Value.absent(),
                Value<double?> secondaryValue = const Value.absent(),
                Value<int?> energy = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<int?> anxiety = const Value.absent(),
                Value<String?> journal = const Value.absent(),
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
                sensation: sensation,
                quality: quality,
                location: location,
                side: side,
                pattern: pattern,
                measure: measure,
                valueNumber2: valueNumber2,
                measure2: measure2,
                secondaryValue: secondaryValue,
                energy: energy,
                sleepHours: sleepHours,
                anxiety: anxiety,
                journal: journal,
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
          prefetchHooksCallback:
              ({symptomId = false, symptomMediaRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (symptomMediaRefs) db.symptomMedia,
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
                        if (symptomId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.symptomId,
                            referencedTable:
                                $$SymptomObservationsTableReferences
                                    ._symptomIdTable(db),
                            referencedColumn:
                                $$SymptomObservationsTableReferences
                                    ._symptomIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (symptomMediaRefs)
                        await $_getPrefetchedData<
                          SymptomObservation,
                          $SymptomObservationsTable,
                          SymptomMediaItem
                        >(
                          currentTable: table,
                          referencedTable: $$SymptomObservationsTableReferences
                              ._symptomMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SymptomObservationsTableReferences(
                                db,
                                table,
                                p0,
                              ).symptomMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.observationId == item.id,
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
      PrefetchHooks Function({bool symptomId, bool symptomMediaRefs})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<DateTime?> archivedAt,
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
      Value<DateTime?> archivedAt,
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
  Value<DateTime?> archivedAt,
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
  Value<DateTime?> archivedAt,
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
                Value<DateTime?> archivedAt = const Value.absent(),
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
                archivedAt: archivedAt,
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
typedef $$PharmaciesTableCreateCompanionBuilder = PharmaciesCompanion Function({
  Value<DateTime?> archivedAt,
  required String id,
  required String name,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PharmaciesTableUpdateCompanionBuilder = PharmaciesCompanion Function({
  Value<DateTime?> archivedAt,
  Value<String> id,
  Value<String> name,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PharmaciesTableReferences
    extends BaseReferences<_$AppDatabase, $PharmaciesTable, Pharmacy> {
  $$PharmaciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationsTable, List<Medication>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: 'pharmacies__id__medications__pharmacy_id',
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.pharmacyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PharmaciesTableFilterComposer
    extends Composer<_$AppDatabase, $PharmaciesTable> {
  $$PharmaciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
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

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.pharmacyId,
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
}

class $$PharmaciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PharmaciesTable> {
  $$PharmaciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
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

class $$PharmaciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PharmaciesTable> {
  $$PharmaciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.pharmacyId,
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
}

class $$PharmaciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PharmaciesTable,
          Pharmacy,
          $$PharmaciesTableFilterComposer,
          $$PharmaciesTableOrderingComposer,
          $$PharmaciesTableAnnotationComposer,
          $$PharmaciesTableCreateCompanionBuilder,
          $$PharmaciesTableUpdateCompanionBuilder,
          (Pharmacy, $$PharmaciesTableReferences),
          Pharmacy,
          PrefetchHooks Function({bool medicationsRefs})
        > {
  $$PharmaciesTableTableManager(_$AppDatabase db, $PharmaciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PharmaciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PharmaciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PharmaciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PharmaciesCompanion(
                archivedAt: archivedAt,
                id: id,
                name: name,
                address: address,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PharmaciesCompanion.insert(
                archivedAt: archivedAt,
                id: id,
                name: name,
                address: address,
                phone: phone,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PharmaciesTable, Pharmacy>(table),
                  $$PharmaciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medicationsRefs) db.medications],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationsRefs)
                    await $_getPrefetchedData<
                      Pharmacy,
                      $PharmaciesTable,
                      Medication
                    >(
                      currentTable: table,
                      referencedTable: $$PharmaciesTableReferences
                          ._medicationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PharmaciesTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.pharmacyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PharmaciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PharmaciesTable,
      Pharmacy,
      $$PharmaciesTableFilterComposer,
      $$PharmaciesTableOrderingComposer,
      $$PharmaciesTableAnnotationComposer,
      $$PharmaciesTableCreateCompanionBuilder,
      $$PharmaciesTableUpdateCompanionBuilder,
      (Pharmacy, $$PharmaciesTableReferences),
      Pharmacy,
      PrefetchHooks Function({bool medicationsRefs})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<DateTime?> archivedAt,
      required String id,
      required String name,
      Value<String?> dosage,
      Value<String?> scheduleText,
      Value<String?> diagnosisId,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<MedicationForm?> form,
      Value<double?> doseAmount,
      Value<String?> doseUnit,
      Value<String?> instructions,
      Value<String?> prescriberId,
      Value<String?> pharmacyId,
      Value<bool> remindersEnabled,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> name,
      Value<String?> dosage,
      Value<String?> scheduleText,
      Value<String?> diagnosisId,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<MedicationForm?> form,
      Value<double?> doseAmount,
      Value<String?> doseUnit,
      Value<String?> instructions,
      Value<String?> prescriberId,
      Value<String?> pharmacyId,
      Value<bool> remindersEnabled,
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

  static $DoctorsTable _prescriberIdTable(_$AppDatabase db) =>
      db.doctors.createAlias('medications__prescriber_id__doctors__id');

  $$DoctorsTableProcessedTableManager? get prescriberId {
    final $_column = $_itemColumn<String>('prescriber_id');
    if ($_column == null) return null;
    final manager = $$DoctorsTableTableManager(
      $_db,
      $_db.doctors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prescriberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PharmaciesTable _pharmacyIdTable(_$AppDatabase db) =>
      db.pharmacies.createAlias('medications__pharmacy_id__pharmacies__id');

  $$PharmaciesTableProcessedTableManager? get pharmacyId {
    final $_column = $_itemColumn<String>('pharmacy_id');
    if ($_column == null) return null;
    final manager = $$PharmaciesTableTableManager(
      $_db,
      $_db.pharmacies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pharmacyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MedicationSchedulesTable,
    List<MedicationSchedule>
  >
  _medicationSchedulesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicationSchedules,
        aliasName: 'medications__id__medication_schedules__medication_id',
      );

  $$MedicationSchedulesTableProcessedTableManager get medicationSchedulesRefs {
    final manager = $$MedicationSchedulesTableTableManager(
      $_db,
      $_db.medicationSchedules,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicationIntakesTable, List<MedicationIntake>>
  _medicationIntakesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicationIntakes,
        aliasName: 'medications__id__medication_intakes__medication_id',
      );

  $$MedicationIntakesTableProcessedTableManager get medicationIntakesRefs {
    final manager = $$MedicationIntakesTableTableManager(
      $_db,
      $_db.medicationIntakes,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationIntakesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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

  ColumnWithTypeConverterFilters<MedicationForm?, MedicationForm, int>
  get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseUnit => $composableBuilder(
    column: $table.doseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
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

  $$DoctorsTableFilterComposer get prescriberId {
    final $$DoctorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriberId,
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

  $$PharmaciesTableFilterComposer get pharmacyId {
    final $$PharmaciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pharmacyId,
      referencedTable: $db.pharmacies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PharmaciesTableFilterComposer(
            $db: $db,
            $table: $db.pharmacies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> medicationSchedulesRefs(
    Expression<bool> Function($$MedicationSchedulesTableFilterComposer f) f,
  ) {
    final $$MedicationSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationSchedules,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.medicationSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationIntakesRefs(
    Expression<bool> Function($$MedicationIntakesTableFilterComposer f) f,
  ) {
    final $$MedicationIntakesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationIntakes,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationIntakesTableFilterComposer(
            $db: $db,
            $table: $db.medicationIntakes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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

  ColumnOrderings<int> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseUnit => $composableBuilder(
    column: $table.doseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
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

  $$DoctorsTableOrderingComposer get prescriberId {
    final $$DoctorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriberId,
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

  $$PharmaciesTableOrderingComposer get pharmacyId {
    final $$PharmaciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pharmacyId,
      referencedTable: $db.pharmacies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PharmaciesTableOrderingComposer(
            $db: $db,
            $table: $db.pharmacies,
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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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

  GeneratedColumnWithTypeConverter<MedicationForm?, int> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doseUnit =>
      $composableBuilder(column: $table.doseUnit, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

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

  $$DoctorsTableAnnotationComposer get prescriberId {
    final $$DoctorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriberId,
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

  $$PharmaciesTableAnnotationComposer get pharmacyId {
    final $$PharmaciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.pharmacyId,
      referencedTable: $db.pharmacies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PharmaciesTableAnnotationComposer(
            $db: $db,
            $table: $db.pharmacies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> medicationSchedulesRefs<T extends Object>(
    Expression<T> Function($$MedicationSchedulesTableAnnotationComposer a) f,
  ) {
    final $$MedicationSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicationSchedules,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> medicationIntakesRefs<T extends Object>(
    Expression<T> Function($$MedicationIntakesTableAnnotationComposer a) f,
  ) {
    final $$MedicationIntakesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicationIntakes,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationIntakesTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationIntakes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
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
          PrefetchHooks Function({
            bool diagnosisId,
            bool prescriberId,
            bool pharmacyId,
            bool medicationSchedulesRefs,
            bool medicationIntakesRefs,
          })
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
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleText = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<MedicationForm?> form = const Value.absent(),
                Value<double?> doseAmount = const Value.absent(),
                Value<String?> doseUnit = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> prescriberId = const Value.absent(),
                Value<String?> pharmacyId = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                archivedAt: archivedAt,
                id: id,
                name: name,
                dosage: dosage,
                scheduleText: scheduleText,
                diagnosisId: diagnosisId,
                startedAt: startedAt,
                endedAt: endedAt,
                notes: notes,
                createdAt: createdAt,
                form: form,
                doseAmount: doseAmount,
                doseUnit: doseUnit,
                instructions: instructions,
                prescriberId: prescriberId,
                pharmacyId: pharmacyId,
                remindersEnabled: remindersEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<String?> scheduleText = const Value.absent(),
                Value<String?> diagnosisId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<MedicationForm?> form = const Value.absent(),
                Value<double?> doseAmount = const Value.absent(),
                Value<String?> doseUnit = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> prescriberId = const Value.absent(),
                Value<String?> pharmacyId = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                archivedAt: archivedAt,
                id: id,
                name: name,
                dosage: dosage,
                scheduleText: scheduleText,
                diagnosisId: diagnosisId,
                startedAt: startedAt,
                endedAt: endedAt,
                notes: notes,
                createdAt: createdAt,
                form: form,
                doseAmount: doseAmount,
                doseUnit: doseUnit,
                instructions: instructions,
                prescriberId: prescriberId,
                pharmacyId: pharmacyId,
                remindersEnabled: remindersEnabled,
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
          prefetchHooksCallback:
              ({
                diagnosisId = false,
                prescriberId = false,
                pharmacyId = false,
                medicationSchedulesRefs = false,
                medicationIntakesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationSchedulesRefs) db.medicationSchedules,
                    if (medicationIntakesRefs) db.medicationIntakes,
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
                            referencedTable: $$MedicationsTableReferences
                                ._diagnosisIdTable(db),
                            referencedColumn: $$MedicationsTableReferences
                                ._diagnosisIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (prescriberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.prescriberId,
                            referencedTable: $$MedicationsTableReferences
                                ._prescriberIdTable(db),
                            referencedColumn: $$MedicationsTableReferences
                                ._prescriberIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (pharmacyId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.pharmacyId,
                            referencedTable: $$MedicationsTableReferences
                                ._pharmacyIdTable(db),
                            referencedColumn: $$MedicationsTableReferences
                                ._pharmacyIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationSchedulesRefs)
                        await $_getPrefetchedData<
                          Medication,
                          $MedicationsTable,
                          MedicationSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._medicationSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicationIntakesRefs)
                        await $_getPrefetchedData<
                          Medication,
                          $MedicationsTable,
                          MedicationIntake
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._medicationIntakesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationIntakesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
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
      PrefetchHooks Function({
        bool diagnosisId,
        bool prescriberId,
        bool pharmacyId,
        bool medicationSchedulesRefs,
        bool medicationIntakesRefs,
      })
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<DateTime?> archivedAt,
  required String id,
  required String body,
  Value<String?> relatedAppointmentId,
  Value<String?> relatedDiagnosisId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<DateTime?> archivedAt,
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
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

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
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

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
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

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
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> relatedAppointmentId = const Value.absent(),
                Value<String?> relatedDiagnosisId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                archivedAt: archivedAt,
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
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String body,
                Value<String?> relatedAppointmentId = const Value.absent(),
                Value<String?> relatedDiagnosisId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                archivedAt: archivedAt,
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
      Value<bool> onboardingCompleted,
      Value<bool> appointmentRemindersEnabled,
      Value<String> appointmentReminderLeads,
      Value<String> notificationTopics,
      Value<bool> cycleTracking,
      Value<bool> menopauseTracking,
      Value<bool> pregnancyTracking,
      Value<bool> showFertileWindow,
      Value<String?> temperatureUnit,
      Value<String?> glucoseUnit,
      Value<String?> weightUnit,
      Value<bool> psychQuestionnaires,
      Value<int?> typicalCycleLength,
      Value<bool> cycleSetupDone,
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
      Value<bool> onboardingCompleted,
      Value<bool> appointmentRemindersEnabled,
      Value<String> appointmentReminderLeads,
      Value<String> notificationTopics,
      Value<bool> cycleTracking,
      Value<bool> menopauseTracking,
      Value<bool> pregnancyTracking,
      Value<bool> showFertileWindow,
      Value<String?> temperatureUnit,
      Value<String?> glucoseUnit,
      Value<String?> weightUnit,
      Value<bool> psychQuestionnaires,
      Value<int?> typicalCycleLength,
      Value<bool> cycleSetupDone,
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

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appointmentRemindersEnabled => $composableBuilder(
    column: $table.appointmentRemindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentReminderLeads => $composableBuilder(
    column: $table.appointmentReminderLeads,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationTopics => $composableBuilder(
    column: $table.notificationTopics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cycleTracking => $composableBuilder(
    column: $table.cycleTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get menopauseTracking => $composableBuilder(
    column: $table.menopauseTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pregnancyTracking => $composableBuilder(
    column: $table.pregnancyTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showFertileWindow => $composableBuilder(
    column: $table.showFertileWindow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get temperatureUnit => $composableBuilder(
    column: $table.temperatureUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get psychQuestionnaires => $composableBuilder(
    column: $table.psychQuestionnaires,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typicalCycleLength => $composableBuilder(
    column: $table.typicalCycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cycleSetupDone => $composableBuilder(
    column: $table.cycleSetupDone,
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

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appointmentRemindersEnabled => $composableBuilder(
    column: $table.appointmentRemindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentReminderLeads => $composableBuilder(
    column: $table.appointmentReminderLeads,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationTopics => $composableBuilder(
    column: $table.notificationTopics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cycleTracking => $composableBuilder(
    column: $table.cycleTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get menopauseTracking => $composableBuilder(
    column: $table.menopauseTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pregnancyTracking => $composableBuilder(
    column: $table.pregnancyTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showFertileWindow => $composableBuilder(
    column: $table.showFertileWindow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get temperatureUnit => $composableBuilder(
    column: $table.temperatureUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get psychQuestionnaires => $composableBuilder(
    column: $table.psychQuestionnaires,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typicalCycleLength => $composableBuilder(
    column: $table.typicalCycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cycleSetupDone => $composableBuilder(
    column: $table.cycleSetupDone,
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

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appointmentRemindersEnabled => $composableBuilder(
    column: $table.appointmentRemindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appointmentReminderLeads => $composableBuilder(
    column: $table.appointmentReminderLeads,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationTopics => $composableBuilder(
    column: $table.notificationTopics,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cycleTracking => $composableBuilder(
    column: $table.cycleTracking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get menopauseTracking => $composableBuilder(
    column: $table.menopauseTracking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pregnancyTracking => $composableBuilder(
    column: $table.pregnancyTracking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showFertileWindow => $composableBuilder(
    column: $table.showFertileWindow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get temperatureUnit => $composableBuilder(
    column: $table.temperatureUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get psychQuestionnaires => $composableBuilder(
    column: $table.psychQuestionnaires,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typicalCycleLength => $composableBuilder(
    column: $table.typicalCycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cycleSetupDone => $composableBuilder(
    column: $table.cycleSetupDone,
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
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> appointmentRemindersEnabled = const Value.absent(),
                Value<String> appointmentReminderLeads = const Value.absent(),
                Value<String> notificationTopics = const Value.absent(),
                Value<bool> cycleTracking = const Value.absent(),
                Value<bool> menopauseTracking = const Value.absent(),
                Value<bool> pregnancyTracking = const Value.absent(),
                Value<bool> showFertileWindow = const Value.absent(),
                Value<String?> temperatureUnit = const Value.absent(),
                Value<String?> glucoseUnit = const Value.absent(),
                Value<String?> weightUnit = const Value.absent(),
                Value<bool> psychQuestionnaires = const Value.absent(),
                Value<int?> typicalCycleLength = const Value.absent(),
                Value<bool> cycleSetupDone = const Value.absent(),
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
                onboardingCompleted: onboardingCompleted,
                appointmentRemindersEnabled: appointmentRemindersEnabled,
                appointmentReminderLeads: appointmentReminderLeads,
                notificationTopics: notificationTopics,
                cycleTracking: cycleTracking,
                menopauseTracking: menopauseTracking,
                pregnancyTracking: pregnancyTracking,
                showFertileWindow: showFertileWindow,
                temperatureUnit: temperatureUnit,
                glucoseUnit: glucoseUnit,
                weightUnit: weightUnit,
                psychQuestionnaires: psychQuestionnaires,
                typicalCycleLength: typicalCycleLength,
                cycleSetupDone: cycleSetupDone,
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
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> appointmentRemindersEnabled = const Value.absent(),
                Value<String> appointmentReminderLeads = const Value.absent(),
                Value<String> notificationTopics = const Value.absent(),
                Value<bool> cycleTracking = const Value.absent(),
                Value<bool> menopauseTracking = const Value.absent(),
                Value<bool> pregnancyTracking = const Value.absent(),
                Value<bool> showFertileWindow = const Value.absent(),
                Value<String?> temperatureUnit = const Value.absent(),
                Value<String?> glucoseUnit = const Value.absent(),
                Value<String?> weightUnit = const Value.absent(),
                Value<bool> psychQuestionnaires = const Value.absent(),
                Value<int?> typicalCycleLength = const Value.absent(),
                Value<bool> cycleSetupDone = const Value.absent(),
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
                onboardingCompleted: onboardingCompleted,
                appointmentRemindersEnabled: appointmentRemindersEnabled,
                appointmentReminderLeads: appointmentReminderLeads,
                notificationTopics: notificationTopics,
                cycleTracking: cycleTracking,
                menopauseTracking: menopauseTracking,
                pregnancyTracking: pregnancyTracking,
                showFertileWindow: showFertileWindow,
                temperatureUnit: temperatureUnit,
                glucoseUnit: glucoseUnit,
                weightUnit: weightUnit,
                psychQuestionnaires: psychQuestionnaires,
                typicalCycleLength: typicalCycleLength,
                cycleSetupDone: cycleSetupDone,
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
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required int slot,
  required String title,
  Value<String?> body,
  required int hour,
  required int minute,
  Value<int> weekdays,
  Value<bool> enabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<int> slot,
  Value<String> title,
  Value<String?> body,
  Value<int> hour,
  Value<int> minute,
  Value<int> weekdays,
  Value<bool> enabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReminderSymptomsTable, List<ReminderSymptom>>
  _reminderSymptomsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminderSymptoms,
    aliasName: 'reminders__id__reminder_symptoms__reminder_id',
  );

  $$ReminderSymptomsTableProcessedTableManager get reminderSymptomsRefs {
    final manager = $$ReminderSymptomsTableTableManager(
      $_db,
      $_db.reminderSymptoms,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reminderSymptomsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
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

  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
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

  Expression<bool> reminderSymptomsRefs(
    Expression<bool> Function($$ReminderSymptomsTableFilterComposer f) f,
  ) {
    final $$ReminderSymptomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderSymptoms,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderSymptomsTableFilterComposer(
            $db: $db,
            $table: $db.reminderSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
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

  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
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

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> reminderSymptomsRefs<T extends Object>(
    Expression<T> Function($$ReminderSymptomsTableAnnotationComposer a) f,
  ) {
    final $$ReminderSymptomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminderSymptoms,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReminderSymptomsTableAnnotationComposer(
            $db: $db,
            $table: $db.reminderSymptoms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool reminderSymptomsRefs})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> slot = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                slot: slot,
                title: title,
                body: body,
                hour: hour,
                minute: minute,
                weekdays: weekdays,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int slot,
                required String title,
                Value<String?> body = const Value.absent(),
                required int hour,
                required int minute,
                Value<int> weekdays = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                slot: slot,
                title: title,
                body: body,
                hour: hour,
                minute: minute,
                weekdays: weekdays,
                enabled: enabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderSymptomsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reminderSymptomsRefs) db.reminderSymptoms,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reminderSymptomsRefs)
                    await $_getPrefetchedData<
                      Reminder,
                      $RemindersTable,
                      ReminderSymptom
                    >(
                      currentTable: table,
                      referencedTable: $$RemindersTableReferences
                          ._reminderSymptomsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RemindersTableReferences(
                            db,
                            table,
                            p0,
                          ).reminderSymptomsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.reminderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool reminderSymptomsRefs})
    >;
typedef $$ReminderSymptomsTableCreateCompanionBuilder =
    ReminderSymptomsCompanion Function({
      required String reminderId,
      required String symptomId,
      Value<int> rowid,
    });
typedef $$ReminderSymptomsTableUpdateCompanionBuilder =
    ReminderSymptomsCompanion Function({
      Value<String> reminderId,
      Value<String> symptomId,
      Value<int> rowid,
    });

final class $$ReminderSymptomsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReminderSymptomsTable, ReminderSymptom> {
  $$ReminderSymptomsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RemindersTable _reminderIdTable(_$AppDatabase db) =>
      db.reminders.createAlias('reminder_symptoms__reminder_id__reminders__id');

  $$RemindersTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<String>('reminder_id')!;

    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias('reminder_symptoms__symptom_id__symptoms__id');

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

class $$ReminderSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSymptomsTable> {
  $$ReminderSymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RemindersTableFilterComposer get reminderId {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
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

class $$ReminderSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSymptomsTable> {
  $$ReminderSymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RemindersTableOrderingComposer get reminderId {
    final $$RemindersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableOrderingComposer(
            $db: $db,
            $table: $db.reminders,
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

class $$ReminderSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSymptomsTable> {
  $$ReminderSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$RemindersTableAnnotationComposer get reminderId {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
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

class $$ReminderSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderSymptomsTable,
          ReminderSymptom,
          $$ReminderSymptomsTableFilterComposer,
          $$ReminderSymptomsTableOrderingComposer,
          $$ReminderSymptomsTableAnnotationComposer,
          $$ReminderSymptomsTableCreateCompanionBuilder,
          $$ReminderSymptomsTableUpdateCompanionBuilder,
          (ReminderSymptom, $$ReminderSymptomsTableReferences),
          ReminderSymptom,
          PrefetchHooks Function({bool reminderId, bool symptomId})
        > {
  $$ReminderSymptomsTableTableManager(
    _$AppDatabase db,
    $ReminderSymptomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> reminderId = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderSymptomsCompanion(
                reminderId: reminderId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String reminderId,
                required String symptomId,
                Value<int> rowid = const Value.absent(),
              }) => ReminderSymptomsCompanion.insert(
                reminderId: reminderId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderSymptomsTable, ReminderSymptom>(table),
                  $$ReminderSymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderId = false, symptomId = false}) {
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
                    if (reminderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.reminderId,
                        referencedTable: $$ReminderSymptomsTableReferences
                            ._reminderIdTable(db),
                        referencedColumn: $$ReminderSymptomsTableReferences
                            ._reminderIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (symptomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.symptomId,
                        referencedTable: $$ReminderSymptomsTableReferences
                            ._symptomIdTable(db),
                        referencedColumn: $$ReminderSymptomsTableReferences
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

typedef $$ReminderSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderSymptomsTable,
      ReminderSymptom,
      $$ReminderSymptomsTableFilterComposer,
      $$ReminderSymptomsTableOrderingComposer,
      $$ReminderSymptomsTableAnnotationComposer,
      $$ReminderSymptomsTableCreateCompanionBuilder,
      $$ReminderSymptomsTableUpdateCompanionBuilder,
      (ReminderSymptom, $$ReminderSymptomsTableReferences),
      ReminderSymptom,
      PrefetchHooks Function({bool reminderId, bool symptomId})
    >;
typedef $$DoctorSymptomsTableCreateCompanionBuilder =
    DoctorSymptomsCompanion Function({
      required String doctorId,
      required String symptomId,
      Value<int> rowid,
    });
typedef $$DoctorSymptomsTableUpdateCompanionBuilder =
    DoctorSymptomsCompanion Function({
      Value<String> doctorId,
      Value<String> symptomId,
      Value<int> rowid,
    });

final class $$DoctorSymptomsTableReferences
    extends BaseReferences<_$AppDatabase, $DoctorSymptomsTable, DoctorSymptom> {
  $$DoctorSymptomsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DoctorsTable _doctorIdTable(_$AppDatabase db) =>
      db.doctors.createAlias('doctor_symptoms__doctor_id__doctors__id');

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

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias('doctor_symptoms__symptom_id__symptoms__id');

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

class $$DoctorSymptomsTableFilterComposer
    extends Composer<_$AppDatabase, $DoctorSymptomsTable> {
  $$DoctorSymptomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

class $$DoctorSymptomsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoctorSymptomsTable> {
  $$DoctorSymptomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

class $$DoctorSymptomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoctorSymptomsTable> {
  $$DoctorSymptomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

class $$DoctorSymptomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoctorSymptomsTable,
          DoctorSymptom,
          $$DoctorSymptomsTableFilterComposer,
          $$DoctorSymptomsTableOrderingComposer,
          $$DoctorSymptomsTableAnnotationComposer,
          $$DoctorSymptomsTableCreateCompanionBuilder,
          $$DoctorSymptomsTableUpdateCompanionBuilder,
          (DoctorSymptom, $$DoctorSymptomsTableReferences),
          DoctorSymptom,
          PrefetchHooks Function({bool doctorId, bool symptomId})
        > {
  $$DoctorSymptomsTableTableManager(
    _$AppDatabase db,
    $DoctorSymptomsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorSymptomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorSymptomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorSymptomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> doctorId = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoctorSymptomsCompanion(
                doctorId: doctorId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String doctorId,
                required String symptomId,
                Value<int> rowid = const Value.absent(),
              }) => DoctorSymptomsCompanion.insert(
                doctorId: doctorId,
                symptomId: symptomId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DoctorSymptomsTable, DoctorSymptom>(table),
                  $$DoctorSymptomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({doctorId = false, symptomId = false}) {
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
                    if (doctorId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.doctorId,
                        referencedTable: $$DoctorSymptomsTableReferences
                            ._doctorIdTable(db),
                        referencedColumn: $$DoctorSymptomsTableReferences
                            ._doctorIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (symptomId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.symptomId,
                        referencedTable: $$DoctorSymptomsTableReferences
                            ._symptomIdTable(db),
                        referencedColumn: $$DoctorSymptomsTableReferences
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

typedef $$DoctorSymptomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoctorSymptomsTable,
      DoctorSymptom,
      $$DoctorSymptomsTableFilterComposer,
      $$DoctorSymptomsTableOrderingComposer,
      $$DoctorSymptomsTableAnnotationComposer,
      $$DoctorSymptomsTableCreateCompanionBuilder,
      $$DoctorSymptomsTableUpdateCompanionBuilder,
      (DoctorSymptom, $$DoctorSymptomsTableReferences),
      DoctorSymptom,
      PrefetchHooks Function({bool doctorId, bool symptomId})
    >;
typedef $$MedicationSchedulesTableCreateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      required String id,
      required String medicationId,
      required int slot,
      required int hour,
      required int minute,
      Value<int> weekdays,
      Value<double?> doseAmount,
      Value<int> rowid,
    });
typedef $$MedicationSchedulesTableUpdateCompanionBuilder =
    MedicationSchedulesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<int> slot,
      Value<int> hour,
      Value<int> minute,
      Value<int> weekdays,
      Value<double?> doseAmount,
      Value<int> rowid,
    });

final class $$MedicationSchedulesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationSchedulesTable,
          MedicationSchedule
        > {
  $$MedicationSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_schedules__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableFilterComposer({
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

  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MedicationSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableOrderingComposer({
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

  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationSchedulesTable> {
  $$MedicationSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => column,
  );

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MedicationSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationSchedulesTable,
          MedicationSchedule,
          $$MedicationSchedulesTableFilterComposer,
          $$MedicationSchedulesTableOrderingComposer,
          $$MedicationSchedulesTableAnnotationComposer,
          $$MedicationSchedulesTableCreateCompanionBuilder,
          $$MedicationSchedulesTableUpdateCompanionBuilder,
          (MedicationSchedule, $$MedicationSchedulesTableReferences),
          MedicationSchedule,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationSchedulesTableTableManager(
    _$AppDatabase db,
    $MedicationSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicationSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<int> slot = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<double?> doseAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationSchedulesCompanion(
                id: id,
                medicationId: medicationId,
                slot: slot,
                hour: hour,
                minute: minute,
                weekdays: weekdays,
                doseAmount: doseAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                required int slot,
                required int hour,
                required int minute,
                Value<int> weekdays = const Value.absent(),
                Value<double?> doseAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationSchedulesCompanion.insert(
                id: id,
                medicationId: medicationId,
                slot: slot,
                hour: hour,
                minute: minute,
                weekdays: weekdays,
                doseAmount: doseAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationSchedulesTable, MedicationSchedule>(
                    table,
                  ),
                  $$MedicationSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
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
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationSchedulesTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationSchedulesTableReferences
                            ._medicationIdTable(db)
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

typedef $$MedicationSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationSchedulesTable,
      MedicationSchedule,
      $$MedicationSchedulesTableFilterComposer,
      $$MedicationSchedulesTableOrderingComposer,
      $$MedicationSchedulesTableAnnotationComposer,
      $$MedicationSchedulesTableCreateCompanionBuilder,
      $$MedicationSchedulesTableUpdateCompanionBuilder,
      (MedicationSchedule, $$MedicationSchedulesTableReferences),
      MedicationSchedule,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$MedicationIntakesTableCreateCompanionBuilder =
    MedicationIntakesCompanion Function({
      required String id,
      required String medicationId,
      Value<DateTime?> scheduledFor,
      required DateTime recordedAt,
      required IntakeStatus status,
      Value<double?> doseAmount,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MedicationIntakesTableUpdateCompanionBuilder =
    MedicationIntakesCompanion Function({
      Value<String> id,
      Value<String> medicationId,
      Value<DateTime?> scheduledFor,
      Value<DateTime> recordedAt,
      Value<IntakeStatus> status,
      Value<double?> doseAmount,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$MedicationIntakesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationIntakesTable,
          MedicationIntake
        > {
  $$MedicationIntakesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_intakes__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationIntakesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationIntakesTable> {
  $$MedicationIntakesTableFilterComposer({
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

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IntakeStatus, IntakeStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MedicationIntakesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationIntakesTable> {
  $$MedicationIntakesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationIntakesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationIntakesTable> {
  $$MedicationIntakesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IntakeStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get doseAmount => $composableBuilder(
    column: $table.doseAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$MedicationIntakesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationIntakesTable,
          MedicationIntake,
          $$MedicationIntakesTableFilterComposer,
          $$MedicationIntakesTableOrderingComposer,
          $$MedicationIntakesTableAnnotationComposer,
          $$MedicationIntakesTableCreateCompanionBuilder,
          $$MedicationIntakesTableUpdateCompanionBuilder,
          (MedicationIntake, $$MedicationIntakesTableReferences),
          MedicationIntake,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationIntakesTableTableManager(
    _$AppDatabase db,
    $MedicationIntakesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationIntakesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationIntakesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationIntakesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicationId = const Value.absent(),
                Value<DateTime?> scheduledFor = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<IntakeStatus> status = const Value.absent(),
                Value<double?> doseAmount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationIntakesCompanion(
                id: id,
                medicationId: medicationId,
                scheduledFor: scheduledFor,
                recordedAt: recordedAt,
                status: status,
                doseAmount: doseAmount,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medicationId,
                Value<DateTime?> scheduledFor = const Value.absent(),
                required DateTime recordedAt,
                required IntakeStatus status,
                Value<double?> doseAmount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationIntakesCompanion.insert(
                id: id,
                medicationId: medicationId,
                scheduledFor: scheduledFor,
                recordedAt: recordedAt,
                status: status,
                doseAmount: doseAmount,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationIntakesTable, MedicationIntake>(table),
                  $$MedicationIntakesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
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
                    if (medicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicationId,
                        referencedTable: $$MedicationIntakesTableReferences
                            ._medicationIdTable(db),
                        referencedColumn: $$MedicationIntakesTableReferences
                            ._medicationIdTable(db)
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

typedef $$MedicationIntakesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationIntakesTable,
      MedicationIntake,
      $$MedicationIntakesTableFilterComposer,
      $$MedicationIntakesTableOrderingComposer,
      $$MedicationIntakesTableAnnotationComposer,
      $$MedicationIntakesTableCreateCompanionBuilder,
      $$MedicationIntakesTableUpdateCompanionBuilder,
      (MedicationIntake, $$MedicationIntakesTableReferences),
      MedicationIntake,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$VaccinationsTableCreateCompanionBuilder =
    VaccinationsCompanion Function({
      Value<DateTime?> archivedAt,
      required String id,
      required String vaccine,
      Value<String?> product,
      required DateTime administeredAt,
      Value<int?> doseNumber,
      Value<String?> batch,
      Value<String?> doctorId,
      Value<DateTime?> nextDueAt,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VaccinationsTableUpdateCompanionBuilder =
    VaccinationsCompanion Function({
      Value<DateTime?> archivedAt,
      Value<String> id,
      Value<String> vaccine,
      Value<String?> product,
      Value<DateTime> administeredAt,
      Value<int?> doseNumber,
      Value<String?> batch,
      Value<String?> doctorId,
      Value<DateTime?> nextDueAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$VaccinationsTableReferences
    extends BaseReferences<_$AppDatabase, $VaccinationsTable, Vaccination> {
  $$VaccinationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DoctorsTable _doctorIdTable(_$AppDatabase db) =>
      db.doctors.createAlias('vaccinations__doctor_id__doctors__id');

  $$DoctorsTableProcessedTableManager? get doctorId {
    final $_column = $_itemColumn<String>('doctor_id');
    if ($_column == null) return null;
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
}

class $$VaccinationsTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vaccine => $composableBuilder(
    column: $table.vaccine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get administeredAt => $composableBuilder(
    column: $table.administeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doseNumber => $composableBuilder(
    column: $table.doseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batch => $composableBuilder(
    column: $table.batch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
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
}

class $$VaccinationsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vaccine => $composableBuilder(
    column: $table.vaccine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get product => $composableBuilder(
    column: $table.product,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get administeredAt => $composableBuilder(
    column: $table.administeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doseNumber => $composableBuilder(
    column: $table.doseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batch => $composableBuilder(
    column: $table.batch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
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

class $$VaccinationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinationsTable> {
  $$VaccinationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vaccine =>
      $composableBuilder(column: $table.vaccine, builder: (column) => column);

  GeneratedColumn<String> get product =>
      $composableBuilder(column: $table.product, builder: (column) => column);

  GeneratedColumn<DateTime> get administeredAt => $composableBuilder(
    column: $table.administeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doseNumber => $composableBuilder(
    column: $table.doseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get batch =>
      $composableBuilder(column: $table.batch, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueAt =>
      $composableBuilder(column: $table.nextDueAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

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
}

class $$VaccinationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaccinationsTable,
          Vaccination,
          $$VaccinationsTableFilterComposer,
          $$VaccinationsTableOrderingComposer,
          $$VaccinationsTableAnnotationComposer,
          $$VaccinationsTableCreateCompanionBuilder,
          $$VaccinationsTableUpdateCompanionBuilder,
          (Vaccination, $$VaccinationsTableReferences),
          Vaccination,
          PrefetchHooks Function({bool doctorId})
        > {
  $$VaccinationsTableTableManager(_$AppDatabase db, $VaccinationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> id = const Value.absent(),
                Value<String> vaccine = const Value.absent(),
                Value<String?> product = const Value.absent(),
                Value<DateTime> administeredAt = const Value.absent(),
                Value<int?> doseNumber = const Value.absent(),
                Value<String?> batch = const Value.absent(),
                Value<String?> doctorId = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaccinationsCompanion(
                archivedAt: archivedAt,
                id: id,
                vaccine: vaccine,
                product: product,
                administeredAt: administeredAt,
                doseNumber: doseNumber,
                batch: batch,
                doctorId: doctorId,
                nextDueAt: nextDueAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<DateTime?> archivedAt = const Value.absent(),
                required String id,
                required String vaccine,
                Value<String?> product = const Value.absent(),
                required DateTime administeredAt,
                Value<int?> doseNumber = const Value.absent(),
                Value<String?> batch = const Value.absent(),
                Value<String?> doctorId = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VaccinationsCompanion.insert(
                archivedAt: archivedAt,
                id: id,
                vaccine: vaccine,
                product: product,
                administeredAt: administeredAt,
                doseNumber: doseNumber,
                batch: batch,
                doctorId: doctorId,
                nextDueAt: nextDueAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VaccinationsTable, Vaccination>(table),
                  $$VaccinationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({doctorId = false}) {
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
                    if (doctorId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.doctorId,
                        referencedTable: $$VaccinationsTableReferences
                            ._doctorIdTable(db),
                        referencedColumn: $$VaccinationsTableReferences
                            ._doctorIdTable(db)
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

typedef $$VaccinationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaccinationsTable,
      Vaccination,
      $$VaccinationsTableFilterComposer,
      $$VaccinationsTableOrderingComposer,
      $$VaccinationsTableAnnotationComposer,
      $$VaccinationsTableCreateCompanionBuilder,
      $$VaccinationsTableUpdateCompanionBuilder,
      (Vaccination, $$VaccinationsTableReferences),
      Vaccination,
      PrefetchHooks Function({bool doctorId})
    >;
typedef $$SymptomMediaTableCreateCompanionBuilder =
    SymptomMediaCompanion Function({
      required String id,
      required String symptomId,
      Value<String?> observationId,
      required MediaKind kind,
      required String mimeType,
      required String localPath,
      Value<int?> durationMs,
      Value<String?> note,
      required DateTime recordedAt,
      Value<int> rowid,
    });
typedef $$SymptomMediaTableUpdateCompanionBuilder =
    SymptomMediaCompanion Function({
      Value<String> id,
      Value<String> symptomId,
      Value<String?> observationId,
      Value<MediaKind> kind,
      Value<String> mimeType,
      Value<String> localPath,
      Value<int?> durationMs,
      Value<String?> note,
      Value<DateTime> recordedAt,
      Value<int> rowid,
    });

final class $$SymptomMediaTableReferences
    extends
        BaseReferences<_$AppDatabase, $SymptomMediaTable, SymptomMediaItem> {
  $$SymptomMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SymptomsTable _symptomIdTable(_$AppDatabase db) =>
      db.symptoms.createAlias('symptom_media__symptom_id__symptoms__id');

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

  static $SymptomObservationsTable _observationIdTable(_$AppDatabase db) => db
      .symptomObservations
      .createAlias('symptom_media__observation_id__symptom_observations__id');

  $$SymptomObservationsTableProcessedTableManager? get observationId {
    final $_column = $_itemColumn<String>('observation_id');
    if ($_column == null) return null;
    final manager = $$SymptomObservationsTableTableManager(
      $_db,
      $_db.symptomObservations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_observationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SymptomMediaTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomMediaTable> {
  $$SymptomMediaTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MediaKind, MediaKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
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

  $$SymptomObservationsTableFilterComposer get observationId {
    final $$SymptomObservationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.observationId,
      referencedTable: $db.symptomObservations,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$SymptomMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomMediaTable> {
  $$SymptomMediaTableOrderingComposer({
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

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
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

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
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

  $$SymptomObservationsTableOrderingComposer get observationId {
    final $$SymptomObservationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.observationId,
          referencedTable: $db.symptomObservations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SymptomObservationsTableOrderingComposer(
                $db: $db,
                $table: $db.symptomObservations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SymptomMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomMediaTable> {
  $$SymptomMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MediaKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

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

  $$SymptomObservationsTableAnnotationComposer get observationId {
    final $$SymptomObservationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.observationId,
          referencedTable: $db.symptomObservations,
          getReferencedColumn: (t) => t.id,
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
    return composer;
  }
}

class $$SymptomMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomMediaTable,
          SymptomMediaItem,
          $$SymptomMediaTableFilterComposer,
          $$SymptomMediaTableOrderingComposer,
          $$SymptomMediaTableAnnotationComposer,
          $$SymptomMediaTableCreateCompanionBuilder,
          $$SymptomMediaTableUpdateCompanionBuilder,
          (SymptomMediaItem, $$SymptomMediaTableReferences),
          SymptomMediaItem,
          PrefetchHooks Function({bool symptomId, bool observationId})
        > {
  $$SymptomMediaTableTableManager(_$AppDatabase db, $SymptomMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> symptomId = const Value.absent(),
                Value<String?> observationId = const Value.absent(),
                Value<MediaKind> kind = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SymptomMediaCompanion(
                id: id,
                symptomId: symptomId,
                observationId: observationId,
                kind: kind,
                mimeType: mimeType,
                localPath: localPath,
                durationMs: durationMs,
                note: note,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String symptomId,
                Value<String?> observationId = const Value.absent(),
                required MediaKind kind,
                required String mimeType,
                required String localPath,
                Value<int?> durationMs = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime recordedAt,
                Value<int> rowid = const Value.absent(),
              }) => SymptomMediaCompanion.insert(
                id: id,
                symptomId: symptomId,
                observationId: observationId,
                kind: kind,
                mimeType: mimeType,
                localPath: localPath,
                durationMs: durationMs,
                note: note,
                recordedAt: recordedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SymptomMediaTable, SymptomMediaItem>(table),
                  $$SymptomMediaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({symptomId = false, observationId = false}) {
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
                        referencedTable: $$SymptomMediaTableReferences
                            ._symptomIdTable(db),
                        referencedColumn: $$SymptomMediaTableReferences
                            ._symptomIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (observationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.observationId,
                        referencedTable: $$SymptomMediaTableReferences
                            ._observationIdTable(db),
                        referencedColumn: $$SymptomMediaTableReferences
                            ._observationIdTable(db)
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

typedef $$SymptomMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomMediaTable,
      SymptomMediaItem,
      $$SymptomMediaTableFilterComposer,
      $$SymptomMediaTableOrderingComposer,
      $$SymptomMediaTableAnnotationComposer,
      $$SymptomMediaTableCreateCompanionBuilder,
      $$SymptomMediaTableUpdateCompanionBuilder,
      (SymptomMediaItem, $$SymptomMediaTableReferences),
      SymptomMediaItem,
      PrefetchHooks Function({bool symptomId, bool observationId})
    >;
typedef $$CycleDaysTableCreateCompanionBuilder = CycleDaysCompanion Function({
  required String day,
  Value<CycleFlow?> flow,
  Value<String?> pbacJson,
  Value<int?> pain,
  Value<String?> painLocations,
  Value<String?> symptoms,
  Value<String?> discharge,
  Value<bool?> painkiller,
  Value<String?> painkillerName,
  Value<bool?> painkillerHelped,
  Value<int?> hotFlashes,
  Value<int?> hotFlashIntensity,
  Value<int?> nightSweats,
  Value<FetalMovement?> fetalMovement,
  Value<double?> weightKg,
  Value<int?> bpSystolic,
  Value<int?> bpDiastolic,
  Value<String?> note,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CycleDaysTableUpdateCompanionBuilder = CycleDaysCompanion Function({
  Value<String> day,
  Value<CycleFlow?> flow,
  Value<String?> pbacJson,
  Value<int?> pain,
  Value<String?> painLocations,
  Value<String?> symptoms,
  Value<String?> discharge,
  Value<bool?> painkiller,
  Value<String?> painkillerName,
  Value<bool?> painkillerHelped,
  Value<int?> hotFlashes,
  Value<int?> hotFlashIntensity,
  Value<int?> nightSweats,
  Value<FetalMovement?> fetalMovement,
  Value<double?> weightKg,
  Value<int?> bpSystolic,
  Value<int?> bpDiastolic,
  Value<String?> note,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CycleDaysTableFilterComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CycleFlow?, CycleFlow, int> get flow =>
      $composableBuilder(
        column: $table.flow,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get pbacJson => $composableBuilder(
    column: $table.pbacJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pain => $composableBuilder(
    column: $table.pain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get painLocations => $composableBuilder(
    column: $table.painLocations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discharge => $composableBuilder(
    column: $table.discharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get painkiller => $composableBuilder(
    column: $table.painkiller,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get painkillerName => $composableBuilder(
    column: $table.painkillerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get painkillerHelped => $composableBuilder(
    column: $table.painkillerHelped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hotFlashes => $composableBuilder(
    column: $table.hotFlashes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hotFlashIntensity => $composableBuilder(
    column: $table.hotFlashIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightSweats => $composableBuilder(
    column: $table.nightSweats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FetalMovement?, FetalMovement, int>
  get fetalMovement => $composableBuilder(
    column: $table.fetalMovement,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CycleDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pbacJson => $composableBuilder(
    column: $table.pbacJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pain => $composableBuilder(
    column: $table.pain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get painLocations => $composableBuilder(
    column: $table.painLocations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discharge => $composableBuilder(
    column: $table.discharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get painkiller => $composableBuilder(
    column: $table.painkiller,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get painkillerName => $composableBuilder(
    column: $table.painkillerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get painkillerHelped => $composableBuilder(
    column: $table.painkillerHelped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hotFlashes => $composableBuilder(
    column: $table.hotFlashes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hotFlashIntensity => $composableBuilder(
    column: $table.hotFlashIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightSweats => $composableBuilder(
    column: $table.nightSweats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetalMovement => $composableBuilder(
    column: $table.fetalMovement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CycleDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleDaysTable> {
  $$CycleDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CycleFlow?, int> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumn<String> get pbacJson =>
      $composableBuilder(column: $table.pbacJson, builder: (column) => column);

  GeneratedColumn<int> get pain =>
      $composableBuilder(column: $table.pain, builder: (column) => column);

  GeneratedColumn<String> get painLocations => $composableBuilder(
    column: $table.painLocations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get discharge =>
      $composableBuilder(column: $table.discharge, builder: (column) => column);

  GeneratedColumn<bool> get painkiller => $composableBuilder(
    column: $table.painkiller,
    builder: (column) => column,
  );

  GeneratedColumn<String> get painkillerName => $composableBuilder(
    column: $table.painkillerName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get painkillerHelped => $composableBuilder(
    column: $table.painkillerHelped,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hotFlashes => $composableBuilder(
    column: $table.hotFlashes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hotFlashIntensity => $composableBuilder(
    column: $table.hotFlashIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightSweats => $composableBuilder(
    column: $table.nightSweats,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FetalMovement?, int> get fetalMovement =>
      $composableBuilder(
        column: $table.fetalMovement,
        builder: (column) => column,
      );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get bpSystolic => $composableBuilder(
    column: $table.bpSystolic,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bpDiastolic => $composableBuilder(
    column: $table.bpDiastolic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CycleDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CycleDaysTable,
          CycleDay,
          $$CycleDaysTableFilterComposer,
          $$CycleDaysTableOrderingComposer,
          $$CycleDaysTableAnnotationComposer,
          $$CycleDaysTableCreateCompanionBuilder,
          $$CycleDaysTableUpdateCompanionBuilder,
          (CycleDay, BaseReferences<_$AppDatabase, $CycleDaysTable, CycleDay>),
          CycleDay,
          PrefetchHooks Function()
        > {
  $$CycleDaysTableTableManager(_$AppDatabase db, $CycleDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<CycleFlow?> flow = const Value.absent(),
                Value<String?> pbacJson = const Value.absent(),
                Value<int?> pain = const Value.absent(),
                Value<String?> painLocations = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> discharge = const Value.absent(),
                Value<bool?> painkiller = const Value.absent(),
                Value<String?> painkillerName = const Value.absent(),
                Value<bool?> painkillerHelped = const Value.absent(),
                Value<int?> hotFlashes = const Value.absent(),
                Value<int?> hotFlashIntensity = const Value.absent(),
                Value<int?> nightSweats = const Value.absent(),
                Value<FetalMovement?> fetalMovement = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> bpSystolic = const Value.absent(),
                Value<int?> bpDiastolic = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CycleDaysCompanion(
                day: day,
                flow: flow,
                pbacJson: pbacJson,
                pain: pain,
                painLocations: painLocations,
                symptoms: symptoms,
                discharge: discharge,
                painkiller: painkiller,
                painkillerName: painkillerName,
                painkillerHelped: painkillerHelped,
                hotFlashes: hotFlashes,
                hotFlashIntensity: hotFlashIntensity,
                nightSweats: nightSweats,
                fetalMovement: fetalMovement,
                weightKg: weightKg,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                Value<CycleFlow?> flow = const Value.absent(),
                Value<String?> pbacJson = const Value.absent(),
                Value<int?> pain = const Value.absent(),
                Value<String?> painLocations = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> discharge = const Value.absent(),
                Value<bool?> painkiller = const Value.absent(),
                Value<String?> painkillerName = const Value.absent(),
                Value<bool?> painkillerHelped = const Value.absent(),
                Value<int?> hotFlashes = const Value.absent(),
                Value<int?> hotFlashIntensity = const Value.absent(),
                Value<int?> nightSweats = const Value.absent(),
                Value<FetalMovement?> fetalMovement = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> bpSystolic = const Value.absent(),
                Value<int?> bpDiastolic = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CycleDaysCompanion.insert(
                day: day,
                flow: flow,
                pbacJson: pbacJson,
                pain: pain,
                painLocations: painLocations,
                symptoms: symptoms,
                discharge: discharge,
                painkiller: painkiller,
                painkillerName: painkillerName,
                painkillerHelped: painkillerHelped,
                hotFlashes: hotFlashes,
                hotFlashIntensity: hotFlashIntensity,
                nightSweats: nightSweats,
                fetalMovement: fetalMovement,
                weightKg: weightKg,
                bpSystolic: bpSystolic,
                bpDiastolic: bpDiastolic,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CycleDaysTable, CycleDay>(table),
                  BaseReferences<_$AppDatabase, $CycleDaysTable, CycleDay>(
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

typedef $$CycleDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CycleDaysTable,
      CycleDay,
      $$CycleDaysTableFilterComposer,
      $$CycleDaysTableOrderingComposer,
      $$CycleDaysTableAnnotationComposer,
      $$CycleDaysTableCreateCompanionBuilder,
      $$CycleDaysTableUpdateCompanionBuilder,
      (CycleDay, BaseReferences<_$AppDatabase, $CycleDaysTable, CycleDay>),
      CycleDay,
      PrefetchHooks Function()
    >;
typedef $$MrsAssessmentsTableCreateCompanionBuilder =
    MrsAssessmentsCompanion Function({
      required String id,
      required DateTime recordedAt,
      required String scores,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MrsAssessmentsTableUpdateCompanionBuilder =
    MrsAssessmentsCompanion Function({
      Value<String> id,
      Value<DateTime> recordedAt,
      Value<String> scores,
      Value<String?> note,
      Value<int> rowid,
    });

class $$MrsAssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $MrsAssessmentsTable> {
  $$MrsAssessmentsTableFilterComposer({
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

  ColumnFilters<String> get scores => $composableBuilder(
    column: $table.scores,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MrsAssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $MrsAssessmentsTable> {
  $$MrsAssessmentsTableOrderingComposer({
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

  ColumnOrderings<String> get scores => $composableBuilder(
    column: $table.scores,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MrsAssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MrsAssessmentsTable> {
  $$MrsAssessmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get scores =>
      $composableBuilder(column: $table.scores, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MrsAssessmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MrsAssessmentsTable,
          MrsAssessment,
          $$MrsAssessmentsTableFilterComposer,
          $$MrsAssessmentsTableOrderingComposer,
          $$MrsAssessmentsTableAnnotationComposer,
          $$MrsAssessmentsTableCreateCompanionBuilder,
          $$MrsAssessmentsTableUpdateCompanionBuilder,
          (
            MrsAssessment,
            BaseReferences<_$AppDatabase, $MrsAssessmentsTable, MrsAssessment>,
          ),
          MrsAssessment,
          PrefetchHooks Function()
        > {
  $$MrsAssessmentsTableTableManager(
    _$AppDatabase db,
    $MrsAssessmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MrsAssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MrsAssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MrsAssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> scores = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MrsAssessmentsCompanion(
                id: id,
                recordedAt: recordedAt,
                scores: scores,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime recordedAt,
                required String scores,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MrsAssessmentsCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                scores: scores,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MrsAssessmentsTable, MrsAssessment>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MrsAssessmentsTable,
                    MrsAssessment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MrsAssessmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MrsAssessmentsTable,
      MrsAssessment,
      $$MrsAssessmentsTableFilterComposer,
      $$MrsAssessmentsTableOrderingComposer,
      $$MrsAssessmentsTableAnnotationComposer,
      $$MrsAssessmentsTableCreateCompanionBuilder,
      $$MrsAssessmentsTableUpdateCompanionBuilder,
      (
        MrsAssessment,
        BaseReferences<_$AppDatabase, $MrsAssessmentsTable, MrsAssessment>,
      ),
      MrsAssessment,
      PrefetchHooks Function()
    >;
typedef $$PregnanciesTableCreateCompanionBuilder =
    PregnanciesCompanion Function({
      required String id,
      Value<String?> lmp,
      Value<String?> dueDate,
      required DateTime createdAt,
      Value<DateTime?> endedAt,
      Value<String?> outcome,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$PregnanciesTableUpdateCompanionBuilder =
    PregnanciesCompanion Function({
      Value<String> id,
      Value<String?> lmp,
      Value<String?> dueDate,
      Value<DateTime> createdAt,
      Value<DateTime?> endedAt,
      Value<String?> outcome,
      Value<String?> note,
      Value<int> rowid,
    });

class $$PregnanciesTableFilterComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableFilterComposer({
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

  ColumnFilters<String> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PregnanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableOrderingComposer({
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

  ColumnOrderings<String> get lmp => $composableBuilder(
    column: $table.lmp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PregnanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lmp =>
      $composableBuilder(column: $table.lmp, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PregnanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PregnanciesTable,
          Pregnancy,
          $$PregnanciesTableFilterComposer,
          $$PregnanciesTableOrderingComposer,
          $$PregnanciesTableAnnotationComposer,
          $$PregnanciesTableCreateCompanionBuilder,
          $$PregnanciesTableUpdateCompanionBuilder,
          (
            Pregnancy,
            BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>,
          ),
          Pregnancy,
          PrefetchHooks Function()
        > {
  $$PregnanciesTableTableManager(_$AppDatabase db, $PregnanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PregnanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PregnanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PregnanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> lmp = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion(
                id: id,
                lmp: lmp,
                dueDate: dueDate,
                createdAt: createdAt,
                endedAt: endedAt,
                outcome: outcome,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> lmp = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PregnanciesCompanion.insert(
                id: id,
                lmp: lmp,
                dueDate: dueDate,
                createdAt: createdAt,
                endedAt: endedAt,
                outcome: outcome,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PregnanciesTable, Pregnancy>(table),
                  BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>(
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

typedef $$PregnanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PregnanciesTable,
      Pregnancy,
      $$PregnanciesTableFilterComposer,
      $$PregnanciesTableOrderingComposer,
      $$PregnanciesTableAnnotationComposer,
      $$PregnanciesTableCreateCompanionBuilder,
      $$PregnanciesTableUpdateCompanionBuilder,
      (Pregnancy, BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>),
      Pregnancy,
      PrefetchHooks Function()
    >;
typedef $$PsychAssessmentsTableCreateCompanionBuilder =
    PsychAssessmentsCompanion Function({
      required String id,
      required DateTime recordedAt,
      required String instrument,
      required String scores,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$PsychAssessmentsTableUpdateCompanionBuilder =
    PsychAssessmentsCompanion Function({
      Value<String> id,
      Value<DateTime> recordedAt,
      Value<String> instrument,
      Value<String> scores,
      Value<String?> note,
      Value<int> rowid,
    });

class $$PsychAssessmentsTableFilterComposer
    extends Composer<_$AppDatabase, $PsychAssessmentsTable> {
  $$PsychAssessmentsTableFilterComposer({
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

  ColumnFilters<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scores => $composableBuilder(
    column: $table.scores,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PsychAssessmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PsychAssessmentsTable> {
  $$PsychAssessmentsTableOrderingComposer({
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

  ColumnOrderings<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scores => $composableBuilder(
    column: $table.scores,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PsychAssessmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PsychAssessmentsTable> {
  $$PsychAssessmentsTableAnnotationComposer({
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

  GeneratedColumn<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scores =>
      $composableBuilder(column: $table.scores, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PsychAssessmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PsychAssessmentsTable,
          PsychAssessment,
          $$PsychAssessmentsTableFilterComposer,
          $$PsychAssessmentsTableOrderingComposer,
          $$PsychAssessmentsTableAnnotationComposer,
          $$PsychAssessmentsTableCreateCompanionBuilder,
          $$PsychAssessmentsTableUpdateCompanionBuilder,
          (
            PsychAssessment,
            BaseReferences<
              _$AppDatabase,
              $PsychAssessmentsTable,
              PsychAssessment
            >,
          ),
          PsychAssessment,
          PrefetchHooks Function()
        > {
  $$PsychAssessmentsTableTableManager(
    _$AppDatabase db,
    $PsychAssessmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PsychAssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PsychAssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PsychAssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> instrument = const Value.absent(),
                Value<String> scores = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PsychAssessmentsCompanion(
                id: id,
                recordedAt: recordedAt,
                instrument: instrument,
                scores: scores,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime recordedAt,
                required String instrument,
                required String scores,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PsychAssessmentsCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                instrument: instrument,
                scores: scores,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PsychAssessmentsTable, PsychAssessment>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PsychAssessmentsTable,
                    PsychAssessment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PsychAssessmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PsychAssessmentsTable,
      PsychAssessment,
      $$PsychAssessmentsTableFilterComposer,
      $$PsychAssessmentsTableOrderingComposer,
      $$PsychAssessmentsTableAnnotationComposer,
      $$PsychAssessmentsTableCreateCompanionBuilder,
      $$PsychAssessmentsTableUpdateCompanionBuilder,
      (
        PsychAssessment,
        BaseReferences<_$AppDatabase, $PsychAssessmentsTable, PsychAssessment>,
      ),
      PsychAssessment,
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
  $$PharmaciesTableTableManager get pharmacies =>
      $$PharmaciesTableTableManager(_db, _db.pharmacies);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$CalendarLinksTableTableManager get calendarLinks =>
      $$CalendarLinksTableTableManager(_db, _db.calendarLinks);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ReminderSymptomsTableTableManager get reminderSymptoms =>
      $$ReminderSymptomsTableTableManager(_db, _db.reminderSymptoms);
  $$DoctorSymptomsTableTableManager get doctorSymptoms =>
      $$DoctorSymptomsTableTableManager(_db, _db.doctorSymptoms);
  $$MedicationSchedulesTableTableManager get medicationSchedules =>
      $$MedicationSchedulesTableTableManager(_db, _db.medicationSchedules);
  $$MedicationIntakesTableTableManager get medicationIntakes =>
      $$MedicationIntakesTableTableManager(_db, _db.medicationIntakes);
  $$VaccinationsTableTableManager get vaccinations =>
      $$VaccinationsTableTableManager(_db, _db.vaccinations);
  $$SymptomMediaTableTableManager get symptomMedia =>
      $$SymptomMediaTableTableManager(_db, _db.symptomMedia);
  $$CycleDaysTableTableManager get cycleDays =>
      $$CycleDaysTableTableManager(_db, _db.cycleDays);
  $$MrsAssessmentsTableTableManager get mrsAssessments =>
      $$MrsAssessmentsTableTableManager(_db, _db.mrsAssessments);
  $$PregnanciesTableTableManager get pregnancies =>
      $$PregnanciesTableTableManager(_db, _db.pregnancies);
  $$PsychAssessmentsTableTableManager get psychAssessments =>
      $$PsychAssessmentsTableTableManager(_db, _db.psychAssessments);
}
