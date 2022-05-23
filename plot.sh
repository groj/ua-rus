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
    
    set style rect fc lt -1 fs solid 0.15 noborder
    set label "RUS retreat from Kiev" at 37,graph 0.8 center rotate 
    set obj rect from 32, graph 0 to 41, graph 1

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
    
    set style rect fc lt -1 fs solid 0.15 noborder
    set label "RUS retreat from Kiev" at 37,graph 0.8 center rotate 
    set obj rect from 32, graph 0 to 41, graph 1

    set grid
    set title "Common RUS losses by UA (${now})" font ",14"
    plot \
    	 "staff.txt" u 1:(\$2/10) with linespoints title "staff x10",\
    	 "tank.txt" using 1:2 with linespoints title "tank",\
    	 "armor.txt" using 1:2 with linespoints title "armor",\
    	 "vehicle.txt" using 1:2 with linespoints title "vehicle"
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
form_data rus-loss-by-ua.json vehicle vehicle.txt

make_plot staff
make_plot tank
make_plot armor
make_plot cannon
make_plot mlrs
make_plot airdefence
make_plot aircraft
make_plot helicopter
make_plot dron
make_plot vehicle
make_common_plot
