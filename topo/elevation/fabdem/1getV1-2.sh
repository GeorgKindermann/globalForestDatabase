URL=https://data.bris.ac.uk/datasets/s5hqmjcdj8yo2ibzi9b4ew3sn/
NCORES=8
SAVEHERE=./
for i in $(curl -s $URL | grep -Po '(?<=href=")[^"]*' | grep ".zip$"); do
    if [ ! -f "${i%.zip}.tif" ]; then
	echo $i
	tmp_dir=$(mktemp -d -p $SAVEHERE)
	wget -q -P $tmp_dir $URL$i
	unzip -q -d $tmp_dir ${tmp_dir}/$i
	gdalbuildvrt ${tmp_dir}/tmp.vrt ${tmp_dir}/???????_FABDEM_V1-2.tif
	gdal_edit.py -scale 100 ${tmp_dir}/tmp.vrt
	gdal_translate -ot Int32 -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=2" -co "NUM_THREADS=$NCORES" -unscale ${tmp_dir}/tmp.vrt $SAVEHERE${i%.*}.tif
	rm -r $tmp_dir
    fi
done

gdalbuildvrt ${SAVEHERE}FABDEM_V1-2.vrt ${SAVEHERE}???????-???????_FABDEM_V1-2.tif
gdal_translate -a_scale 0.01 -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "PREDICTOR=2" -co "NUM_THREADS=$NCORES" ${SAVEHERE}FABDEM_V1-2.vrt ${SAVEHERE}FABDEM_V1-2.tif
