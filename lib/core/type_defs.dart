import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/models/user_model.dart';

typedef FutureEither<T> = Future<Either<Failure,T>>;
typedef FutureVoid = FutureEither<void>;