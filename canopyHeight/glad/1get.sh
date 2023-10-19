mkdir 2000
nohup wget -e robots=off -P ./2000/ -A .tif -r -nH --cut-dirs=4 --no-parent https://glad.umd.edu/users/Potapov/GLCLUC2020/Forest_height_2000/ &

mkdir 2020
nohup wget -e robots=off -P ./2020/ -A .tif -r -nH --cut-dirs=4 --no-parent https://glad.umd.edu/users/Potapov/GLCLUC2020/Forest_height_2020/ &



