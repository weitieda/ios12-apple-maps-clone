# iOS12 Apple Maps Clone

### Attempt to clone the original UI and animation of iOS12 Apple Maps app
![Alt Text](https://media.giphy.com/media/5n9q1iy4mE0JEMoxkN/giphy.gif) 
![Alt Text](https://media.giphy.com/media/5wFUxlmrZnd1D2SR5G/giphy.gif)
![3](https://user-images.githubusercontent.com/35972055/53013491-eefb9980-3413-11e9-9f78-0f0c1a40bdff.gif)
## Features
1. Request permission to get user's location by `CoreLocation` and show user location on `MKMapView` from `MapKit`
1. Snapping behavior of search panel to top, middle and bottom position
1. `HTTP` GET request to Dark Sky weather api, and `JSON` parsing by `Codable` protocol
1. Search nearby places by `MKLocalSearch` and `naturalLanguageQuery`
1. Showed search results on customized cell `UITableView` with `annotations`, and calculated distance from user location
1. Center each place `annotation` by clicking relevant cell
1. `Auto Layout` UI programmatically
1. Implemented Delegation and Singleton Design Pattern

## Installation
Clone or download the project, navigate to `Config` folder, create a file `Key.swift`, then build. You're good to go.
```
import Foundation

enum Key: String {
    case weatherApiKey = "YOUR_DARK_SKY_API_KEY"
}
```
