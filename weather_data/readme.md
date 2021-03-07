
## Historická meteo data České Republiky pro období 1961-2019

![meteo icon](img/meteo_ikony_vse.png)

## Úvod

K dispozici jsou data denních teplot vzduchu (minimální, průměrné, maximální) a denních srážkových úhrnů za období 1961-2019, která zpřístupnil Český hydrometeorologický ústav (dále jen „ČHMÚ“) v souladu se zákonem 123/1998 Sb. o právu na informace o životním prostředí:

https://www.chmi.cz/historicka-data/pocasi/denni-data/Denni-data-dle-z.-123-1998-Sb

## Podmínky užití dat

Podmínky užití dat jsou uvedeny zde na webu ČHMÚ:

https://www.chmi.cz/files/portal/docs/meteo/ok/denni_data/Podminky_uziti_udaju.pdf

PDF verzi dokumentu výše a odkaz na web obsahuje i každý datový balíček.

## CSV data

Jedná se o data denních teplot vzduchu (minimální, průměrné, maximální) a denních srážkových úhrnnů za období 1961-2019, stažená za pomocí zde zveřejněných skriptů pro R-project, které pocházejí z:
https://github.com/manmatej/chmu-process

a byly upraveny pro pro běh v operačním systému GNU/Linux. V důsledku toho mají i výsledná data kódování UTF-8 místo původně použitého CP1250. Jinak nebyla tato data nijak upravována.

## Odvozená měsíční data

### Odvozené měsíční srážkové úhrny (CSV)

S ohledem na problémy při snaze svépomocí upravit skripty pro R-project ke stažení a zpracování měsíčních dat ČHMÚ jsem nakonec přistoupil k jejich napočítání z dat denních. Při zpracování dělaly problém hodnoty "NA" pro chybějící data, ze kterých se při některých výpočtech stávaly nuly a bylo potřeba je odlišit od regulérních nulových srážek. Proto byly hodnoty "NA" následně nahrazeny za údaj "-999" aby ve výpočtech (např. programem SAGA-GIS) bylo možné tuto hodnotu nastavit jako "žádná data" a program je nezahrnul do výpočtu (např. interpolace).

Pro případný výpočet obdobného typu dat jako jsou "Územní srážky" byly vypočteny tzv. normálové hodnoty - "Standardní klimatické normály dle WMO jsou počítány jako 30leté průměry teploty, srážek a dalších klimatických prvků."
viz:

PŘECHOD NA KLIMATICKÝ NORMÁL 1981 – 2010

Lenka Crhová, Slávek Podzimek, 2017-06-07  07:01 UTC

http://www.infomet.cz/index.php?id=read&idd=1496819280

Normálové hodnoty byly tedy počítány pro jednotlivé meteo stanice, jako průměry pro období 1961-1990 a 1981-2010, v tabulkovém procesoru LibreOffice Calc, s využitím funkce "AVERAGEIF" aby bylo možné vyloučit z výpočtu hodnoty "NA" či "-999".

V datasetu jde o sloupce obsahující "N", rok konce období normálu a číslo měsíce:

pro 1961-1990 např. N1990_12	

pro 1981-2010 např. N2010_01

Pokud má normálová hodnota velikost -999, pak pro dané období a stanici nebyla data srážek k dispozici.

Ačkoliv byla tato odvozená data průběžně namátkově kontrolována, nemůže autor po formální stránce garantovat jejich bezchybnost a jejich další použití je tedy na vlastní riziko.

### Odvozené měsíční průměrné denní teploty (CSV)

Postup výpočtu byl obdobný jako u srážek výše, využita byla denní data "Průměrná denní teplota vzduchu" uvolněná ČHMÚ. Hodnota pro NoData byla změněna na "-99999", což je hodnota jakou SAGA-GIS bere defaultně jako NoData, aniž by bylo potřeba cokoliv nastavovat. To se hodí především pro dávkové zpracování dat s pomocí skriptů. Postupně je v plánu takto zpětně opravit i předchozí datasety...

Ačkoliv byla tato odvozená data průběžně namátkově kontrolována, nemůže autor po formální stránce garantovat jejich bezchybnost a jejich další použití je tedy na vlastní riziko.



## GIS data

### Odvozené měsíční srážkové úhrny (GIS data)

### Odvozené měsíční průměrné denní teploty (GIS data)

Autorem skriptu pro získání dat polohy stanic je Oto Kaláb: https://github.com/kalab-oto/chmu-poloha-stanic a data samotná byla beze změn převzata z https://github.com/manmatej/chmu-process. 

Data jsou ve standardním formátu OGC GeoPackage (https://www.geopackage.org) a souřadnicovém systému EPSG:32633 - WGS 84 / UTM zone 33N (https://epsg.io/32633). Atributová tabulka nicméně obsahuje i původní souřadnice v systému EPSG:4326 - WGS 84 (https://epsg.io/4326) (GPS souřadnice). Jako ukázka je ve výchozím stavu použit přechodový styl s odstupňováním barev podle měsíce listopadu 2019.

### Odvozená územní měsíční srážková data (GIS data)

Cílem bylo získat z dat uvolněných ČHMÚ obdobná data jako jsou uváděné [Územní srážky](https://www.chmi.cz/historicka-data/pocasi/uzemni-srazky), která jsou ovšem publikována pod licencí [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/3.0/cz/), která brání jejich dalšímu zpracování: "Nezasahujte do díla — Pokud dílo zpracujete, zpracujete s jinými díly, doplníte nebo jinak změníte, nesmíte toto upravené dílo dále šířit."

Výše uvedená data odvozených měsíční srážkový úhrnů byla interpolována v programu SAGA-GIS (http://www.saga-gis.org) s využitím metody Multilevel B-Spline, cellsize 100 m. Interpolační algoritmus pracuje v obdélníkové oblasti, ale pro potřeby budoucího ořezu dat byla tato oblast nastavena větší, podle hranic ČR s 10 km přesahem (buffer). Program byl nastaven tak, aby do interpolace nebyly zahrnuty body stanic, které v dané období neměly k dispozici žádná data (ve výše zmíněném datasetu hodnoty -999).

GIS data administrativního členění ČR byla převzata z Registru územní identifikace, adres a nemovitostí (RÚIAN), která poskytuje Český úřad zeměměřický a katastrální (dále jen „ČÚZK“) pod licencí [CC BY](https://creativecommons.org/licenses/by/4.0/legalcode.cs).

![zdrojová data pro interpolaci](img/SAGA-GIS_interpolace1_body.jpg)

Výstupem je tedy obdélníková interpolovaná mapa, která po ořezu může vypadat asi takto:

![Ukázka výstupu interpolace](img/SAGA-GIS_interpolace2_spline.jpg)

Kvůli zatím nedořešené automatizaci procesu byla provedena pouze interpolace manuálně spuštěná přes SAGA_GUI pro vybraná data a normálnové hodnoty.
Výpočet hodnot pro jednotlivé polygony z interpolovaných dat byl proveden opět v SAGA-GIS modulem Grid Statistics for Polygons. S ohledem na velkou náročnost na výkon bylo po počátečních testech upuštěno od varianty výpočtu "polygon wise (cell area weighted)" a byla použita jednodušší "simple and fast". Výsledek byl zaokrouhlen na celá čísla, stejně jako data územních srážek prezentovaná na webu ČHMÚ.

#### Odvozené územní měsíční normálové srážkové úhrny (GIS data)

Data jsou ve formě vektorové polygonové vrstvy, opět standardním formátu OGC GeoPackage (https://www.geopackage.org) a souřadnicovém systému EPSG:32633 - WGS 84 / UTM zone 33N (https://epsg.io/32633). 

![Odvozené územní normálové srážky](img/QGIS_uzemni_normalove_srazky.jpg)

Atributová tabulka obsahuje územní normálové hodnoty měsíčních srážek - tj. průměry pro období 1961-1990 a 1981-2010 pro jednotlivé kraje ČR. Vektorová vrstva hranic krajů pochází z Registru územní identifikace, adres a nemovitostí (RÚIAN), která poskytuje Český úřad zeměměřický a katastrální (dále jen „ČÚZK“) pod licencí [CC BY](https://creativecommons.org/licenses/by/4.0/legalcode.cs).

#### Odvozené územní měsíční teploty vzduchu (celá ČR, kraje, okresy, obce)

Data pro oblast celé ČR jsou pouze ve formě CSV a Excel tabulky (.XLSX), protože v tomto případě napojení na GIS data nedávalo příliš smysl. Ostatní datové sady již obsahují i GIS vrstvu.

##### Oblast celé ČR

Tabulka obsahuje územní hodnoty odvozených měsíčních teplot vzduchu - tj. průměry pro období 1961-1990 a 1981-2010 pro oblast ČR. Vypočteny byly hodnoty pro minimum, maximum a průměr - tj. vždy 3 hodnoty pro daný měsíc a oblast celé ČR. Obdobně jako v datech "Územní teploty" byla i zde vypočítaná odchylka od normálu (hodnoty "mean") a to jak pro normál 1961-1990 (sloupce obsahující N1990) tak i pro 1981-2010 (sloupce s N2010).

Ačkoliv byla tato odvozená data průběžně namátkově kontrolována, nemůže autor po formální stránce garantovat jejich bezchybnost a jejich další použití je tedy na vlastní riziko.

Soubor ke stažení:

[CHMU_10_odvozena_data_uzemni_teploty_adm0_CZ.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_10_odvozena_data_uzemni_teploty_adm0_CZ.tar.gz)

##### Kraje ČR

S ohledem na rozsáhlost dat bylo jak při zpracování, tak následně i pro hotové vrstvy přistoupeno k rozdělení na několik menších částí (kromě dat pro celou ČR). 
K dispozici jsou data pro kraje a období 1961-1970, 1971-1980, 1981-1990, 1991-2000 a obsahují i hodnoty odchylek vůči oběma normálům. 
Na obrázku níže jsou na ukázku zobrazeny hodnoty pro červen 1967:

![Odvozené územní srážky - ukázka pro červen 1967](img/CHMU_teploty_1967_06_QGIS.jpg)

Pro výpočet byla využita interpolovaná data z předchozích kroků, výpočet byl proveden v SAGA GIS modulem "Grid Statistics for Polygons". Při zpracování byla využita vektorová vrstva hranic ČR z Registru územní identifikace, adres a nemovitostí (RÚIAN), která poskytuje Český úřad zeměměřický a katastrální (dále jen „ČÚZK“) pod licencí [CC BY](https://creativecommons.org/licenses/by/4.0/legalcode.cs).

Ačkoliv byla tato odvozená data průběžně namátkově kontrolována, nemůže autor po formální stránce garantovat jejich bezchybnost a jejich další použití je tedy na vlastní riziko.

Soubory ke stažení:

[CHMU_11_odvozena_data_uzemni_teploty_1961_1970_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_11_odvozena_data_uzemni_teploty_1961_1970_adm1_kraje.tar.gz)

[CHMU_12_odvozena_data_uzemni_teploty_1971_1980_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_12_odvozena_data_uzemni_teploty_1971_1980_adm1_kraje.tar.gz)

[CHMU_13_odvozena_data_uzemni_teploty_1981_1990_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_13_odvozena_data_uzemni_teploty_1981_1990_adm1_kraje.tar.gz)

[CHMU_14_odvozena_data_uzemni_teploty_1991_2000_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_14_odvozena_data_uzemni_teploty_1991_2000_adm1_kraje.tar.gz)

[CHMU_15_odvozena_data_uzemni_teploty_2001_2010_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_15_odvozena_data_uzemni_teploty_2001_2010_adm1_kraje.tar.gz)

[CHMU_16_odvozena_data_uzemni_teploty_2011_2019_adm1_kraje.tar.gz](https://github.com/juhele/chmu-process/blob/master/weather_data/CHMU_16_odvozena_data_uzemni_teploty_2011_2019_adm1_kraje.tar.gz)

### Reference:

[SAGA-GIS Tool Library Documentation (v7.3.0) - Tool Multilevel B-Spline](http://www.saga-gis.org/saga_tool_doc/7.3.0/grid_spline_4.html)

Lee, S., Wolberg, G., Shin, S.Y. (1997): Scattered Data Interpolation with Multilevel B-Splines. IEEE Transactions On Visualisation And Computer Graphics, Vol.3, No.3., p.228-244. [available from ResearchGate](https://www.researchgate.net/profile/George_Wolberg/publication/3410822_Scattered_Data_Interpolation_with_Multilevel_B-Splines/links/00b49518719ac9f08a000000/Scattered-Data-Interpolation-with-Multilevel-B-Splines.pdf).

[SAGA-GIS Tool Library Documentation (v7.3.0) - Tool Grid Statistics for Polygons](http://www.saga-gis.org/saga_tool_doc/7.3.0/shapes_grid_2.html)
