import 'package:equatable/equatable.dart';
import 'exceptions.dart';

/// Result pattern for error handling
abstract class Result<T> extends Equatable {
  const Result();

  /// Success result
  const factory Result.success(T data) = Success<T>;

  /// Failure result
  const factory Result.failure(AppException exception) = Failure<T>;

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get data => isSuccess ? (this as Success<T>).value : null;

  /// Get exception if failure, null otherwise
  AppException? get exception =>
      isFailure ? (this as Failure<T>).exception : null;

  /// Transform success data
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform(data!));
      } catch (e) {
        return Result.failure(BusinessException(message: e.toString()));
      }
    }
    return Result.failure(exception!);
  }

  /// Handle both success and failure cases
  R fold<R>(
    R Function(AppException exception) onFailure,
    R Function(T data) onSuccess,
  ) {
    if (isSuccess) {
      return onSuccess(data!);
    }
    return onFailure(exception!);
  }
}

/// Success result implementation
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];
}

/// Failure result implementation
class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);

  @override
  List<Object?> get props => [exception];
}
