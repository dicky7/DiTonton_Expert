// Mocks generated by Mockito 5.3.2 from annotations
// in ditonton/test/presentation/pages/tv/tv_on_air_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:ditonton/common/state_enum.dart' as _i5;
import 'package:ditonton/domain/tv/entities/tv.dart' as _i4;
import 'package:ditonton/domain/tv/usecase/get_tv_on_the_air.dart' as _i2;
import 'package:ditonton/presentation/provider/tv/tv_on_air_notifier.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGetTvOnTheAir_0 extends _i1.SmartFake implements _i2.GetTvOnTheAir {
  _FakeGetTvOnTheAir_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TvOnAirNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTvOnAirNotifier extends _i1.Mock implements _i3.TvOnAirNotifier {
  MockTvOnAirNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetTvOnTheAir get getTvOnTheAir => (super.noSuchMethod(
        Invocation.getter(#getTvOnTheAir),
        returnValue: _FakeGetTvOnTheAir_0(
          this,
          Invocation.getter(#getTvOnTheAir),
        ),
      ) as _i2.GetTvOnTheAir);
  @override
  List<_i4.Tv> get tvOnTheAir => (super.noSuchMethod(
        Invocation.getter(#tvOnTheAir),
        returnValue: <_i4.Tv>[],
      ) as List<_i4.Tv>);
  @override
  _i5.RequestState get tvOnTheAirState => (super.noSuchMethod(
        Invocation.getter(#tvOnTheAirState),
        returnValue: _i5.RequestState.Empty,
      ) as _i5.RequestState);
  @override
  String get message => (super.noSuchMethod(
        Invocation.getter(#message),
        returnValue: '',
      ) as String);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<void> fetchTvOnTheAir() => (super.noSuchMethod(
        Invocation.method(
          #fetchTvOnTheAir,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i7.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
