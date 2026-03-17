// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_users_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminUsersState {

 List<UserEntity> get users; int get totalElements; int get currentPage; int get pageSize; Set<int> get selectedIds;// 👈 <int> 명시
 Map<int, UserEntity> get editedUsers;// 👈 타입 명시
 bool get isLoading; String? get errorMessage; String get searchKeyword; String get selectedGroup; String get selectedType; List<String> get availableGroups; List<String> get availableTypes;
/// Create a copy of AdminUsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUsersStateCopyWith<AdminUsersState> get copyWith => _$AdminUsersStateCopyWithImpl<AdminUsersState>(this as AdminUsersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUsersState&&const DeepCollectionEquality().equals(other.users, users)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds)&&const DeepCollectionEquality().equals(other.editedUsers, editedUsers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchKeyword, searchKeyword) || other.searchKeyword == searchKeyword)&&(identical(other.selectedGroup, selectedGroup) || other.selectedGroup == selectedGroup)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&const DeepCollectionEquality().equals(other.availableGroups, availableGroups)&&const DeepCollectionEquality().equals(other.availableTypes, availableTypes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),totalElements,currentPage,pageSize,const DeepCollectionEquality().hash(selectedIds),const DeepCollectionEquality().hash(editedUsers),isLoading,errorMessage,searchKeyword,selectedGroup,selectedType,const DeepCollectionEquality().hash(availableGroups),const DeepCollectionEquality().hash(availableTypes));

@override
String toString() {
  return 'AdminUsersState(users: $users, totalElements: $totalElements, currentPage: $currentPage, pageSize: $pageSize, selectedIds: $selectedIds, editedUsers: $editedUsers, isLoading: $isLoading, errorMessage: $errorMessage, searchKeyword: $searchKeyword, selectedGroup: $selectedGroup, selectedType: $selectedType, availableGroups: $availableGroups, availableTypes: $availableTypes)';
}


}

/// @nodoc
abstract mixin class $AdminUsersStateCopyWith<$Res>  {
  factory $AdminUsersStateCopyWith(AdminUsersState value, $Res Function(AdminUsersState) _then) = _$AdminUsersStateCopyWithImpl;
@useResult
$Res call({
 List<UserEntity> users, int totalElements, int currentPage, int pageSize, Set<int> selectedIds, Map<int, UserEntity> editedUsers, bool isLoading, String? errorMessage, String searchKeyword, String selectedGroup, String selectedType, List<String> availableGroups, List<String> availableTypes
});




}
/// @nodoc
class _$AdminUsersStateCopyWithImpl<$Res>
    implements $AdminUsersStateCopyWith<$Res> {
  _$AdminUsersStateCopyWithImpl(this._self, this._then);

  final AdminUsersState _self;
  final $Res Function(AdminUsersState) _then;

/// Create a copy of AdminUsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? totalElements = null,Object? currentPage = null,Object? pageSize = null,Object? selectedIds = null,Object? editedUsers = null,Object? isLoading = null,Object? errorMessage = freezed,Object? searchKeyword = null,Object? selectedGroup = null,Object? selectedType = null,Object? availableGroups = null,Object? availableTypes = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<UserEntity>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,editedUsers: null == editedUsers ? _self.editedUsers : editedUsers // ignore: cast_nullable_to_non_nullable
as Map<int, UserEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchKeyword: null == searchKeyword ? _self.searchKeyword : searchKeyword // ignore: cast_nullable_to_non_nullable
as String,selectedGroup: null == selectedGroup ? _self.selectedGroup : selectedGroup // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String,availableGroups: null == availableGroups ? _self.availableGroups : availableGroups // ignore: cast_nullable_to_non_nullable
as List<String>,availableTypes: null == availableTypes ? _self.availableTypes : availableTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUsersState].
extension AdminUsersStatePatterns on AdminUsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUsersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUsersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUsersState value)  $default,){
final _that = this;
switch (_that) {
case _AdminUsersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUsersState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUsersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserEntity> users,  int totalElements,  int currentPage,  int pageSize,  Set<int> selectedIds,  Map<int, UserEntity> editedUsers,  bool isLoading,  String? errorMessage,  String searchKeyword,  String selectedGroup,  String selectedType,  List<String> availableGroups,  List<String> availableTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUsersState() when $default != null:
return $default(_that.users,_that.totalElements,_that.currentPage,_that.pageSize,_that.selectedIds,_that.editedUsers,_that.isLoading,_that.errorMessage,_that.searchKeyword,_that.selectedGroup,_that.selectedType,_that.availableGroups,_that.availableTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserEntity> users,  int totalElements,  int currentPage,  int pageSize,  Set<int> selectedIds,  Map<int, UserEntity> editedUsers,  bool isLoading,  String? errorMessage,  String searchKeyword,  String selectedGroup,  String selectedType,  List<String> availableGroups,  List<String> availableTypes)  $default,) {final _that = this;
switch (_that) {
case _AdminUsersState():
return $default(_that.users,_that.totalElements,_that.currentPage,_that.pageSize,_that.selectedIds,_that.editedUsers,_that.isLoading,_that.errorMessage,_that.searchKeyword,_that.selectedGroup,_that.selectedType,_that.availableGroups,_that.availableTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserEntity> users,  int totalElements,  int currentPage,  int pageSize,  Set<int> selectedIds,  Map<int, UserEntity> editedUsers,  bool isLoading,  String? errorMessage,  String searchKeyword,  String selectedGroup,  String selectedType,  List<String> availableGroups,  List<String> availableTypes)?  $default,) {final _that = this;
switch (_that) {
case _AdminUsersState() when $default != null:
return $default(_that.users,_that.totalElements,_that.currentPage,_that.pageSize,_that.selectedIds,_that.editedUsers,_that.isLoading,_that.errorMessage,_that.searchKeyword,_that.selectedGroup,_that.selectedType,_that.availableGroups,_that.availableTypes);case _:
  return null;

}
}

}

/// @nodoc


class _AdminUsersState implements AdminUsersState {
  const _AdminUsersState({final  List<UserEntity> users = const [], this.totalElements = 0, this.currentPage = 1, this.pageSize = 20, final  Set<int> selectedIds = const <int>{}, final  Map<int, UserEntity> editedUsers = const <int, UserEntity>{}, this.isLoading = true, this.errorMessage, this.searchKeyword = '', this.selectedGroup = '전체', this.selectedType = '전체', final  List<String> availableGroups = const ['전체'], final  List<String> availableTypes = const ['전체']}): _users = users,_selectedIds = selectedIds,_editedUsers = editedUsers,_availableGroups = availableGroups,_availableTypes = availableTypes;
  

 final  List<UserEntity> _users;
@override@JsonKey() List<UserEntity> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

@override@JsonKey() final  int totalElements;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int pageSize;
 final  Set<int> _selectedIds;
@override@JsonKey() Set<int> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

// 👈 <int> 명시
 final  Map<int, UserEntity> _editedUsers;
// 👈 <int> 명시
@override@JsonKey() Map<int, UserEntity> get editedUsers {
  if (_editedUsers is EqualUnmodifiableMapView) return _editedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_editedUsers);
}

// 👈 타입 명시
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override@JsonKey() final  String searchKeyword;
@override@JsonKey() final  String selectedGroup;
@override@JsonKey() final  String selectedType;
 final  List<String> _availableGroups;
@override@JsonKey() List<String> get availableGroups {
  if (_availableGroups is EqualUnmodifiableListView) return _availableGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableGroups);
}

 final  List<String> _availableTypes;
@override@JsonKey() List<String> get availableTypes {
  if (_availableTypes is EqualUnmodifiableListView) return _availableTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableTypes);
}


/// Create a copy of AdminUsersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUsersStateCopyWith<_AdminUsersState> get copyWith => __$AdminUsersStateCopyWithImpl<_AdminUsersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUsersState&&const DeepCollectionEquality().equals(other._users, _users)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&const DeepCollectionEquality().equals(other._editedUsers, _editedUsers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchKeyword, searchKeyword) || other.searchKeyword == searchKeyword)&&(identical(other.selectedGroup, selectedGroup) || other.selectedGroup == selectedGroup)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&const DeepCollectionEquality().equals(other._availableGroups, _availableGroups)&&const DeepCollectionEquality().equals(other._availableTypes, _availableTypes));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),totalElements,currentPage,pageSize,const DeepCollectionEquality().hash(_selectedIds),const DeepCollectionEquality().hash(_editedUsers),isLoading,errorMessage,searchKeyword,selectedGroup,selectedType,const DeepCollectionEquality().hash(_availableGroups),const DeepCollectionEquality().hash(_availableTypes));

@override
String toString() {
  return 'AdminUsersState(users: $users, totalElements: $totalElements, currentPage: $currentPage, pageSize: $pageSize, selectedIds: $selectedIds, editedUsers: $editedUsers, isLoading: $isLoading, errorMessage: $errorMessage, searchKeyword: $searchKeyword, selectedGroup: $selectedGroup, selectedType: $selectedType, availableGroups: $availableGroups, availableTypes: $availableTypes)';
}


}

/// @nodoc
abstract mixin class _$AdminUsersStateCopyWith<$Res> implements $AdminUsersStateCopyWith<$Res> {
  factory _$AdminUsersStateCopyWith(_AdminUsersState value, $Res Function(_AdminUsersState) _then) = __$AdminUsersStateCopyWithImpl;
@override @useResult
$Res call({
 List<UserEntity> users, int totalElements, int currentPage, int pageSize, Set<int> selectedIds, Map<int, UserEntity> editedUsers, bool isLoading, String? errorMessage, String searchKeyword, String selectedGroup, String selectedType, List<String> availableGroups, List<String> availableTypes
});




}
/// @nodoc
class __$AdminUsersStateCopyWithImpl<$Res>
    implements _$AdminUsersStateCopyWith<$Res> {
  __$AdminUsersStateCopyWithImpl(this._self, this._then);

  final _AdminUsersState _self;
  final $Res Function(_AdminUsersState) _then;

/// Create a copy of AdminUsersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? totalElements = null,Object? currentPage = null,Object? pageSize = null,Object? selectedIds = null,Object? editedUsers = null,Object? isLoading = null,Object? errorMessage = freezed,Object? searchKeyword = null,Object? selectedGroup = null,Object? selectedType = null,Object? availableGroups = null,Object? availableTypes = null,}) {
  return _then(_AdminUsersState(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<UserEntity>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<int>,editedUsers: null == editedUsers ? _self._editedUsers : editedUsers // ignore: cast_nullable_to_non_nullable
as Map<int, UserEntity>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchKeyword: null == searchKeyword ? _self.searchKeyword : searchKeyword // ignore: cast_nullable_to_non_nullable
as String,selectedGroup: null == selectedGroup ? _self.selectedGroup : selectedGroup // ignore: cast_nullable_to_non_nullable
as String,selectedType: null == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String,availableGroups: null == availableGroups ? _self._availableGroups : availableGroups // ignore: cast_nullable_to_non_nullable
as List<String>,availableTypes: null == availableTypes ? _self._availableTypes : availableTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
