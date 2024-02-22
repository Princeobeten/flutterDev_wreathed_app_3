import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_3/weather_bloc.dart';
import 'package:weather_app_3/weather_model.dart';
import 'package:weather_app_3/weather_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(WeatherRepo()),
          child: const SearchPage()
        ),
      ),
    );
  }
}



class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
  
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: FlareActor("assets/WorldSpin.flr", fit: BoxFit.contain, animation: "roll",),
            )
        ),

        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state){
            if(state is WeatherIsNotSearched) {
              return Container(
                padding: const EdgeInsets.only(left: 32, right: 32,),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const Center(child: Text("Search Weather", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500, color: Colors.white70),)),
                      const Center(child: Text("Instanly", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200, color: Colors.white70),)),
                      const SizedBox(height: 24,),
                      TextFormField(
                        controller: cityController,
                  
                        decoration: const InputDecoration(
                  
                          prefixIcon: Icon(Icons.search, color: Colors.white70,),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white70,
                                  style: BorderStyle.solid
                              )
                          ),
                  
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  style: BorderStyle.solid
                              )
                          ),
                  
                          hintText: "City Name",
                          hintStyle: TextStyle(color: Colors.white70),
                  
                        ),
                        style: const TextStyle(color: Colors.white70),
                  
                      ),
                  
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ), backgroundColor: Colors.lightBlue,
                          ),
                          child: const Text("Search", style: TextStyle(color: Colors.white70, fontSize: 16),),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if(state is WeatherIsLoading) {
              return const Center(child : CircularProgressIndicator()); 
            }
            else if(state is WeatherIsLoaded) {
              return ShowWeather(state.getWeather, cityController.text);
            }
            else {
              return const Text("Error",style: TextStyle(color: Colors.white),);
            }
          },
        )

      ],
    );
  }
}



class ShowWeather extends StatelessWidget {
  final WeatherModel weather;
  final String cityName;

  const ShowWeather(this.weather, this.cityName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: <Widget>[
          Text(cityName, style: const TextStyle(color: Colors.white70, fontSize: 30, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          Text("${weather.getTemp.round()}C", style: const TextStyle(color: Colors.white70, fontSize: 50),),
          const Text("Temperature", style: TextStyle(color: Colors.white70, fontSize: 14),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("${weather.getMinTemp.round()}C", style: const TextStyle(color: Colors.white70, fontSize: 30),),
                  const Text("Min Temperature", style: TextStyle(color: Colors.white70, fontSize: 14),),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("${weather.getMaxTemp.round()}C", style: const TextStyle(color: Colors.white70, fontSize: 30),),
                  const Text("Max Temperature", style: TextStyle(color: Colors.white70, fontSize: 14),),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text("Search", style: TextStyle(color: Colors.white70, fontSize: 16),),
            ),
          ),
        ],
      ),
    );
  }
}
