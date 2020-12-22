These are modified R-project processing scripts. Originals made by Matěj Man, modified by me.

In my case the scripts etc. were located in 

/media/juhele/data_2TB/_CRAN/ 

so you will need to modify the scripst in order to fit your setup.
Running the scripts is easy - just run terminal from the folder and put there command for aproppriate script:

Rscript unzip_process_1_airTmean.R

Rscript unzip_process_2_airTmin.R

Rscript unzip_process_3_airTmax.R

Rscript unzip_process_4_SRA.R

Remark: this does not solve the encoding problem - the downloaded files are in CP1250 but there is no encoding explicitly defined in the scripts so default system is used and linux expects UTF-8 - so the processing fails.
