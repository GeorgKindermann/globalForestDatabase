#ESA WorlCover 2021
for NS in S90 S30 N30
do
    for EW in W180 W120 W060 E000 E060 E120
    do
	wget -q https://worldcover2021.esa.int/data/archive/ESA_WorldCover_10m_2021_v200_60deg_macrotile_${NS}${EW}.zip
    done
done


nohup unzip 'ESA_WorldCover_10m_2021_v200_60deg_macrotile_*.zip' &

gdalbuildvrt ESA_WorldCover_10m_2021_v200_Map.vrt ESA_WorldCover_10m_2021_V200_???????_Map.tif

nohup gdal_translate -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "NUM_THREADS=8" ESA_WorldCover_10m_2021_v200_Map.vrt ESA_WorldCover_10m_2021_v200_Map.tif -mo algorithm_version=V2.0.0 -mo title="ESA WorldCover product at 10m resolution for year 2021" -mo copyright="ESA WorldCover project 2021 / Contains modified Copernicus Sentinel data (2021) processed by ESA WorldCover consortium" -mo license="CC-BY 4.0" -mo legend="10  Tree cover
20  Shrubland
30  Grassland
40  Cropland
50  Built-up
60  Bare/sparse vegetation
70  Snow and ice
80  Permanent water bodies
90  Herbaceous wetland
95  Mangroves
100 Moss and lichen" &
