/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This is sample trigger to provide geocoding and reverse geocoding of records. This code has NOT BEEN BULKIFIED and 
// intent is that only used in situation where single record is being inserted/updated or very small number of records
// are being loaded. 
//
// Instructions to setup your own trigger:
// 1) Create trigger basline code for your sobject
// 2) Look at below for Insert versus Update logic. Include the various code segments based on if you need to 
//    geocode or reverse-geocode
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
trigger TestObjectGeocodeTrigger on GeoTestObject__c (
  after insert,
  after update)
{
  ////////////////////////////////////////////////////////////////////////////////
  // this statement is needed to prevent recursive callback from @future method //
  ////////////////////////////////////////////////////////////////////////////////
  if(System.isFuture()) return;

  if (PSCheckRecursive.runOnce())
  {
    if (Trigger.isAfter)
    {
      /////////////////////////////////////
      // logic on initial record inserts //
      /////////////////////////////////////
      if (Trigger.isInsert)
      {
        for (GeoTestObject__c rec : Trigger.new)
        {
          ///////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to geocode a record that contains entire address string in one field
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the address field that contains the full address
          //   3) string that identified the latitude field to update
          //   4) string that identifies the longitude field to update
          ///////////////////////////////////////////////////////////////////////////////////////////////
          if (rec.Full_Address__c != null && rec.Full_Address__c.length() > 0)
          {
            PSGeoUtils.geocodeAddress(rec.Id, rec.Full_Address__c, 'Location__Latitude__s', 'Location__Longitude__s');
          }

          /////////////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to geocode a record that contains address info spread across multiple fields
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the record field that contains the street info
          //   3) the record field that contains the city info
          //   4) the record field that contains the state info
          //   5) string that identified the latitude field to update
          //   6) string that identifies the longitude field to update
          /////////////////////////////////////////////////////////////////////////////////////////////////////
          if (rec.Street__c != null && rec.Street__c.length() > 0 &&
              rec.City__c != null && rec.City__c.length() > 0 &&
              rec.State__c != null && rec.State__c.length() > 0 &&
              rec.Zip__c != null && rec.Zip__c.length() > 0)
          {
            PSGeoUtils.geocodeAddress(rec.Id, rec.Street__c, rec.City__c, rec.State__c, rec.Zip__c, 'Location__Latitude__s', 'Location__Longitude__s');
          }

          //////////////////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to reverse geocode a record based on a lat/lng that already exists on the record
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the record field that contains the latitude info
          //   3) the record field that contains the longitude info
          //   4) string that identifies the field to store the full address (incl street, city, state, zip, postel)
          //   5) string that identifies the field to store the street
          //   6) string that identifies the field to store the city
          //   7) string that identifies the field to store the state
          //   8) string that identifies the field to store the zip/postal code
          //
          //   For any of above fields that you don't want to set the value, just send over NULL for that parameter
          //////////////////////////////////////////////////////////////////////////////////////////////////////////
          if (rec.Location__Latitude__s != null && rec.Location__Longitude__s != null)
          {
            PSGeoUtils.reverseGeocodeAddress(rec.Id, rec.Location__Latitude__s, rec.Location__Longitude__s, 'Full_Address__c', 'Street__c', 'City__c', 'State__c', 'Zip__c');
          }
        }
      }
      //////////////////////////////
      // logic for record updates //
      //////////////////////////////
      else if (Trigger.isUpdate)
      {
        for (GeoTestObject__c rec : Trigger.new)
        {
          ///////////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to geocode a record update that contains entire address string in one field
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the address field that contains the full address
          //   3) string that identified the latitude field to update
          //   4) string that identifies the longitude field to update
          ///////////////////////////////////////////////////////////////////////////////////////////////////
          GeoTestObject__c oldRec = Trigger.oldMap.get(rec.Id);
          if (rec.Full_Address__c != oldRec.Full_Address__c)
          {
            PSGeoUtils.geocodeAddress(rec.Id, rec.Full_Address__c, 'Location__Latitude__s', 'Location__Longitude__s');
          }

          ///////////////////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to geocode a record update that contains address info spread across multiple fields
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the record field that contains the street info
          //   3) the record field that contains the city info
          //   4) the record field that contains the state info
          //   5) string that identified the latitude field to update
          //   6) string that identifies the longitude field to update
          ///////////////////////////////////////////////////////////////////////////////////////////////////////////
          if (rec.Street__c != oldRec.Street__c ||
              rec.City__c != oldRec.City__c ||
              rec.State__c != oldRec.State__c ||
              rec.Zip__c != oldRec.Zip__c)
          {
            PSGeoUtils.geocodeAddress(rec.Id, rec.Street__c, rec.City__c, rec.State__c, rec.Zip__c, 'Location__Latitude__s', 'Location__Longitude__s');
          }

          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          // TODO: use this code to reverse geocode a record update based on a lat/lng that already exists on the record
          //                                                                                     
          // Parameters (in order):
          //   1) the record id to update
          //   2) the record field that contains the latitude info
          //   3) the record field that contains the longitude info
          //   4) string that identifies the field to store the full address (incl street, city, state, zip, postel)
          //   5) string that identifies the field to store the street
          //   6) string that identifies the field to store the city
          //   7) string that identifies the field to store the state
          //   8) string that identifies the field to store the zip/postal code
          //
          //   For any of above fields that you don't want to set the value, just send over NULL for that parameter
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          if (rec.Location__Latitude__s != oldRec.Location__Latitude__s || rec.Location__Longitude__s != oldRec.Location__Longitude__s)
          {
            PSGeoUtils.reverseGeocodeAddress(rec.Id, rec.Location__Latitude__s, rec.Location__Longitude__s, 'Full_Address__c', 'Street__c', 'City__c', 'State__c', 'Zip__c');
          }
        }
      }
    }
  }
}