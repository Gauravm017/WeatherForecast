# WeatherForecast

 Openweathermap.org's freely available APIs are used to implement features similar to apple's weather app or yahoo's weather app.
 
 How to use:
 Please use API key after login to Openweathermap with credentials and Add the Key to APIServices class to "weatherAPIKey".
 
 About Implementation:
 
Build the weather UI in three parts:
1. Cities weather list which contain the city that you have added to montior.
2. Search page to search through pin code, zip code, citties names, and Addresses.
3. Detailed page to show 5 days forecast of weather for a particular city.

Networking Implementation:

Base URLS --> API Request --> API Serivces  --> API Manager <--> View Controllers

API Results contains two types of object 
1. APIResponse to parse the object
2. APIError If it fails with any reason


* All the Models have been parsed using codable to handle the json response easily.

* User Defaults is used to store the saved cites to which we get from search API.

* Saved the coordinate obejct direct in Used Defaults with help of PropertyListEncoder as that too is codable.

* Have fetched the data with the help of API Request weather by Coordinate.

* Also converted the time with the help of time Zone and Calender.

* Used Mapkit Api to search the location and getting the coordinates for particular area.

 
 
