#FABDEM (Forest And Buildings removed Copernicus DEM)
#https://dx.doi.org/10.1088/1748-9326/ac4d4f
#https://data.bristol.ac.uk/data/dataset/25wfy0f9ukoge2gs7a5mqpq2j7
URL=https://data.bris.ac.uk/datasets/25wfy0f9ukoge2gs7a5mqpq2j7/
for i in $(curl -s $URL | grep -Po '(?<=href=")[^"]*' | grep ".zip$"); do
    echo $i
    tmp_dir=$(mktemp -d -p $SAVEHERE)
    wget -q -P $tmp_dir $URL$i
    unzip -d $tmp_dir ${tmp_dir}/$i
    gdalbuildvrt ${tmp_dir}/tmp.vrt ${tmp_dir}/???????_FABDEM_V1-0.tif
    gdal_edit.py -scale 100 ${tmp_dir}/tmp.vrt
    gdal_translate -ot Int32 -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=2" -co "NUM_THREADS=$NCORES" -unscale ${tmp_dir}/tmp.vrt $SAVEHERE${i%.*}.tif
    rm -r $tmp_dir
done
gdalbuildvrt ${SAVEHERE}FABDEM_V1-0.vrt ${SAVEHERE}???????-???????_FABDEM_V1-0.tif
gdal_translate -a_scale 0.01 -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=2" -co "NUM_THREADS=$NCORES" ${SAVEHERE}FABDEM_V1-0.vrt ${SAVEHERE}FABDEM_V1-0.tif

