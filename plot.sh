#/bin/bash


function form_data(){
    cat $1 | jq "[[.${2}[][0]], [.${2}[][4]]] | transpose | .[][]" | paste - - > ${3}
    echo "output data: ${3}"
}

function make_plot(){
    now=`date "+%d-%m-%Y"`
    gnuplot -persist <<-EOFMarker

    set terminal png size 800,600
    set output "${1}.png"
    set xlabel "offset in days"
    set ylabel "number"
    set grid
    set title "${1} by UA (${now})" font ",14" textcolor rgbcolor "royalblue"
    plot "${1}.txt" using 1:2 with linespoints title "${1}"
EOFMarker
    echo "output plot: ${1}.png"
}


form_data rus-loss-by-ua.json staff staff.txt
make_plot staff

form_data rus-loss-by-ua.json armor armor.txt
make_plot armor


form_data rus-loss-by-ua.json tank tank.txt
make_plot tank
