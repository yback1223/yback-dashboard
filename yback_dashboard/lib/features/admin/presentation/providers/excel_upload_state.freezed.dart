// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'excel_upload_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExcelUploadState {

 String get groupName; PlatformFile? get selectedFile; bool get isUploading; bool get isSuccess; String? get errorMessage; PlatformFile? get selectedImage;
/// Create a copy of ExcelUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExcelUploadStateCopyWith<ExcelUploadState> get copyWith => _$ExcelUploadStateCopyWithImpl<ExcelUploadState>(this as ExcelUploadState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExcelUploadState&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedImage, selectedImage) || other.selectedImage == selectedImage));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,selectedFile,isUploading,isSuccess,errorMessage,selectedImage);

@override
String toString() {
  return 'ExcelUploadState(groupName: $groupName, selectedFile: $selectedFile, isUploading: $isUploading, isSuccess: $isSuccess, errorMessage: $errorMessage, selectedImage: $selectedImage)';
}


}

/// @nodoc
abstract mixin class $ExcelUploadStateCopyWith<$Res>  {
  factory $ExcelUploadStateCopyWith(ExcelUploadState value, $Res Function(ExcelUploadState) _then) = _$ExcelUploadStateCopyWithImpl;
@useResult
$Res call({
 String groupName, PlatformFile? selectedFile, bool isUploading, bool isSuccess, String? errorMessage, PlatformFile? selectedImage
});




}
/// @nodoc
class _$ExcelUploadStateCopyWithImpl<$Res>
    implements $ExcelUploadStateCopyWith<$Res> {
  _$ExcelUploadStateCopyWithImpl(this._self, this._then);

  final ExcelUploadState _self;
  final $Res Function(ExcelUploadState) _then;

/// Create a copy of ExcelUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupName = null,Object? selectedFile = freezed,Object? isUploading = null,Object? isSuccess = null,Object? errorMessage = freezed,Object? selectedImage = freezed,}) {
  return _then(_self.copyWith(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedImage: freezed == selectedImage ? _self.selectedImage : selectedImage // ignore: cast_nullable_to_non_nullable
as PlatformFile?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExcelUploadState].
extension ExcelUploadStatePatterns on ExcelUploadState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExcelUploadState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExcelUploadState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExcelUploadState value)  $default,){
final _that = this;
switch (_that) {
case _ExcelUploadState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExcelUploadState value)?  $default,){
final _that = this;
switch (_that) {
case _ExcelUploadState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groupName,  PlatformFile? selectedFile,  bool isUploading,  bool isSuccess,  String? errorMessage,  PlatformFile? selectedImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExcelUploadState() when $default != null:
return $default(_that.groupName,_that.selectedFile,_that.isUploading,_that.isSuccess,_that.errorMessage,_that.selectedImage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groupName,  PlatformFile? selectedFile,  bool isUploading,  bool isSuccess,  String? errorMessage,  PlatformFile? selectedImage)  $default,) {final _that = this;
switch (_that) {
case _ExcelUploadState():
return $default(_that.groupName,_that.selectedFile,_that.isUploading,_that.isSuccess,_that.errorMessage,_that.selectedImage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groupName,  PlatformFile? selectedFile,  bool isUploading,  bool isSuccess,  String? errorMessage,  PlatformFile? selectedImage)?  $default,) {final _that = this;
switch (_that) {
case _ExcelUploadState() when $default != null:
return $default(_that.groupName,_that.selectedFile,_that.isUploading,_that.isSuccess,_that.errorMessage,_that.selectedImage);case _:
  return null;

}
}

}

/// @nodoc


class _ExcelUploadState implements ExcelUploadState {
  const _ExcelUploadState({this.groupName = '', this.selectedFile = null, this.isUploading = false, this.isSuccess = false, this.errorMessage = null, this.selectedImage = null});
  

@override@JsonKey() final  String groupName;
@override@JsonKey() final  PlatformFile? selectedFile;
@override@JsonKey() final  bool isUploading;
@override@JsonKey() final  bool isSuccess;
@override@JsonKey() final  String? errorMessage;
@override@JsonKey() final  PlatformFile? selectedImage;

/// Create a copy of ExcelUploadState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExcelUploadStateCopyWith<_ExcelUploadState> get copyWith => __$ExcelUploadStateCopyWithImpl<_ExcelUploadState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExcelUploadState&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.selectedFile, selectedFile) || other.selectedFile == selectedFile)&&(identical(other.isUploading, isUploading) || other.isUploading == isUploading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedImage, selectedImage) || other.selectedImage == selectedImage));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,selectedFile,isUploading,isSuccess,errorMessage,selectedImage);

@override
String toString() {
  return 'ExcelUploadState(groupName: $groupName, selectedFile: $selectedFile, isUploading: $isUploading, isSuccess: $isSuccess, errorMessage: $errorMessage, selectedImage: $selectedImage)';
}


}

/// @nodoc
abstract mixin class _$ExcelUploadStateCopyWith<$Res> implements $ExcelUploadStateCopyWith<$Res> {
  factory _$ExcelUploadStateCopyWith(_ExcelUploadState value, $Res Function(_ExcelUploadState) _then) = __$ExcelUploadStateCopyWithImpl;
@override @useResult
$Res call({
 String groupName, PlatformFile? selectedFile, bool isUploading, bool isSuccess, String? errorMessage, PlatformFile? selectedImage
});




}
/// @nodoc
class __$ExcelUploadStateCopyWithImpl<$Res>
    implements _$ExcelUploadStateCopyWith<$Res> {
  __$ExcelUploadStateCopyWithImpl(this._self, this._then);

  final _ExcelUploadState _self;
  final $Res Function(_ExcelUploadState) _then;

/// Create a copy of ExcelUploadState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupName = null,Object? selectedFile = freezed,Object? isUploading = null,Object? isSuccess = null,Object? errorMessage = freezed,Object? selectedImage = freezed,}) {
  return _then(_ExcelUploadState(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,selectedFile: freezed == selectedFile ? _self.selectedFile : selectedFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploading: null == isUploading ? _self.isUploading : isUploading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedImage: freezed == selectedImage ? _self.selectedImage : selectedImage // ignore: cast_nullable_to_non_nullable
as PlatformFile?,
  ));
}


}

// dart format on
