# car

- car: To search DMV CSV file for data
  flags: -a, print info for specific car by the plate number
         -n, count the results
         -c, print results sorted by years
         -f, print the full line from the file
         
         
- getlist.sh: find and download the link to the full car data list for the DMV CSV file

- getdegem.sh: find and download the link to the car models list for the DMV CSV file 


# Example:
```
daniel@DESKTOP-PPNVIGV:~/cars$ car BRZ | tail
17403902 2020 2.0I 2020-06-21
17444002 2020 2.0I 2020-06-22
80020101 2020 2.0I 2020-12-31
80060601 2020 2.0I 2021-03-08
80070701 2020 2.0I 2021-05-31
80080101 2020 2.0I 2020-12-31
80090001 2020 2.0I 2021-01-15
80099901 2020 2.0I 2021-01-22
80170701 2020 2.0I 2021-02-24
80177101 2020 2.0I 2021-05-16

daniel@DESKTOP-PPNVIGV:~/cars$ car 80177101 -a
BRZ - 2.0I - 1998 cc - 200 hp
801-771-01
2020
Gear: Manual
Rishoi: 5
Test until: 2021-05-16

daniel@DESKTOP-PPNVIGV:~/cars$ car BRZ -c
2012 - 10
2013 - 14
2014 - 16
2015 - 8
2016 - 6
2017 - 17
2018 - 14
2019 - 45
2020 - 21

Total:  151
```

You can add the get* files to crontab to run once a day and getting the latest file from the DMV.
```
0 0 * * * /home/daniel/getlist.sh
```
