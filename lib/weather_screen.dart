
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
        String cityName = 'Lagos';
        final res = await http.get(
          Uri.parse(
              'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey', 
          ),
        );
        final data = jsonDecode(res.body);
        if (data['cod'] != '200'){
          throw 'an unexpected error occured';
        }

        return data;
    }catch(e){
      throw e.toString();
    }
  }
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('weather app', style: TextStyle(fontWeight: FontWeight.w800),),
            centerTitle: true,
            actions:[
                IconButton( 
                  onPressed: () {
                    setState(() {
                      weather = getCurrentWeather();
                    });
                  }, 
                  icon: const Icon(Icons.refresh),
                ), 
            ],
      ),

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator.adaptive());
          }

          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final mData = snapshot.data!;
          final currentWeatherData = mData['list'][0];
          final double currentTemp = currentWeatherData['main']['temp'] - 273;
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpd = currentWeatherData['wind']['speed'];
          

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 13,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child:    Padding(
                          padding:  const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // SizedBox(height: 16),
                              Text('${currentTemp !=0 ? currentTemp.toStringAsFixed(2) : currentTemp.toStringAsFixed(0)}°C', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),),
                              const SizedBox(height: 18),
                              Icon(currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud_rounded : Icons.sunny, size: 64,),
                              const SizedBox(height: 18),
                               Text(currentSky, style: const TextStyle(fontSize: 22),),
                              // SizedBox(height: 16),
                          
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 20,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child:  Text(
                    'Hourly Forecast', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ), 
                  ),
            
                // weather forecast cards
                const SizedBox(height: 20,),
                //   SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //        child: Row(
                //         children: [
                //           for(int i=0; i<5; i++) 
                //           HourlyForecastItem(timeStamp: mData['list'][i+1]['dt'].toString(), 
                //           icon: mData['list'][i+1]['main'] == 'Clouds' || mData['list'][i+1]['main'] == 'Rain' ?  Icons.cloud : Icons.sunny, 
                //           temp:  mData['list'][i+1]['main']['temp']-273.toDouble()
                //           ),

                //           ],
                //        ),
                //  ),
                SizedBox(
                  height: 125,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index){
                    final hourlyForecast = mData['list'][index + 1];  
                    final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        icon: hourlyForecast['main'] == 'Clouds' ||hourlyForecast['main'] == 'Rain' ?  Icons.cloud : Icons.sunny, 
                        timeStamp: DateFormat.jm().format(time), 
                        temp: hourlyForecast['main']['temp']-273.toDouble()
                        );
                    }
                  
                  ),
                ),
                 //Additinal info starts
                 const SizedBox(height: 20,),
                 const Align(
                  alignment: Alignment.centerLeft,
                  child:  Text(
                    'Additional Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ), 
                  ),
                   Container(
                    padding: const EdgeInsets.all(8.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.water_drop_rounded, size: 34,),
                            const SizedBox(height: 8,),
                            const Text('humidity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                            const SizedBox(height: 8,),
                             Text(currentHumidity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                           ],
                          ),
                          
                          Column(
                          children: [
                            const Icon(Icons.wind_power, size: 34,),
                            const SizedBox(height: 8,),
                            const Text('Wind Spd.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                            const SizedBox(height: 8,),
                            Text(currentWindSpd.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                           ],
                          ),
                          
                          Column(
                          children: [
                            const Icon(Icons.umbrella, size: 34,),
                            const SizedBox(height: 8,),
                            const Text('Pressure', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                            const SizedBox(height: 8,),
                            Text(currentPressure.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                           ],
                          ),
                      ],
                    ),
                  ),
          
                //additional info card ends
              ],
            ),
          );
        }
      ),
    );
  }
}

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String timeStamp; 
  final double temp;
  const HourlyForecastItem({super.key, required this.icon, required this.timeStamp, required this.temp});

  @override
  Widget build(BuildContext context) {
    return  Card(
                  elevation: 6,
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                    child:  Column(
                      children: [
                        Text(timeStamp, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                        const SizedBox(height: 8),
                        Icon(icon),
                        const SizedBox(height: 8),
                        Text('${temp.toStringAsFixed(2)}°C', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                );
  }
}

