
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('weather app', style: TextStyle(fontWeight: FontWeight.w800),),
            centerTitle: true,
            actions:[
                IconButton( 
                  onPressed: () => print('refreshed'), 
                  icon: const Icon(Icons.refresh),
                ), 
            ],
      ),

      body: Padding(
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
                    child:  const Padding(
                      padding:  EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // SizedBox(height: 16),
                          Text('37°c', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),),
                          SizedBox(height: 18),
                          Icon(Icons.cloud, size: 64,),
                          SizedBox(height: 18),
                          Text('Sunny', style: TextStyle(fontSize: 22),),
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
                'Weather Forecast', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ), 
              ),
        
            // weather forecast cards
            const SizedBox(height: 20,),
             const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
               child: Row(
                children: [
                  HourlyForecastItem(),
               
                  //CARD 2
                  HourlyForecastItem(),
               
                  //CARD 3
                 HourlyForecastItem(),
               
                  //CARD 4
                  HourlyForecastItem(),
               
                  //CARD 5
                  HourlyForecastItem(),
                  ],
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
                child: const Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.water_drop_rounded, size: 34,),
                        SizedBox(height: 8,),
                        Text('Humidity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                        SizedBox(height: 8,),
                        Text('94', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                       ],
                      ),
                      SizedBox(width: 40,),
                      Column(
                      children: [
                        Icon(Icons.wind_power, size: 34,),
                        SizedBox(height: 8,),
                        Text('Wind Spd.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                        SizedBox(height: 8,),
                        Text('9.4', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                       ],
                      ),
                      SizedBox(width: 40,),
                      Column(
                      children: [
                        Icon(Icons.umbrella, size: 34,),
                        SizedBox(height: 8,),
                        Text('Pressure', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                        SizedBox(height: 8,),
                        Text('1002', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                       ],
                      ),
                  ],
                ),
              ),

            //additional info card ends
          ],
        ),
      ),
    );
  }
}

class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
                  elevation: 6,
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                    child: const Column(
                      children: [
                        Text('03:00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                        SizedBox(height: 8),
                        Icon(Icons.cloud, size:32),
                        SizedBox(height: 8),
                        Text('37°C', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),)
                      ],
                    ),
                  ),
                );
  }
}

