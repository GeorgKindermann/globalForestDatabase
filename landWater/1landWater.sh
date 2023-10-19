#Use data from 2020 until 2021
#dont konw if using tiled=YES, or tiled=NO is better/faster in this case
nohup grass --text --tmp-location ESA_WorldCover_10m_2020_v100_Map.tif --exec bash proc2020.grass &
nohup grass --text --tmp-location ESA_WorldCover_10m_2021_v200_Map.tif --exec bash proc2021.grass &

nohup ogr2ogr -f "GPKG" -sql "select 1 as a from multipolygons where natural='water'" waterOSM2020.gpkg planet-200106.osm.pbf &
nohup ogr2ogr -f "GPKG" -sql "select 1 as a from multipolygons where natural='water'" waterOSM2021.gpkg planet-210104.osm.pbf &
nohup ogr2ogr -f "GPKG" -sql "select 1 as a from multipolygons where natural='water'" waterOSM2022.gpkg planet-220103.osm.pbf &
sqlite3 waterOSM2020.gpkg "ALTER TABLE multipolygons DROP COLUMN a"
sqlite3 waterOSM2021.gpkg "ALTER TABLE multipolygons DROP COLUMN a"
sqlite3 waterOSM2022.gpkg "ALTER TABLE multipolygons DROP COLUMN a"
#
#nohup gdal_rasterize -burn 1 -init 0 -te -180 -85 180 90 -ts 4320000 2100000 -ot Byte -co BIGTIFF=YES -co NBITS=1 -co COMPRESS=CCITTFAX4 waterOSM.gpkg waterOSM.tif & #might be slower afterwards
nohup gdal_rasterize -burn 1 -init 0 -te -180 -90 180 90 -ts 4320000 2160000 -co BIGTIFF=YES -co COMPRESS=DEFLATE -co tiled=YES waterOSM2020.gpkg waterOSM2020B.tif >nohupVM101OSM20.out &
nohup gdal_rasterize -burn 1 -init 0 -te -180 -90 180 90 -ts 4320000 2160000 -co BIGTIFF=YES -co COMPRESS=DEFLATE -co tiled=YES waterOSM2021.gpkg waterOSM2021B.tif >nohupVM101OSM21.out &
nohup gdal_rasterize -burn 1 -init 0 -te -180 -90 180 90 -ts 4320000 2160000 -co BIGTIFF=YES -co COMPRESS=DEFLATE -co tiled=YES waterOSM2022.gpkg waterOSM2022B.tif >nohupHPG914OSM22.out &

wget https://raw.githubusercontent.com/wmgeolab/geoBoundaries/610fa070e480662149f417afedceb5231e50344f/releaseData/gbOpen/ATA/ADM0/geoBoundaries-ATA-ADM0-all.zip
unzip geoBoundaries-ATA-ADM0-all.zip geoBoundaries-ATA-ADM0.topojson
nohup gdal_rasterize -burn 0 -init 1 -te -180 -90 180 -59 -ts 4320000 372000 -ot Byte -co BIGTIFF=YES -co COMPRESS=DEFLATE -co tiled=YES geoBoundaries-ATA-ADM0.topojson waterGBO.tif &

wait

nohup gdal_calc.py --projwin -180 90 180 -90 -A waterESA2020.tif waterESA2021.tif waterOSM2020.tif waterOSM2021.tif waterOSM2022.tif waterGBO.tif --outfile=water.tif --type=Byte --format="GTiff" --co="BIGTIFF=YES" --co="COMPRESS=DEFLATE" --co="TILED=YES" --calc="numpy.sum(A,axis=0)==0" --overwrite &

nohup gdal_translate -ot Byte -co BIGTIFF=YES -co NBITS=1 -co COMPRESS=CCITTFAX4 water.tif landWater2020.tif &

mkdir t
for z in {-180..170..10}
do
    export x=$z
    echo {-90..80..10} | xargs -n 1 | xargs -I {} -P 9 sh -c 'y={}; gdal_translate -ot Byte -co BIGTIFF=YES -co NBITS=1 -co COMPRESS=CCITTFAX4 -projwin $x $(({}+10)) $((x+10)) {} water.tif ./t/landWater2020_$(printf "%04g" $x)_$(printf "%03g" {}).tif'
done
