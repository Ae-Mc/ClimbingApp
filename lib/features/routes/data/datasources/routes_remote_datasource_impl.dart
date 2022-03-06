import 'package:climbing_app/core/failure.dart';
import 'package:climbing_app/core/util/handle_dio_connection_error.dart';
import 'package:climbing_app/features/routes/data/datasources/routes_remote_datasource.dart';
import 'package:climbing_app/features/routes/domain/entities/route.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'routes_remote_datasource_impl.g.dart';

@Singleton(as: RoutesRemoteDatasource)
class RoutesRemoteDatasourceImpl implements RoutesRemoteDatasource {
  final RoutesApi api;

  RoutesRemoteDatasourceImpl(this.api);

  @override
  Future<Either<Failure, List<Route>>> allRoutes() async {
    try {
      return Right(await api.routes());
    } on DioError catch (error) {
      return Left(handleDioConnectionError(error).fold<Failure>(
        (l) => l,
        (error) {
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            return ServerFailure(statusCode: statusCode);
          }

          return const UnknownFailure();
        },
      ));
    }
  }
}

@injectable
@RestApi(baseUrl: 'http://192.168.1.56:8000/api/v1/')
abstract class RoutesApi {
  @GET('/routes')
  Future<List<Route>> routes();

  @factoryMethod
  factory RoutesApi(Dio dio) => _RoutesApi(dio);
}
