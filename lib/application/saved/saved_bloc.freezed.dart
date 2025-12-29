// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SavedEvent {
  String get profileName => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LocalStoreVideoInfo videoInfo, String profileName)
        addVideoInfo,
    required TResult Function(String id, String profileName) deleteVideoInfo,
    required TResult Function(String profileName) getAllVideoInfoList,
    required TResult Function(String id, String profileName) checkVideoInfo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult? Function(String id, String profileName)? deleteVideoInfo,
    TResult? Function(String profileName)? getAllVideoInfoList,
    TResult? Function(String id, String profileName)? checkVideoInfo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult Function(String id, String profileName)? deleteVideoInfo,
    TResult Function(String profileName)? getAllVideoInfoList,
    TResult Function(String id, String profileName)? checkVideoInfo,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddVideoInfo value) addVideoInfo,
    required TResult Function(DeleteVideoInfo value) deleteVideoInfo,
    required TResult Function(GetAllVideoInfoList value) getAllVideoInfoList,
    required TResult Function(CheckVideoInfo value) checkVideoInfo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddVideoInfo value)? addVideoInfo,
    TResult? Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult? Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult? Function(CheckVideoInfo value)? checkVideoInfo,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddVideoInfo value)? addVideoInfo,
    TResult Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult Function(CheckVideoInfo value)? checkVideoInfo,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedEventCopyWith<SavedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedEventCopyWith<$Res> {
  factory $SavedEventCopyWith(
          SavedEvent value, $Res Function(SavedEvent) then) =
      _$SavedEventCopyWithImpl<$Res, SavedEvent>;
  @useResult
  $Res call({String profileName});
}

/// @nodoc
class _$SavedEventCopyWithImpl<$Res, $Val extends SavedEvent>
    implements $SavedEventCopyWith<$Res> {
  _$SavedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileName = null,
  }) {
    return _then(_value.copyWith(
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddVideoInfoImplCopyWith<$Res>
    implements $SavedEventCopyWith<$Res> {
  factory _$$AddVideoInfoImplCopyWith(
          _$AddVideoInfoImpl value, $Res Function(_$AddVideoInfoImpl) then) =
      __$$AddVideoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LocalStoreVideoInfo videoInfo, String profileName});
}

/// @nodoc
class __$$AddVideoInfoImplCopyWithImpl<$Res>
    extends _$SavedEventCopyWithImpl<$Res, _$AddVideoInfoImpl>
    implements _$$AddVideoInfoImplCopyWith<$Res> {
  __$$AddVideoInfoImplCopyWithImpl(
      _$AddVideoInfoImpl _value, $Res Function(_$AddVideoInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoInfo = null,
    Object? profileName = null,
  }) {
    return _then(_$AddVideoInfoImpl(
      videoInfo: null == videoInfo
          ? _value.videoInfo
          : videoInfo // ignore: cast_nullable_to_non_nullable
              as LocalStoreVideoInfo,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddVideoInfoImpl implements AddVideoInfo {
  const _$AddVideoInfoImpl(
      {required this.videoInfo, this.profileName = 'default'});

  @override
  final LocalStoreVideoInfo videoInfo;
  @override
  @JsonKey()
  final String profileName;

  @override
  String toString() {
    return 'SavedEvent.addVideoInfo(videoInfo: $videoInfo, profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddVideoInfoImpl &&
            (identical(other.videoInfo, videoInfo) ||
                other.videoInfo == videoInfo) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, videoInfo, profileName);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddVideoInfoImplCopyWith<_$AddVideoInfoImpl> get copyWith =>
      __$$AddVideoInfoImplCopyWithImpl<_$AddVideoInfoImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LocalStoreVideoInfo videoInfo, String profileName)
        addVideoInfo,
    required TResult Function(String id, String profileName) deleteVideoInfo,
    required TResult Function(String profileName) getAllVideoInfoList,
    required TResult Function(String id, String profileName) checkVideoInfo,
  }) {
    return addVideoInfo(videoInfo, profileName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult? Function(String id, String profileName)? deleteVideoInfo,
    TResult? Function(String profileName)? getAllVideoInfoList,
    TResult? Function(String id, String profileName)? checkVideoInfo,
  }) {
    return addVideoInfo?.call(videoInfo, profileName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult Function(String id, String profileName)? deleteVideoInfo,
    TResult Function(String profileName)? getAllVideoInfoList,
    TResult Function(String id, String profileName)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (addVideoInfo != null) {
      return addVideoInfo(videoInfo, profileName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddVideoInfo value) addVideoInfo,
    required TResult Function(DeleteVideoInfo value) deleteVideoInfo,
    required TResult Function(GetAllVideoInfoList value) getAllVideoInfoList,
    required TResult Function(CheckVideoInfo value) checkVideoInfo,
  }) {
    return addVideoInfo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddVideoInfo value)? addVideoInfo,
    TResult? Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult? Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult? Function(CheckVideoInfo value)? checkVideoInfo,
  }) {
    return addVideoInfo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddVideoInfo value)? addVideoInfo,
    TResult Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult Function(CheckVideoInfo value)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (addVideoInfo != null) {
      return addVideoInfo(this);
    }
    return orElse();
  }
}

abstract class AddVideoInfo implements SavedEvent {
  const factory AddVideoInfo(
      {required final LocalStoreVideoInfo videoInfo,
      final String profileName}) = _$AddVideoInfoImpl;

  LocalStoreVideoInfo get videoInfo;
  @override
  String get profileName;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddVideoInfoImplCopyWith<_$AddVideoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteVideoInfoImplCopyWith<$Res>
    implements $SavedEventCopyWith<$Res> {
  factory _$$DeleteVideoInfoImplCopyWith(_$DeleteVideoInfoImpl value,
          $Res Function(_$DeleteVideoInfoImpl) then) =
      __$$DeleteVideoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileName});
}

/// @nodoc
class __$$DeleteVideoInfoImplCopyWithImpl<$Res>
    extends _$SavedEventCopyWithImpl<$Res, _$DeleteVideoInfoImpl>
    implements _$$DeleteVideoInfoImplCopyWith<$Res> {
  __$$DeleteVideoInfoImplCopyWithImpl(
      _$DeleteVideoInfoImpl _value, $Res Function(_$DeleteVideoInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileName = null,
  }) {
    return _then(_$DeleteVideoInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteVideoInfoImpl implements DeleteVideoInfo {
  const _$DeleteVideoInfoImpl({required this.id, this.profileName = 'default'});

  @override
  final String id;
  @override
  @JsonKey()
  final String profileName;

  @override
  String toString() {
    return 'SavedEvent.deleteVideoInfo(id: $id, profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteVideoInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileName);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteVideoInfoImplCopyWith<_$DeleteVideoInfoImpl> get copyWith =>
      __$$DeleteVideoInfoImplCopyWithImpl<_$DeleteVideoInfoImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LocalStoreVideoInfo videoInfo, String profileName)
        addVideoInfo,
    required TResult Function(String id, String profileName) deleteVideoInfo,
    required TResult Function(String profileName) getAllVideoInfoList,
    required TResult Function(String id, String profileName) checkVideoInfo,
  }) {
    return deleteVideoInfo(id, profileName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult? Function(String id, String profileName)? deleteVideoInfo,
    TResult? Function(String profileName)? getAllVideoInfoList,
    TResult? Function(String id, String profileName)? checkVideoInfo,
  }) {
    return deleteVideoInfo?.call(id, profileName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult Function(String id, String profileName)? deleteVideoInfo,
    TResult Function(String profileName)? getAllVideoInfoList,
    TResult Function(String id, String profileName)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (deleteVideoInfo != null) {
      return deleteVideoInfo(id, profileName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddVideoInfo value) addVideoInfo,
    required TResult Function(DeleteVideoInfo value) deleteVideoInfo,
    required TResult Function(GetAllVideoInfoList value) getAllVideoInfoList,
    required TResult Function(CheckVideoInfo value) checkVideoInfo,
  }) {
    return deleteVideoInfo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddVideoInfo value)? addVideoInfo,
    TResult? Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult? Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult? Function(CheckVideoInfo value)? checkVideoInfo,
  }) {
    return deleteVideoInfo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddVideoInfo value)? addVideoInfo,
    TResult Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult Function(CheckVideoInfo value)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (deleteVideoInfo != null) {
      return deleteVideoInfo(this);
    }
    return orElse();
  }
}

abstract class DeleteVideoInfo implements SavedEvent {
  const factory DeleteVideoInfo(
      {required final String id,
      final String profileName}) = _$DeleteVideoInfoImpl;

  String get id;
  @override
  String get profileName;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteVideoInfoImplCopyWith<_$DeleteVideoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetAllVideoInfoListImplCopyWith<$Res>
    implements $SavedEventCopyWith<$Res> {
  factory _$$GetAllVideoInfoListImplCopyWith(_$GetAllVideoInfoListImpl value,
          $Res Function(_$GetAllVideoInfoListImpl) then) =
      __$$GetAllVideoInfoListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileName});
}

/// @nodoc
class __$$GetAllVideoInfoListImplCopyWithImpl<$Res>
    extends _$SavedEventCopyWithImpl<$Res, _$GetAllVideoInfoListImpl>
    implements _$$GetAllVideoInfoListImplCopyWith<$Res> {
  __$$GetAllVideoInfoListImplCopyWithImpl(_$GetAllVideoInfoListImpl _value,
      $Res Function(_$GetAllVideoInfoListImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileName = null,
  }) {
    return _then(_$GetAllVideoInfoListImpl(
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GetAllVideoInfoListImpl implements GetAllVideoInfoList {
  const _$GetAllVideoInfoListImpl({this.profileName = 'default'});

  @override
  @JsonKey()
  final String profileName;

  @override
  String toString() {
    return 'SavedEvent.getAllVideoInfoList(profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAllVideoInfoListImpl &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profileName);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetAllVideoInfoListImplCopyWith<_$GetAllVideoInfoListImpl> get copyWith =>
      __$$GetAllVideoInfoListImplCopyWithImpl<_$GetAllVideoInfoListImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LocalStoreVideoInfo videoInfo, String profileName)
        addVideoInfo,
    required TResult Function(String id, String profileName) deleteVideoInfo,
    required TResult Function(String profileName) getAllVideoInfoList,
    required TResult Function(String id, String profileName) checkVideoInfo,
  }) {
    return getAllVideoInfoList(profileName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult? Function(String id, String profileName)? deleteVideoInfo,
    TResult? Function(String profileName)? getAllVideoInfoList,
    TResult? Function(String id, String profileName)? checkVideoInfo,
  }) {
    return getAllVideoInfoList?.call(profileName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult Function(String id, String profileName)? deleteVideoInfo,
    TResult Function(String profileName)? getAllVideoInfoList,
    TResult Function(String id, String profileName)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (getAllVideoInfoList != null) {
      return getAllVideoInfoList(profileName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddVideoInfo value) addVideoInfo,
    required TResult Function(DeleteVideoInfo value) deleteVideoInfo,
    required TResult Function(GetAllVideoInfoList value) getAllVideoInfoList,
    required TResult Function(CheckVideoInfo value) checkVideoInfo,
  }) {
    return getAllVideoInfoList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddVideoInfo value)? addVideoInfo,
    TResult? Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult? Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult? Function(CheckVideoInfo value)? checkVideoInfo,
  }) {
    return getAllVideoInfoList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddVideoInfo value)? addVideoInfo,
    TResult Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult Function(CheckVideoInfo value)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (getAllVideoInfoList != null) {
      return getAllVideoInfoList(this);
    }
    return orElse();
  }
}

abstract class GetAllVideoInfoList implements SavedEvent {
  const factory GetAllVideoInfoList({final String profileName}) =
      _$GetAllVideoInfoListImpl;

  @override
  String get profileName;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetAllVideoInfoListImplCopyWith<_$GetAllVideoInfoListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckVideoInfoImplCopyWith<$Res>
    implements $SavedEventCopyWith<$Res> {
  factory _$$CheckVideoInfoImplCopyWith(_$CheckVideoInfoImpl value,
          $Res Function(_$CheckVideoInfoImpl) then) =
      __$$CheckVideoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String profileName});
}

/// @nodoc
class __$$CheckVideoInfoImplCopyWithImpl<$Res>
    extends _$SavedEventCopyWithImpl<$Res, _$CheckVideoInfoImpl>
    implements _$$CheckVideoInfoImplCopyWith<$Res> {
  __$$CheckVideoInfoImplCopyWithImpl(
      _$CheckVideoInfoImpl _value, $Res Function(_$CheckVideoInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profileName = null,
  }) {
    return _then(_$CheckVideoInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CheckVideoInfoImpl implements CheckVideoInfo {
  const _$CheckVideoInfoImpl({required this.id, this.profileName = 'default'});

  @override
  final String id;
  @override
  @JsonKey()
  final String profileName;

  @override
  String toString() {
    return 'SavedEvent.checkVideoInfo(id: $id, profileName: $profileName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckVideoInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, profileName);

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckVideoInfoImplCopyWith<_$CheckVideoInfoImpl> get copyWith =>
      __$$CheckVideoInfoImplCopyWithImpl<_$CheckVideoInfoImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(LocalStoreVideoInfo videoInfo, String profileName)
        addVideoInfo,
    required TResult Function(String id, String profileName) deleteVideoInfo,
    required TResult Function(String profileName) getAllVideoInfoList,
    required TResult Function(String id, String profileName) checkVideoInfo,
  }) {
    return checkVideoInfo(id, profileName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult? Function(String id, String profileName)? deleteVideoInfo,
    TResult? Function(String profileName)? getAllVideoInfoList,
    TResult? Function(String id, String profileName)? checkVideoInfo,
  }) {
    return checkVideoInfo?.call(id, profileName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(LocalStoreVideoInfo videoInfo, String profileName)?
        addVideoInfo,
    TResult Function(String id, String profileName)? deleteVideoInfo,
    TResult Function(String profileName)? getAllVideoInfoList,
    TResult Function(String id, String profileName)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (checkVideoInfo != null) {
      return checkVideoInfo(id, profileName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddVideoInfo value) addVideoInfo,
    required TResult Function(DeleteVideoInfo value) deleteVideoInfo,
    required TResult Function(GetAllVideoInfoList value) getAllVideoInfoList,
    required TResult Function(CheckVideoInfo value) checkVideoInfo,
  }) {
    return checkVideoInfo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddVideoInfo value)? addVideoInfo,
    TResult? Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult? Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult? Function(CheckVideoInfo value)? checkVideoInfo,
  }) {
    return checkVideoInfo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddVideoInfo value)? addVideoInfo,
    TResult Function(DeleteVideoInfo value)? deleteVideoInfo,
    TResult Function(GetAllVideoInfoList value)? getAllVideoInfoList,
    TResult Function(CheckVideoInfo value)? checkVideoInfo,
    required TResult orElse(),
  }) {
    if (checkVideoInfo != null) {
      return checkVideoInfo(this);
    }
    return orElse();
  }
}

abstract class CheckVideoInfo implements SavedEvent {
  const factory CheckVideoInfo(
      {required final String id,
      final String profileName}) = _$CheckVideoInfoImpl;

  String get id;
  @override
  String get profileName;

  /// Create a copy of SavedEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckVideoInfoImplCopyWith<_$CheckVideoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SavedState {
  ApiStatus get savedVideosFetchStatus => throw _privateConstructorUsedError;
  LocalStoreVideoInfo? get videoInfo => throw _privateConstructorUsedError;
  List<LocalStoreVideoInfo> get localSavedVideos =>
      throw _privateConstructorUsedError;
  List<LocalStoreVideoInfo> get localSavedHistoryVideos =>
      throw _privateConstructorUsedError;

  /// Create a copy of SavedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedStateCopyWith<SavedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedStateCopyWith<$Res> {
  factory $SavedStateCopyWith(
          SavedState value, $Res Function(SavedState) then) =
      _$SavedStateCopyWithImpl<$Res, SavedState>;
  @useResult
  $Res call(
      {ApiStatus savedVideosFetchStatus,
      LocalStoreVideoInfo? videoInfo,
      List<LocalStoreVideoInfo> localSavedVideos,
      List<LocalStoreVideoInfo> localSavedHistoryVideos});
}

/// @nodoc
class _$SavedStateCopyWithImpl<$Res, $Val extends SavedState>
    implements $SavedStateCopyWith<$Res> {
  _$SavedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedVideosFetchStatus = null,
    Object? videoInfo = freezed,
    Object? localSavedVideos = null,
    Object? localSavedHistoryVideos = null,
  }) {
    return _then(_value.copyWith(
      savedVideosFetchStatus: null == savedVideosFetchStatus
          ? _value.savedVideosFetchStatus
          : savedVideosFetchStatus // ignore: cast_nullable_to_non_nullable
              as ApiStatus,
      videoInfo: freezed == videoInfo
          ? _value.videoInfo
          : videoInfo // ignore: cast_nullable_to_non_nullable
              as LocalStoreVideoInfo?,
      localSavedVideos: null == localSavedVideos
          ? _value.localSavedVideos
          : localSavedVideos // ignore: cast_nullable_to_non_nullable
              as List<LocalStoreVideoInfo>,
      localSavedHistoryVideos: null == localSavedHistoryVideos
          ? _value.localSavedHistoryVideos
          : localSavedHistoryVideos // ignore: cast_nullable_to_non_nullable
              as List<LocalStoreVideoInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res>
    implements $SavedStateCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ApiStatus savedVideosFetchStatus,
      LocalStoreVideoInfo? videoInfo,
      List<LocalStoreVideoInfo> localSavedVideos,
      List<LocalStoreVideoInfo> localSavedHistoryVideos});
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$SavedStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedVideosFetchStatus = null,
    Object? videoInfo = freezed,
    Object? localSavedVideos = null,
    Object? localSavedHistoryVideos = null,
  }) {
    return _then(_$InitialImpl(
      savedVideosFetchStatus: null == savedVideosFetchStatus
          ? _value.savedVideosFetchStatus
          : savedVideosFetchStatus // ignore: cast_nullable_to_non_nullable
              as ApiStatus,
      videoInfo: freezed == videoInfo
          ? _value.videoInfo
          : videoInfo // ignore: cast_nullable_to_non_nullable
              as LocalStoreVideoInfo?,
      localSavedVideos: null == localSavedVideos
          ? _value._localSavedVideos
          : localSavedVideos // ignore: cast_nullable_to_non_nullable
              as List<LocalStoreVideoInfo>,
      localSavedHistoryVideos: null == localSavedHistoryVideos
          ? _value._localSavedHistoryVideos
          : localSavedHistoryVideos // ignore: cast_nullable_to_non_nullable
              as List<LocalStoreVideoInfo>,
    ));
  }
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl(
      {required this.savedVideosFetchStatus,
      required this.videoInfo,
      required final List<LocalStoreVideoInfo> localSavedVideos,
      required final List<LocalStoreVideoInfo> localSavedHistoryVideos})
      : _localSavedVideos = localSavedVideos,
        _localSavedHistoryVideos = localSavedHistoryVideos;

  @override
  final ApiStatus savedVideosFetchStatus;
  @override
  final LocalStoreVideoInfo? videoInfo;
  final List<LocalStoreVideoInfo> _localSavedVideos;
  @override
  List<LocalStoreVideoInfo> get localSavedVideos {
    if (_localSavedVideos is EqualUnmodifiableListView)
      return _localSavedVideos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localSavedVideos);
  }

  final List<LocalStoreVideoInfo> _localSavedHistoryVideos;
  @override
  List<LocalStoreVideoInfo> get localSavedHistoryVideos {
    if (_localSavedHistoryVideos is EqualUnmodifiableListView)
      return _localSavedHistoryVideos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localSavedHistoryVideos);
  }

  @override
  String toString() {
    return 'SavedState(savedVideosFetchStatus: $savedVideosFetchStatus, videoInfo: $videoInfo, localSavedVideos: $localSavedVideos, localSavedHistoryVideos: $localSavedHistoryVideos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialImpl &&
            (identical(other.savedVideosFetchStatus, savedVideosFetchStatus) ||
                other.savedVideosFetchStatus == savedVideosFetchStatus) &&
            (identical(other.videoInfo, videoInfo) ||
                other.videoInfo == videoInfo) &&
            const DeepCollectionEquality()
                .equals(other._localSavedVideos, _localSavedVideos) &&
            const DeepCollectionEquality().equals(
                other._localSavedHistoryVideos, _localSavedHistoryVideos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      savedVideosFetchStatus,
      videoInfo,
      const DeepCollectionEquality().hash(_localSavedVideos),
      const DeepCollectionEquality().hash(_localSavedHistoryVideos));

  /// Create a copy of SavedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      __$$InitialImplCopyWithImpl<_$InitialImpl>(this, _$identity);
}

abstract class _Initial implements SavedState {
  const factory _Initial(
          {required final ApiStatus savedVideosFetchStatus,
          required final LocalStoreVideoInfo? videoInfo,
          required final List<LocalStoreVideoInfo> localSavedVideos,
          required final List<LocalStoreVideoInfo> localSavedHistoryVideos}) =
      _$InitialImpl;

  @override
  ApiStatus get savedVideosFetchStatus;
  @override
  LocalStoreVideoInfo? get videoInfo;
  @override
  List<LocalStoreVideoInfo> get localSavedVideos;
  @override
  List<LocalStoreVideoInfo> get localSavedHistoryVideos;

  /// Create a copy of SavedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialImplCopyWith<_$InitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
