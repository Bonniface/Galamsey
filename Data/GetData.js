var imageCollection = ee.ImageCollection("COPERNICUS/S2"),
    geometry = 
    /* color: #d63000 */
    /* displayProperties: [
      {
        "type": "rectangle"
      }
    ] */
    ee.FeatureCollection(
        [ee.Feature(
            ee.Geometry.Polygon(
                [[[-2.071165253017948, 6.147184753446289],
                  [-2.071165253017948, 5.834419008815262],
                  [-1.462797333096073, 5.834419008815262],
                  [-1.462797333096073, 6.147184753446289]]], null, false),
            {
              "system:index": "0"
            })]);


var geometry2 = ee.FeatureCollection('users/mamponsah91/Gala_pilarea')
var now = Date.now();
var DateNow = ee.Date(now);


var image = ee.Image('COPERNICUS/S2/20151128T002653_20151128T102149_T56MNN')

Map.addLayer(geometry, {color: 'red'}, 'Ghana')
Map.centerObject(geometry)
var rgbVis = {min: 0.0, max: 3000, bands: ['B4', 'B8', 'B2']};

var filtered = imageCollection
  .filter(ee.Filter.date('2000-01-01', DateNow))
  .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 30))
  .filter(ee.Filter.bounds(geometry))
//print(image.id().getInfo())
// Write a function for Cloud masking
function maskS2clouds(image) {
  var qa = image.select('QA60')
  var cloudBitMask = 1 << 10;
  var cirrusBitMask = 1 << 11;
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0).and(
             qa.bitwiseAnd(cirrusBitMask).eq(0))
  return image.updateMask(mask)//.divide(10000)
      .select("B.*")
      .copyProperties(image, ["system:time_start"])
}
print(imageCollection);

var filtered = filtered.map(maskS2clouds)
// Write a function that computes NDVI for an image and adds it as a band
function addNDVI(image) {
  var ndvi = image.normalizedDifference(['B8', 'B4']).rename('ndvi');
  return image.addBands(ndvi);
}

// Map the function over the collection
var withNdvi = filtered.map(addNDVI);

var reduce = image.reduceRegion({
  reducer: ee.Reducer.mean(),
  geometry: geometry,
  scale: 30,
  maxPixels: 40e9
})

// Display a time-series chart
var chart = ui.Chart.image.series({
  imageCollection: withNdvi.select('ndvi'),
  region: geometry,
  reducer: ee.Reducer.mean(),
  scale: 20
}).setOptions({
      lineWidth: 1,
      title: 'NDVI Time Series',
      interpolateNulls: true,
      vAxis: {title: 'NDVI'},
      hAxis: {title: '', format: 'YYYY-MMM'}
    })
print(chart);