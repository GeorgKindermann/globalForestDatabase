#ESA WorlCover 2020
wget https://zenodo.org/record/5571936/files/ESA_WorldCover_10m_2020_v100_Map.tar.gz?download=1

gdalbuildvrt ESA_WorldCover_10m_2020_v100_Map.vrt ./3deg_cogs/ESA_WorldCover_10m
_2020_v100_???????_Map.tif

gdal_translate -co "BIGTIFF=YES" -co "COMPRESS=DEFLATE" -co "TILED=YES" -co "NUM_THREADS=8" ESA_WorldCover_10m_2020_v100_Map.vrt ESA_WorldCover_10m_2020_v100_Map.tif -mo product_version=V1.0.0 -mo title="ESA WorldCover product at 10m resolution for year 2020" -mo copyright="ESA WorldCover project 2020 / Contains modified Copernicus Sentinel data (2020) processed by ESA WorldCover consortium" -mo license="CC-BY 4.0" -mo legend="10  Tree cover
    20  Shrubland
    30  Grassland
    40  Cropland
    50  Built-up
    60  Bare/sparse vegetation
    70  Snow and ice
    80  Permanent water bodies
    90  Herbaceous wetland
    95  Mangroves
    100 Moss and lichen"

