#!/bin/bash

LIST=writings.shtml

echo "<TABLE BORDER=2 CELLPADDING=3>" > $LIST
echo "<TR>" >> $LIST
echo "<TH>Title</TH>" >> $LIST
echo "<TH>PostScript</TH>" >> $LIST
echo "<TH>Acrobat</TH>" >> $LIST
echo "<TH>ASCII Text</TH>" >> $LIST
echo "<TH>HTML</TH>" >> $LIST
echo "</TR>" >> $LIST

for MSFILE in *.ms
do
    TITLE=$(cat ${MSFILE} | awk 'f{print;f=0} /^.TL/{f=1}')
    BASE=$(basename ${MSFILE} .ms)
    PSFILE="${BASE}.ps"
    PDFFILE="${BASE}.pdf"
    TXTFILE="${BASE}.txt"
    HTMLFILE="${BASE}.html"
    echo -n Processing ${TITLE}...

    cat ${MSFILE} | iconv -f utf-8 -t ascii//translit | groff -ms -Tps > ${PSFILE}
    cat ${MSFILE} | iconv -f utf-8 -t ascii//translit | groff -ms -Tpdf > ${PDFFILE}
    cat ${MSFILE} | iconv -f utf-8 -t ascii//translit | groff -ms -Tascii | ansi2txt | col -b > ${TXTFILE}
    cat ${MSFILE} | iconv -f utf-8 -t ascii//translit | groff -ms -Thtml  > ${HTMLFILE}

    echo "<TR>" >> $LIST
    echo "<TD>${TITLE}</TD>" >> $LIST
    echo "<TD><A HREF=${PSFILE} TARGET=_blank>View</A>" >> $LIST
    echo "<TD><A HREF=${PDFFILE} TARGET=_blank>View</A>" >> $LIST
    echo "<TD><A HREF=${TXTFILE} TARGET=_blank>View</A>" >> $LIST
    echo "<TD><A HREF=${HTMLFILE} TARGET=_blank>View</A>" >> $LIST
    echo "</TR>" >> $LIST
    
    echo [DONE]
done

echo "</TABLE>" >> $LIST

echo "Uploading..."

scp *.{ps,pdf,txt,html,shtml} hemera.chivanet.org:public_html/

echo "Done."
