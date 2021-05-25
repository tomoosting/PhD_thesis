#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-1:00
#SBATCH --partition=quicktest
#SBATCH --mail-type=END
#SBATCH --job-name=tree_info
#SBATCH -o /nfs/scratch/oostinto/stdout/tree_info_%j.out
#SBATCH -e /nfs/scratch/oostinto/stdout/tree_info_%j.err
#SBATCH --mail-user=tom.oosting@vuw.ac.nz

name=$1
model=$2
runid=$3

run_dir=/nfs/scratch/oostinto/call_sets/mitogenomes/beast2/$name'_'$model/$name'_'$model'_'$runid
tree=$run_dir/$name'_'$model'_run'$runid.combined.annot.tree
ext=$run_dir/$name'_'$model'_run'$runid

grep -oP "(CAheight_95%_HPD=[^}]*)"  $tree | sed 's/CAheight_95%_HPD={//g' | sed 's/,/\t/g' > $ext'_CAheight95.txt'
grep -oP "(CAheight_mean=[^,]*)"     $tree | sed 's/CAheight_mean=//g' > $ext'_CAheightmean.txt'
grep -oP "(CAheight_median=[^,]*)"     $tree | sed 's/CAheight_median=//g' > $ext'_CAheightmedian.txt'
#grep -oP "(posterior=[^]]*)"     $tree | sed 's/posterior=//g' #different lenght         > $ext'_posterior.txt'

paste $ext'_CAheightmean.txt' $ext'_CAheightmedian.txt' $ext'_CAheight95.txt' | sort -n -s -k1,1 > $ext'_tree_info.txt'

rm $ext'_CAheight95.txt'
rm $ext'_CAheightmedian.txt'
rm $ext'_CAheightmean.txt'