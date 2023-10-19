https://portal.opentopography.org/dataCatalog?group=global
https://spacedata.copernicus.eu/web/cscda/dataset-details?articleId=394198
https://registry.opendata.aws/copernicus-dem/

aws s3 --no-sign-request cp s3://copernicus-dem-90m/ ./dem90/ --exclude "*" --include "*DEM.tif" --recursive
find ./dem90/ -name "*DEM.tif" -exec mv {} ./dem90/ \;
gdalbuildvrt copernicusDem90m.vrt ./dem90/*DEM.tif
nohup gdal_translate -stats -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=3" -co "NUM_THREADS=8" copernicusDem90m.vrt copernicusDem90m.tif &


aws s3 --no-sign-request cp s3://copernicus-dem-30m/ ./dem30/ --exclude "*" --include "*DEM.tif" --recursive
find ./dem30/ -name "*DEM.tif" -exec mv {} ./dem30/ \;
gdalbuildvrt copernicusDem30m.vrt ./dem30/*DEM.tif
nohup gdal_translate -stats -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=3" -co "NUM_THREADS=8" copernicusDem30m.vrt copernicusDem30m.tif &

