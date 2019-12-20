#!/bin/sh
set -e


 echo "Generating Static fonts"
 mkdir -p ../fonts
 fontmake -g MavenPro.glyphs -i -o ttf --output-dir ../fonts
 
 echo "Generating VFs"
 fontmake -g MavenPro.glyphs -o variable --output-path ../fonts/MavenPro[wght].ttf
 
 rm -rf master_ufo/ instance_ufo/
 echo "Post processing"


ttfs=$(ls ../fonts/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	gftools fix-nonhinting $ttf $ttf.fix;
	mv "$ttf.fix" $ttf;
done

vfs=$(ls ../fonts/*\[wght\].ttf)
gftools fix-vf-meta $vfs;
for vf in $vfs
do
	gftools fix-unwanted-tables -t "MVAR" $vf
	mv "$vf.fix" $vf;
	gftools fix-dsig -f $vf;
	gftools fix-nonhinting $vf $vf.fix;
	mv "$vf.fix" $vf;
done
rm ../fonts/*gasp.ttf
