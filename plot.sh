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
    set key left ins top
    set grid
    set title "${1} by UA (${now})" font ",14"
    plot "${1}.txt" using 1:2 with linespoints title "${1}"
EOFMarker
    echo "output plot: ${1}.png"
}

function make_common_plot(){
    now=`date "+%d-%m-%Y"`
    gnuplot -persist <<-EOFMarker

    set terminal png size 800,600
    set output "common.png"
    set xlabel "offset in days"
    set ylabel "number"
    set key left ins top
    set grid
    set title "Common RUS losses by UA (${now})" font ",14"
    plot \
    	 "staff.txt" u 1:(\$2/10) with linespoints title "staff x10",\
    	 "tank.txt" using 1:2 with linespoints title "tank",\
    	 "armor.txt" using 1:2 with linespoints title "armor"
EOFMarker
    echo "output plot: common.png"
}


form_data rus-loss-by-ua.json staff staff.txt
form_data rus-loss-by-ua.json tank tank.txt
form_data rus-loss-by-ua.json armor armor.txt
form_data rus-loss-by-ua.json cannon cannon.txt
form_data rus-loss-by-ua.json mlrs mlrs.txt
form_data rus-loss-by-ua.json airdefence airdefence.txt
form_data rus-loss-by-ua.json aircraft aircraft.txt
form_data rus-loss-by-ua.json helicopter helicopter.txt
form_data rus-loss-by-ua.json dron dron.txt

make_plot staff
make_plot tank
make_plot armor
make_plot cannon
make_plot mlrs
make_plot airdefence
make_plot aircraft
make_plot helicopter
make_plot dron
make_common_plot
