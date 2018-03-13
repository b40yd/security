#!/bin/bash
F=first_content.log
M=matched.log
N=0
function find_origin(){
    if [ "$1" != "" -a "$2" != "" -a "$3" != "" -a "$4" != "" ];then
        find $1 -type f -name "*.$2"| xargs grep -oP "content:.+" > $F
        find $1 -type f -name "*.$2"| wc -l
        while read LINE
        do
            #echo $LINE
            ((N++))
            content=`echo $LINE | cut -d ";" -f 1|cut -d ":" -f 3`
            echo -e "finding [$N] $content\n"
            last_content=`echo $LINE | grep -oP "content:.+" | cut -d ";" -f 2-`
            find_target $3 $4 "$content" "$last_content" $1 $2
        done  < $F
        
    fi
}

function find_target(){
    
    ok=`find $1 -type f -name "*.$2" | xargs grep -n "$3"`
    if [ "$ok" != "" ];then
        remove $5 $6 $3
        echo -e "===$3===\n" >> $M
    fi

    content=`echo $4 | grep -oP "content:.*" | cut -d ";" -f 1|cut -d ":" -f 2`

    echo -e "finding $content\n"
    if [ "$content" != "" ];then
        last_content=`echo $4 | grep -oP "content:.+" | cut -d ";" -f 2-`
        find_target $1 $2 "$content" "$last_content" $5 $6
    fi
}


case $1 in
    help|h|--help|-h)
        echo -e "help:\n\t ./search_content [searching dir path] [suffix name] [matching dir path] [suffix name]"
        exit 0
    ;;
esac


function remove(){
    content=$(echo  $3 | sed -e 's/\//\\\//g')
    find $1 -type f -name "*.$2" | xargs sed -i "/$content/d"
}

## 
## cat matched.log | grep -oP "===.+==="| sort -u | sed -e  "s/===//g" | sed -e 's/\//\\\//g'
## 

# exclude repeat ruleset
function exclude(){
    
    cat $M | grep -oP "===.+==="| sort -u | sed -e  "s/===//g" > $M
    while read LINE
    do
        ((N++))
        find $1 -type f -name "*.rules" | xargs sed -i "/$LINE/d"
    done  < $M
        
    
}

if [ -f $M -a -f $F ];then
    rm -rfv $M $F
fi

find_origin $1 $2 $3 $4

echo -e "Repeat rules total: $(cat ${M} | grep -oP "===.+==="| sort -u | sed -e  "s/===//g"|wc -l) \n"
echo "done"
exit 0
