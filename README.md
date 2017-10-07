# Privatbank-ATMs-map
Simple application which helps to Privatbank ATMs on the map in several cities.

1. Open the app and you'll see the "Hello" message with a text: "Please, turn on location or choose a city in a top right corner" if location is turned off.
2. If you turned on location, and you located in one of the cities hardcoded in the app, app will recignize it and will load ATMs in your city.
3. If location is turned off, you can simply choose a needed city and you'll be moved to the city center and app will load all the ATMs as well.
4. By tapping on the pin you'll see the address and the name of the place where ATM is located. For example: "Супермаркет Фора", etc.

###
Application contains of the following parts:
1. NetworkManager – class for connecting to Privatbank ATM API.
For now, only one method exist to get the ATMs by the city:```getATMs(for city: City, completionHandler: @escaping (JSON) -> Void)```
2. Cities implemented as enum.
3. ViewController – class that represents the main screen and contains mapView and navigationBar with a UIBarButtonItem for city choosing.
4. CityPickerViewController class and CityPickerViewControllerDelegate protocol – view controller and protocol that handle city choosing
5. ATM object implemented as a structure.
