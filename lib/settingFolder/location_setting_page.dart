import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:workout_buddy/utils/utils.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double? _currentSliderValue = 0;
  final Location location = Location();

   LocationData? _location;



  Future<void> _grabLocation() async {
    try {
      final LocationData results = await location.getLocation();
      setState(() {
        _location = results;
      });
    } on PlatformException catch (e) {
      print('not working$e');
    }
  }



  @override
  void initState() {
    _currentSliderValue = UserProfilePreferences.getDistancePreference() ?? 0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                   const Icon(
                    Icons.location_on,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Set travel distance'),
                  Slider(
                    label: _currentSliderValue!.round().toString(),
                    divisions: 10,
                    max: 200,
                    value: _currentSliderValue!,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        UserProfilePreferences.setDistancePreference(value);
                        //debugPrint(value.toString());
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async{
                           // _grabLocation();
                        //setState(() async{
                          _location = await UserCurrentLocation().getLocation();
                          UserProfilePreferences.setLocationData(_location!.latitude!.toDouble(), _location!.longitude!.toDouble());
                        //});

                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Update Location')),
                  Text(
                      'Location: ${_location?.latitude.toString() ?? "No location"} ')
                  //Text(position)
                ],
              ))),
    );
  }
}
