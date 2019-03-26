# Geocode-Trigger

THIS SOFTWARE IS COVERED BY [THIS DISCLAIMER](https://raw.githubusercontent.com/thedges/Disclaimer/master/disclaimer.txt).

Sample trigger code to use for geocoding and reverse-geocoding a record. This code has not been bulkified and intent is to be used for single record insert/updates or small volume loads of data (10-20 records). This trigger code uses a utility library that makes REST calls to ESRI ArcGIS public server to do the gecoding and reverse-geocoding. Due to REST callout, the geocoding data is not inserted to object record until after insert or save as all logic is in @future method callout.

<b>Dependency:</b> Install the [PSCommon](https://github.com/thedges/PSCommon) package first

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
