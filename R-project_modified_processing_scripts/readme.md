# Intro

These are modified R-project processing scripts and downloading script. Originals made by Matěj Man, modified by me.
Requires R-project packages to be installed - in my case I used "r-cran" from default Ubuntu Focal repositories - all the default installed with r-cran plus some additional required by the scripts like "r-cran-purr", "r-cran-spatial" and "r-cran-mapproj" as I remember (otherwise you get error message about that particular missing library).

In my case the scripts etc. were located in 

/media/juhele/data_2TB/_CRAN/ 

so you will need to modify the scripst in order to fit your setup.

# Running download script

Running the scripts is easy - just run terminal from the folder and put there command for aproppriate script.

Downloading script:
```
Rscript downloading_script_v2.R
```
# Fixing the data encoding in linux

The downloading script gives you plenty of ZIP files with CSV inside. These CSV files have CP1250 encoding so the processing script fails as there is no encoding explicitly defined in the scripts so default system is used and linux expects UTF-8.

My clumsy solution was to extract all the CSV files in one folder and then use this code (requires "iconv" package installed) which converts all CSV file in the same folder from CP1250 to UTF-8 encoding:
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
this script creates new CSV files in UTF-8 encoding so you will have the files twice like this:

```
B1BLAT01_SRA_N.csv
B1BLAT01_SRA_N.utf8.csv
```
so just place the files without ".utf8" in other folder and then open terminal and run:
```
rename 's/.utf8//' *.csv
```
to remove the  ".utf8" from the file names. Not sure if this is necessary for the processing script but I wanted to keep the same names to be sure.

# The processing script expects ZIP file(s) in input folder

Instead of trying to edit the script I rather packed all the UTF-8 CSV files in a ZIP file in the "input" folder.
I was worried that the script required having each CSV in its own ZIP archive, but fortunately putting all the CSVs into one ZIP archive like:

```
SRA_UTF8.zip
```
worked without problems.


# Running processing script

to process downloaded data:

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

precipitation
```
Rscript unzip_process_4_SRA.R
```

It might be probably possible to merge these scripts to process all the parameters at one time but I have no experience with R-project so I just used them one by one.

# Converting the resulting .RData files in CSV

Despite having all the scripts and data in: 

/media/juhele/data_2TB/_CRAN/ 

the R-Project working folder seems to be /home by default. So easiest way was to copy the .RData files in my Home folder and then convert them:
If you did not make any changes in the scripts regarding parameter names (changing path does not matter) then you simply open terminal from your home folder and use this:

mean air temperature
```
R
> load("airTmean_merged.RData")
> ls()
[1] "airTmean"
> write.csv(airTmin,"airTmin.csv") 
q()
```

minimum air temperature
```
R
> load("airTmin_merged.RData")
> ls()
[1] "airTmin"
> write.csv(airTmin,"airTmin.csv") 
q()
```

maximum air temperature
```
R
> load("airTmax_merged.RData")
> ls()
[1] "airTmax"
> write.csv(airTmax,"airTmax.csv") 
q()
```

precipitation
```
R
> load("precip_merged.RData")
> ls()
[1] "precip"
> write.csv(precip,"precip.csv") 
q()
```
resulting CSV looks like this:

```
"","date","B1BOJK01","B1BYSH01","B1BZEN01",...
"1","1961-01-01",NA,0.3,0.5,1.2,...
"2","1961-01-02",NA,0.6,0.3,0.9,...
"3","1961-01-03",NA,4.6,3.1,3.9,...
```
