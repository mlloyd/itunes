# itunes

- Added a search app which searches the itunes api, and returns a playlist.
- The app displays a detail view which display further info, and play the preview track.

- The app supports ipad, in the most basic form, using size classes.

- The app is written using objective-c

- The app is split up to use two services, one for the search query, and the second for fetching images. Each allows for request cancellation should the user submit a new query.

- I could have done more with the images, if the api provide a better image resolution.

- TODO - Push errors up and present, add Reachability.
