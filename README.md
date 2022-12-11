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
![GitRepoSearch copy](https://user-images.githubusercontent.com/7112264/197776530-12f0f5c7-6795-4f61-9bef-fbd9cc22d8ea.png)


