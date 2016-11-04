# The Bureau of Investigative Journalism - Drone Data API	

## Introduction

The Bureau's [complete data sets](https://www.thebureauinvestigates.com/category/projects/drones/drones-graphs/) on drone strikes in Pakistan, Yemen and Somalia are available as google spreadsheets. This simple Rails 5 API app imports the spreadsheet data and makes it available as a simple API for the Bureau's website.

It also includes an example report page and search widget which can be included in a WordPress site or similar.

## Functionality and example report

The root page of this application has the 'Refresh Data' button. This triggers a delete & fresh import of the data from the spreadsheets, including geocoding. It *may* timeout rendering the page, but should complete. Something like [Temporize](https://devcenter.heroku.com/articles/temporize#basic-concepts) on Heroku could be used to run this as a background task.

The [Example report page](https://github.com/jamesjefferies/drone_brain/blob/master/public/data.html) works and the content of the ```<main></main>``` tags can be extracted for use elsewhere, as long as the JavaScript is also included. 

### Technology Notes

 * The application gets it's data from the google spreadsheets using the [google drive gem](https://github.com/gimite/google-drive-ruby/)
 * Google API access needs to be set up to access the spreadsheets
 * Geocoding is performed using the [geocode gem](https://github.com/alexreisner/geocode) which uses Google Maps by default
 * JavaScript and CSS isn't included in the asset pipeline as the included templates are for demo purposes only.
 * URI.js is used for parsing query params
 * ```explore-functionality.js``` is used for managing the search form and needs to be included wherever the search form is included. The search form does a simple get with the request params being used to call the API
 * ```charts.js``` does the actual rendering of the charts and map
 
 
 
#### Geocoding Note

The mapping currently uses [Leaflet](http://leafletjs.com/) & Open Street Map for the map - it would be relatively straightforward to switch that to [Google Maps - exmaple code](https://developers.google.com/maps/documentation/javascript/earthquakes) if required by the geocoding licence.

## Setting up access for reading the Google Spreadsheets

The application uses the [google auth gem](https://github.com/google/google-auth-library-ruby) and the [google drive gem](https://github.com/gimite/google-drive-ruby/) to connect to Google's Drive APIs. This requires a service account and here are the [basic instructions](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md).

### Supplmentary notes to setting up Authorisation

Log on as special user, and navigate to the [api library page](https://console.developers.google.com/apis/library?authuser=2)

* Create a project, give it a project name, e.g. TBIJ data api
* Create new service account with Role 'Storage Object Viewer'
* Give service account name, like 'read-only-user'
* Download credentials as JSON
* Make sure you enable the google drive API and the google sheets api for the project in the google developer console.

## Local development

From the JSON credentials file, created above, create a ```.env``` file and put the following stuff in there:

```
GOOGLE_PRIVATE_KEY="whatever the private key is in the json credentials file"
GOOGLE_CLIENT_EMAIL="whatever the client email field has in it from the json file"
```

Run the usual 
```
rake db:create
rake db:migrate
```

To set up the database, then run the following rake command to pull in the spreadsheet data:

```
rake spreadsheet:import
```
Then to geo-locate the locations using the default (google maps geocoding)

```
rake geocode:all CLASS=Location SLEEP=0.25 BATCH=100
```

## Deployment

Currently the application is deployed to Heroku, the google private key and client email environment variables must be set for the application to work.

On first time deployment run: ```heroku rake db:migrate```

then you can run ```heroku rake spreadsheet:import``` to import all the data from the spreadsheet.
and ```heroku rake geocode:all CLASS=Location SLEEP=0.25 BATCH=100``` to geocode everything.

The URL for the API call in [charts.js](https://github.com/jamesjefferies/drone_brain/blob/master/public/assets/js/charts.js#L18) should be amended accordingly

## Issues/Notes

 * Might have to switch to Google Map for geocoding licencing as the Geocoding gem uses Google by default.