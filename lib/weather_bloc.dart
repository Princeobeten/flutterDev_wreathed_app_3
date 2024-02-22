import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app_3/weather_model.dart';
import 'package:weather_app_3/weather_repo.dart';

class WeatherEvent extends Equatable{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class FetchWeather extends WeatherEvent {
  final String _cityName;

  FetchWeather(this._cityName);

  @override
  List<Object> get props => [_cityName];
}

class ResetWeather extends WeatherEvent{

}

class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}


class WeatherIsNotSearched extends WeatherState{

}

class WeatherIsLoading extends WeatherState{

}

class WeatherIsLoaded extends WeatherState {
  final WeatherModel _weather;

  WeatherIsLoaded(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState{

}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo) : super(WeatherIsNotSearched());

  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield* _mapFetchWeatherToState(event);
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearched();
    }
  }

  Stream<WeatherState> _mapFetchWeatherToState(FetchWeather event) async* {
    yield WeatherIsLoading();
    try {
      WeatherModel weather = await weatherRepo.getWeather(event._cityName);
      yield WeatherIsLoaded(weather);
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
      yield WeatherIsNotLoaded();
    }
  }
}
