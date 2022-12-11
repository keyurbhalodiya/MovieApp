# MovieApp
This project is used to get the Movie information from [themoviedb](https://www.themoviedb.org/)  

There are 4 different category Now Playing, Popular, Top Rated, and Upcoming.
Also, you can search movie with keyword. 

As per the API response structure, it's returning 20 records for each call. Once you start scrolling and reach the last row, it's called API again to get more records. 
It will stop the API call once the app gets all repositories for a specific search keyword.

Each row displays the movie poster, title, release date, vote average, and vote count. Once you click the movie, it will open movie details screen.

## Features
* Diffable datasource
* Incremental search 
* API throttling using Combine Framework
* An asynchronous image downloader
* An asynchronous memory + disk image caching
* MVVM architecture 
* SOLID Principal
* Protocol oriented programming
* Generic code pattern

## Frameworks

[UICollectionViewDiffableDatasource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)

[Combine](https://developer.apple.com/documentation/combine/)

[Foundation](https://developer.apple.com/documentation/foundation)

[UIKit](https://developer.apple.com/documentation/uikit/)

## API
[themoviedb](https://api.themoviedb.org)

##

![MovieApp](https://user-images.githubusercontent.com/7112264/206909690-b08dab5b-3180-4a9a-a1a8-fcf56df375c4.png)


