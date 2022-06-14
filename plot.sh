#/bin/bash
#

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
    set label "Sevierodonieck's battle" at 100,graph 0.2 center rotate 
    set obj rect from 90, graph 0 to 130, graph 1

    set style rect fc lt -1 fs solid 0.15 noborder
    set label "Azovstal surrender" at 82.5,graph 0.2 center rotate 
    set obj rect from 80, graph 0 to 84, graph 1
    
    set style rect fc lt -1 fs solid 0.15 noborder
    set label "RUS retreat from Kiev" at 37,graph ${2} center rotate 
    set obj rect from 32, graph 0 to 41, graph 1

    set grid
    set title "${1} by UA (${now})" font ",14"
    plot "${1}.txt" using 1:2 with linespoints title "${1}"
EOFMarker
    echo "output plot: ${1}.png"
}

function make_common_plot(){
    python3 analyzer.py rus-loss-by-ua.json \
	    staff:0.02 \
	    tank:0.2 \
	    armor:0.2 \
	    cannon:0.2 \
	    mlrs:0.05 \
	    airdefence:0.05 \
	    aircraft:0.1 \
	    helicopter:0.1 \
	    dron:0.05 \
	    vehicle:0.05 \
	    special:0.05 \
	    warship:0.05 \
	    > all.txt
    now=`date "+%d-%m-%Y"`
    gnuplot -persist <<-EOFMarker

    set terminal png size 800,600
    set output "common.png"
    set xlabel "offset in days"
    set ylabel "number"
    set key left ins top
        
    set style rect fc lt -1 fs solid 0.15 noborder
    set label "Sevierodonieck's battle" at 100,graph 0.2 center rotate 
    set obj rect from 90, graph 0 to 130, graph 1

    set style rect fc lt -1 fs solid 0.15 noborder
    set label "Azovstal surrender" at 82.5,graph 0.2 center rotate 
    set obj rect from 80, graph 0 to 84, graph 1

    set style rect fc lt -1 fs solid 0.15 noborder
    set label "RUS retreat from Kiev" at 37,graph 0.8 center rotate 
    set obj rect from 32, graph 0 to 41, graph 1

    set grid
    set title "Common RUS losses by UA (${now})" font ",14"
    plot \
    	 "staff.txt" u 1:(\$2/10) with linespoints title "staff x10",\
    	 "tank.txt" using 1:2 with linespoints title "tank",\
    	 "armor.txt" using 1:2 with linespoints title "armor",\
    	 "vehicle.txt" using 1:2 with linespoints title "vehicle"#,\
	 #"all.txt" using 1:2 with linespoints title "summarize"
EOFMarker
    echo "output plot: common.png"
}


form_data rus-loss-by-ua.json staff staff.txt
form_data rus-loss-by-ua.json tank tank.txt
form_data rus-loss-by-ua.json armor armor.txt
form_data rus-loss-by-ua.json cannon cannon.txt
form_data rus-loss-by-ua.json mlrs mlrs.txt
form_data rus-loss-by-ua.json aircraft aircraft.txt
form_data rus-loss-by-ua.json helicopter helicopter.txt
form_data rus-loss-by-ua.json dron dron.txt
form_data rus-loss-by-ua.json vehicle vehicle.txt
#form_data rus-loss-by-ua.json airdefence airdefence.txt
#form_data rus-loss-by-ua.json special special.txt
#form_data rus-loss-by-ua.json warship warship.txt
#form_data rus-loss-by-ua.json rocket rocket.txt

make_plot staff 0.8
make_plot tank 0.8
make_plot armor 0.8
make_plot cannon 0.8
make_plot mlrs 0.8
make_plot aircraft 0.8
make_plot helicopter 0.2
make_plot dron 0.8
make_plot vehicle 0.8

# make_plot special 0.8
# make_plot warship 0.8
# make_plot rocket 0.8
# make_plot airdefence 0.8
# make_common_plot
