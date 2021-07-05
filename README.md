# appentus_assessment

A Flutter project for displaying current location.

## Getting Started

This project is for displaying current location.
it has signup, login & logout facility.
For signup it takes five parameters name, email, password, mobile number, image.
for login it takes two parameter email, password.
after login it display google map location of current user.
map screen contains a button, which redirect to another screen which have gridview.
gridview display two contents, one image & other is author name.

following third party libraries used in this application.
hive:                           for local data storage,
hive_flutter:                   for local data storage,
path_provider:                  for accessing application directory path,
google_maps_flutter:            for displaying map,
permission_handler:             for permission,
geolocator:                     for featching user current location,
http:                           for api call,
cached_network_image:           for image displaying in grid view,
image_picker:                   for picking image from phone gallery,
