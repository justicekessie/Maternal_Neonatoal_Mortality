DATA LIST FILE='C:\COUNTRIES\GH7I\GHFW7IFL.DAT' RECORDS=1
  /
  FW101       1-4   
  FW000       5-7    (A)
  FW102       8-9   
  FW103      10-10  
  FW104      11-12  
  FW105      13-13  
  FW106      14-14  
  FW107      15-16  
  FW108      17-17  
  FW109      18-18  
  FW110      19-20  
  FW111      21-22  
  FW112      23-25  
  FW113A     26-26   (A)
  FW113B     27-27   (A)
  FW113C     28-28   (A)
  FW113D     29-29   (A)
  FW113E     30-30   (A)
  FW113F     31-31   (A)
  FW113G     32-32   (A)
  FW113H     33-33   (A)
  FW113I     34-34   (A)
  FW113X     35-35   (A)
  FW114      36-37  
  FW115      38-38  
  FW116      39-39  
  FW117      40-40  
  FW118      41-41  
 .
VARIABLE LABELS
   FW101    "Fieldworker code"
  /FW000    "Country code and phase"
  /FW102    "Fieldworker region of residence"
  /FW103    "Fieldworker type of place of residence"
  /FW104    "Fieldworker age"
  /FW105    "Fieldworker sex"
  /FW106    "Fieldworker marital status"
  /FW107    "Fieldworker number of living children"
  /FW108    "Fieldworker ever had a child who died"
  /FW109    "Highest level of school attended by fieldworker"
  /FW110    "Highest grade/form/year at that level completed by fieldworker"
  /FW111    "Fieldworker religion"
  /FW112    "Fieldworker ethnicity"
  /FW113A   "Akan"
  /FW113B   "Ga"
  /FW113C   "Ewe"
  /FW113D   "English"
  /FW113E   "Guan"
  /FW113F   "Mole-dagbani"
  /FW113G   "Grusi"
  /FW113H   "Gurma"
  /FW113I   "Mande"
  /FW113X   "Other language"
  /FW114    "Fieldworker's mother tongue/native language"
  /FW115    "Has fieldworker ever worked on a DHS"
  /FW116    "Has fieldworker ever worked on any other survey"
  /FW117    "Was fieldworker working for agency at the time employed for DHS"
  /FW118    "Is fieldworker permanent or temporary employed of agency"
 .
VALUE LABELS
   FW102   
      1 "Western"
      2 "Central"
      3 "Greater accra"
      4 "Volta"
      5 "Eastern"
      6 "Ashanti"
      7 "Brong ahafo"
      8 "Northern"
      9 "Upper east"
     10 "Upper west"
  /FW103   
      1 "City"
      2 "Town"
      3 "Rural"
  /FW105   
      1 "Male"
      2 "Female"
  /FW106   
      1 "Currently married"
      2 "Living with a man/woman"
      3 "Widowed"
      4 "Divorced"
      5 "Separated"
      6 "Never married or lived with a man/woman"
  /FW108   
      1 "Yes"
      2 "No"
  /FW109   
      1 "Primary"
      2 "Middle"
      3 "Jss/jhs"
      4 "Secondary"
      5 "Sss/shs"
      6 "Higher"
  /FW110   
      0 "Less than one year at level"
  /FW111   
      1 "Catholic"
      2 "Anglican"
      3 "Methodist"
      4 "Presbyterian"
      5 "Pentecostal/charismatic"
      6 "Other christian"
      7 "Islam"
      8 "Traditional/spiritualist"
     95 "No religion"
     96 "Other"
  /FW112   
      1 "Akan"
      2 "Ga/dangme"
      3 "Ewe"
      4 "Guan"
      5 "Mole-dagbani"
      6 "Grusi"
      7 "Gurma"
      8 "Mande"
     96 "Other"
  /FW113A  
   'A' "Akan"
  /FW113B  
   'B' "Ga"
  /FW113C  
   'C' "Ewe"
  /FW113D  
   'D' "English"
  /FW113E  
   'E' "Guan"
  /FW113F  
   'F' "Mole-dagbani"
  /FW113G  
   'G' "Grusi"
  /FW113H  
   'H' "Gurma"
  /FW113I  
   'I' "Mande"
  /FW113X  
   'X' "Other language"
  /FW114   
      1 "Akan"
      2 "Ga"
      3 "Ewe"
      4 "Guan"
      5 "Mole-dagbani"
      6 "Grusi"
      7 "Gurma"
      8 "Mande"
     96 "Other"
  /FW115   
      1 "Yes"
      2 "No"
  /FW116   
      1 "Yes"
      2 "No"
  /FW117   
      1 "Yes, GHS"
      2 "Yes, GSS"
      3 "No"
  /FW118   
      1 "Permanent"
      2 "Temporary"
 .
 EXECUTE.
SAVE OUTFILE='C:\COUNTRIES\GH7I\GHFW7IFL.sav'.
