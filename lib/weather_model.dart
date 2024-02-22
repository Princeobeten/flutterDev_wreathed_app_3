class WeatherModel {
  final temp;
  final temp_min; 
  final temp_max;
  final pressure;
  final humidity;

  double get getTemp => temp-272.5;
  double get getMaxTemp => temp_max-272.5; 
  double get getMinTemp => temp_min-272.5;

  WeatherModel(this.temp, this.temp_min, this.temp_max, this.pressure, this.humidity);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(json["temp"], json['temp_min'], json['temp_max'], json['pressure'], json['humidity']);
  }
}