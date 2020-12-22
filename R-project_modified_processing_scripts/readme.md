# Intro

These are modified R-project processing scripts and downloading script. Originals made by Matěj Man, modified by me.

In my case the scripts etc. were located in 

/media/juhele/data_2TB/_CRAN/ 

so you will need to modify the scripst in order to fit your setup.

# Running download script

Running the scripts is easy - just run terminal from the folder and put there command for aproppriate script.
1) to download the data:

Downloading script:
```
Rscript downloading_script_v2.R
```
# Fixing the data encoding in linux

The downloading script gives you plenty of ZIP files with CSV inside. These CSV files have CP1250 encoding so the processing script fails as there is no encoding explicitly defined in the scripts so default system is used and linux expects UTF-8.

My clumsy solution was to extract all the CSV files in one folder and then use this code (requires "iconv" package installed):
```
#!/bin/bash
#enter input encoding here
FROM_ENCODING="CP1250"
#output encoding(UTF-8)
TO_ENCODING="UTF-8"
#convert
CONVERT=" iconv  -f   $FROM_ENCODING  -t   $TO_ENCODING"
#loop to convert multiple files 
for  file  in  *.csv; do
     $CONVERT   "$file"   -o  "${file%.csv}.utf8.csv"
done
exit 0
```
in a file called "encoding.sh", placed in the folder with CSV files and running it from terminal:

```
sh encoding.sh
```
this script creates new CSV files in UTF-8 encoding:

```
B1BLAT01_SRA_N.csv
B1BLAT01_SRA_N.utf8.csv
```



# Running processing script

2) to process downloaded data:

mean air temperature
```
Rscript unzip_process_1_airTmean.R
```

minimum air temperature
```
Rscript unzip_process_2_airTmin.R
```

maximum air temperature
```
Rscript unzip_process_3_airTmax.R
```

preciptitation
```
Rscript unzip_process_4_SRA.R
```

