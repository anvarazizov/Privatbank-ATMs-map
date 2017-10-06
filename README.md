# Privatbank-ATMs-map
Simple application which helps to Privatbank ATMs on the map in several cities.

1. Tap "Choose a city" button in the right top corner
2. Choose a city
3. You'll see the central point in the city center and all the ATMs will load after this
4. Repeat the same with any other city from the list

###
Application contains of the following parts:
1. NetworkManager – class for connecting to Privatbank ATM API.
For now, only one method exist to get the ATMs by the city:```getATMs(for city: City, completionHandler: @escaping (JSON) -> Void)```
Cities implemented as enum.
2. ViewController – class that represents the main screen and contains mapView and navigationBar with a UIBarButtinItem for city choosing.
3. CityPickerViewController class and CityPickerViewControllerDelegate protocol – view controller and protocol that handle city choosing
4. ATM object implemented as a structure.



