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

Remark: this does not solve the encoding problem - the downloaded files are in CP1250 but there is no encoding explicitly defined in the scripts so default system is used and linux expects UTF-8 - so the processing fails.
