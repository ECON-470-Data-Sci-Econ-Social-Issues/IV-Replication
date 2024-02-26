# delimit ;
capture log close;
log using d:\statprog\16andpregnant\aer_revise\dma_characteristics.log, replace;

***********************

DMA_CHARACTERISTICS

***********************

This program estimates some descriptive statistics designed to characterized
what a DMA is;

* first start out with county population;
clear;
use d:\data\vitalstats\16andpregnant\countypop2009.dta;

keep state county year agegrp tot_pop;

keep if agegrp == 99;   * keep all ages;
replace year = 2000 + year - 2;
keep if year == 2008;

rename state stfips;
rename county ctyfips;

keep stfips ctyfips tot_pop;
sort stfips ctyfips;
save d:\data\vitalstats\16andpregnant\temp1.dta, replace;

*merge on the counties identifying which DMA each county is in and calculate
the total population in each DMA;

sort stfips ctyfips;
merge m:1 stfips ctyfips using d:\data\vitalstats\16andpregnant\countytodma.dta;
tab _merge;
drop _merge;
save d:\data\vitalstats\16andpregnant\temp1.dta, replace;

sort dmacode dmaname;
collapse (count) numcty=stfips, by(dmacode dmaname);

sum numcty, detail;
clear;

* determine how many DMAs contain counties in multiple states;

use d:\data\vitalstats\16andpregnant\temp1.dta;

sort dmacode dmaname stfips;
collapse (sum) tot_pop, by(dmacode dmaname stfips);
drop if dmacode == .;
sort dmacode dmaname;

collapse (count) stfips, by(dmacode dmaname);
tab stfips;
sum stfips;

* back at the DMA level, generate the total population in each DMA;

clear;
use d:\data\vitalstats\16andpregnant\temp1.dta;
sort dmacode dmaname;
collapse (sum) dmatotpop=tot_pop, by(dmacode dmaname);

sum dmatotpop, detail;

erase d:\data\vitalstats\16andpregnant\temp1.dta;
log close;


