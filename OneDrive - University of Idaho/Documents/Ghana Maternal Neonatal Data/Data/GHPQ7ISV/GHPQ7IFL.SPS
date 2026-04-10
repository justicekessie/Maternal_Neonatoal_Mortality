DATA LIST FILE='C:\COUNTRIES\GH7I\GHPQ7IFL.DAT' RECORDS=1
  /
  QHCLUST     1-4   
  QHNUMBER    5-8   
  QH01        9-10  
  QHREGION   11-12  
  QHDISTR    13-16  
  QHINTD     17-18  
  QHINTM     19-20  
  QHINTY     21-24  
  QHINTNUM   25-28  
  QHRESULT   29-29  
  QHVISITS   30-30  
  QHCONSENT   31-31  
  QHMEMBER   32-33  
  QHWOMEN    34-35  
  QHRESP     36-37  
  QHSUPERV   38-41  
  QHLANGQ    42-43  
  QHLANGI    44-45  
  QHLANGR    46-47  
  QHTRANS    48-48  
  QH100H     49-50  
  QH100M     51-52  
  QHBABIES   53-53  
  QHNOFAM    54-54  
  QHTEMP     55-55  
  QHINTC     56-59  
  QHINTCD    60-64  
  QHWEIGHT   65-72  
  QHSTRATA   73-76  
  QHWLTHF    77-84  
  QHWLTHI    85-85  
  QHTYPE     86-86  
  QHWLTFUR   87-94  
  QHWLTIUR   95-95  
  QH101      96-97  
  QH102      98-99  
  QH103     100-100 
  QH104     101-103 
  QH105     104-105 
  QH106     106-106 
  QH107     107-108 
  QH108     109-110 
  QH109     111-112 
  QH110     113-113 
  QH111A    114-115 
  QH111B    116-117 
  QH111C    118-119 
  QH111D    120-121 
  QH111E    122-123 
  QH111F    124-125 
  QH111G    126-127 
  QH111H    128-129 
  QH111I    130-131 
  QH112     132-132 
  QH113U    133-133 
  QH113N    134-137  (1)
  QH114A    138-138 
  QH114B    139-139 
  QH114C    140-140 
  QH114D    141-141 
  QH114E    142-142 
  QH114F    143-143 
  QH114G    144-144 
  QH114H    145-145 
  QH114I    146-146 
  QH114J    147-147 
  QH114K    148-148 
  QH114L    149-149 
  QH114M    150-150 
  QH114N    151-151 
  QH114O    152-152 
  QH114P    153-153 
  QH115A    154-154 
  QH115B    155-155 
  QH115C    156-156 
  QH115D    157-157 
  QH115E    158-158 
  QH115F    159-159 
  QH115G    160-160 
  QH115H    161-161 
  QH116     162-162 
  QH117     163-164 
  QH118     165-166 
  QH119     167-168 
  QH120H    169-170 
  QH120M    171-172 
  QH03      173-174 
  QH04      175-175 
  QH05      176-176 
  QH06      177-177 
  QH07      178-179 
  QH08      180-180 
  QH09A     181-181 
  QH09B     182-183 
  QH10      184-185 
  ML07I     186-187 
  ML07F     188-188 
  MLPREG    189-189 
 .
VARIABLE LABELS
   QHCLUST  "Cluster number"
  /QHNUMBER "Household number"
  /QH01     "Line number of member"
  /QHREGION "Region"
  /QHDISTR  "District"
  /QHINTD   "Interview day"
  /QHINTM   "Interview month"
  /QHINTY   "Interview year"
  /QHINTNUM "Interviewer number"
  /QHRESULT "Result of household interview"
  /QHVISITS "Number of household visits"
  /QHCONSENT "Consent agreement"
  /QHMEMBER "Total members in household"
  /QHWOMEN  "Eligible women in household"
  /QHRESP   "Line of household respondent"
  /QHSUPERV "Supervisor number"
  /QHLANGQ  "Language of questionnaire"
  /QHLANGI  "Language of interview"
  /QHLANGR  "Language of respondent"
  /QHTRANS  "Translator used"
  /QH100H   "Hour interview begins"
  /QH100M   "Minutes interview begins"
  /QHBABIES "Babies in the household"
  /QHNOFAM  "Other non-family members in household"
  /QHTEMP   "Other temporal visitors in household"
  /QHINTC   "Date of household interview (CMC)"
  /QHINTCD  "Date of household interview Century Day Code (CDC)"
  /QHWEIGHT "Household weight (6 decimals)"
  /QHSTRATA "Sampling errors stratum"
  /QHWLTHF  "Wealth index factor (5 decimals)"
  /QHWLTHI  "Wealth index quintile"
  /QHTYPE   "Type of place of residence"
  /QHWLTFUR "Wealth index factor for urban/rural (5 decimals)"
  /QHWLTIUR "Wealth index quintile for urban/rural"
  /QH101    "Source of drinking water"
  /QH102    "Source of water for cooking/handwashing"
  /QH103    "Location of source for water"
  /QH104    "Time to water and back (mins)"
  /QH105    "Type of toilet facility"
  /QH106    "Share facilities with other households"
  /QH107    "Number of households sharing toilet"
  /QH108    "Type of cooking fuel"
  /QH109    "Number of rooms used for sleeping"
  /QH110    "Livestock, herds or farm animals"
  /QH111A   "Milk cows"
  /QH111B   "Other cattle"
  /QH111C   "Horses/donkeys/mules"
  /QH111D   "Goats"
  /QH111E   "Sheep"
  /QH111F   "Chickens or other poultry"
  /QH111G   "Pigs"
  /QH111H   "Rabbits"
  /QH111I   "Grasscutter"
  /QH112    "Own land usable for agriculture"
  /QH113U   "Area for agricultural land (unit)"
  /QH113N   "Area for agricultural land (number)"
  /QH114A   "Electricity"
  /QH114B   "Radio"
  /QH114C   "Television"
  /QH114D   "Telephone (non-mobile)"
  /QH114E   "Computer"
  /QH114F   "Refrigerator"
  /QH114G   "Freezer"
  /QH114H   "Generator"
  /QH114I   "Washing machine"
  /QH114J   "Camera"
  /QH114K   "Video/dvd/vcd"
  /QH114L   "Sewing machine"
  /QH114M   "Bed"
  /QH114N   "Table"
  /QH114O   "Chair"
  /QH114P   "Cabinet"
  /QH115A   "Wrist watch"
  /QH115B   "Mobile telephone"
  /QH115C   "Bicycle"
  /QH115D   "Motorcycle or scooter"
  /QH115E   "Animal-drawn cart"
  /QH115F   "Car, Bus or Truck"
  /QH115G   "Boat with a motor"
  /QH115H   "Boat without a motor"
  /QH116    "Bank account"
  /QH117    "Main floor material"
  /QH118    "Main roof material"
  /QH119    "Main wall material"
  /QH120H   "End of household interview (hour)"
  /QH120M   "End of household interview (minutes)"
  /QH03     "Relationship to head"
  /QH04     "Sex of household member"
  /QH05     "Usual resident"
  /QH06     "Slept last night"
  /QH07     "Age of household members in completed years"
  /QH08     "Ever attended school"
  /QH09A    "Level of education attended"
  /QH09B    "Highest grade completed"
  /QH10     "Eligibility for interview"
  /ML07I    "Age corrected from individual questionnaire"
  /ML07F    "Flag for age correction"
  /MLPREG   "Pregnancy status from individual questionnaire"
 .
MISSING VALUE
   QH102    (99)
 .
VALUE LABELS
   QHREGION
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
  /QHRESULT
      1 "Completed"
      2 "No household member at home or no competent respondent at home at time of visit"
      3 "Entire household absent for extended period of time"
      4 "Postponed"
      5 "Refused"
      6 "Dwelling vacant or address not a dwelling"
      7 "Dwelling destroyed"
      8 "Dwelling not found"
      9 "Other"
  /QHCONSENT
      1 "Respondent agrees to be interviewed"
      2 "Respondent does not agree to be interviewed"
  /QHLANGQ 
      0 "English"
      1 "Akan"
      2 "Ga"
      3 "Ewe"
  /QHLANGI 
      0 "English"
      1 "Akan"
      2 "Ga"
      3 "Ewe"
      4 "Guan"
      5 "Mole-dagbani"
      6 "Grusi"
      7 "Gurma"
      8 "Mande"
     96 "Other"
  /QHLANGR 
      0 "English"
      1 "Akan"
      2 "Ga"
      3 "Ewe"
      4 "Guan"
      5 "Mole-dagbani"
      6 "Grusi"
      7 "Gurma"
      8 "Mande"
     96 "Other"
  /QHTRANS 
      1 "Yes"
      2 "No"
  /QHBABIES
      1 "Yes"
      2 "No"
  /QHNOFAM 
      1 "Yes"
      2 "No"
  /QHTEMP  
      1 "Yes"
      2 "No"
  /QHSTRATA
      1 "Central-Urban"
      2 "Central-Rural"
      3 "Greater Accra-Urban"
      4 "Greater Accra-Rural"
      5 "Volta-Urban"
      6 "Volta-Rural"
      7 "Western-Urban"
      8 "Western-Rural"
      9 "Ashanti-Urban"
     10 "Ashanti-Rural"
     11 "Brong Ahafo-Urban"
     12 "Brong Ahafo-Rural"
     13 "Eastern-Urban"
     14 "Eastern-Rural"
     15 "Northern-Urban"
     16 "Northern-Rural"
     17 "Upper East-Urban"
     18 "Upper East-Rural"
     19 "Upper West-Urban"
     20 "Upper West-Rural"
  /QHWLTHI 
      1 "Lowest"
      2 "Second"
      3 "Middle"
      4 "Fourth"
      5 "Highest"
  /QHTYPE  
      1 "Urban"
      2 "Rural"
  /QHWLTIUR
      1 "Lowest"
      2 "Second"
      3 "Middle"
      4 "Fourth"
      5 "Highest"
  /QH101   
     11 "Piped into dwelling"
     12 "Piped to yard/plot"
     13 "Piped to neighbor"
     14 "Public tap/standpipe"
     21 "Tube well or borehole"
     31 "Protected well"
     32 "Unprotected well"
     41 "Protected spring"
     42 "Unprotected spring"
     51 "Rainwater"
     61 "Tanker truck"
     71 "Cart with small tank"
     81 "Surface water (river/dam/lake/pond/stream/canal/irrigation channel)"
     91 "Bottled water"
     92 "Sachet water"
     96 "Other"
  /QH102   
     11 "Piped into dwelling"
     12 "Piped to yard/plot"
     13 "Piped to neighbor"
     14 "Public tap/standpipe"
     21 "Tube well or borehole"
     31 "Protected well"
     32 "Unprotected well"
     41 "Protected spring"
     42 "Unprotected spring"
     51 "Rainwater"
     61 "Tanker truck"
     71 "Cart with small tank"
     81 "Surface water (river/dam/lake/pond/stream/canal/irrigation channel)"
     96 "Other"
  /QH103   
      1 "In own dwelling"
      2 "In own yard/plot"
      3 "Elsewhere"
  /QH104   
    998 "Don't know"
  /QH105   
     11 "Flush to piped sewer system"
     12 "Flush to manhole/septic tank"
     13 "Flush to pit latrine"
     14 "Flush to somewhere else"
     15 "Flush, don't know where"
     21 "Ventilated improved pit latrine"
     22 "Pit latrine with slab"
     23 "Pit latrine without slab/open pit"
     31 "Composting toilet"
     41 "Bucket toilet"
     51 "Hanging toilet/hanging latrine"
     61 "No facility/bush/field"
     96 "Other"
  /QH106   
      1 "Yes"
      2 "No"
  /QH107   
     95 "10 or more households"
     98 "Don't know"
  /QH108   
      1 "Electricity"
      2 "Lpg"
      3 "Natural gas"
      4 "Biogas"
      5 "Kerosene"
      6 "Coal, lignite"
      7 "Charcoal"
      8 "Wood"
      9 "Straw/shrubs/grass"
     10 "Agricultural crop residue"
     11 "Animal dung"
     95 "No food cooked in household"
     96 "Other"
  /QH110   
      1 "Yes"
      2 "No"
  /QH111A  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111B  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111C  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111D  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111E  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111F  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111G  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111H  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH111I  
      0 "None"
     95 "95 or more"
     98 "Unknown"
  /QH112   
      1 "Yes"
      2 "No"
  /QH113U  
      1 "Hectares"
      2 "Acres"
      3 "Plots"
      4 "Poles"
      9 "Special answers"
  /QH113N  
   95.0 "95 or more hectares"
   99.8 "Don't know"
  /QH114A  
      1 "Yes"
      2 "No"
  /QH114B  
      1 "Yes"
      2 "No"
  /QH114C  
      1 "Yes"
      2 "No"
  /QH114D  
      1 "Yes"
      2 "No"
  /QH114E  
      1 "Yes"
      2 "No"
  /QH114F  
      1 "Yes"
      2 "No"
  /QH114G  
      1 "Yes"
      2 "No"
  /QH114H  
      1 "Yes"
      2 "No"
  /QH114I  
      1 "Yes"
      2 "No"
  /QH114J  
      1 "Yes"
      2 "No"
  /QH114K  
      1 "Yes"
      2 "No"
  /QH114L  
      1 "Yes"
      2 "No"
  /QH114M  
      1 "Yes"
      2 "No"
  /QH114N  
      1 "Yes"
      2 "No"
  /QH114O  
      1 "Yes"
      2 "No"
  /QH114P  
      1 "Yes"
      2 "No"
  /QH115A  
      1 "Yes"
      2 "No"
  /QH115B  
      1 "Yes"
      2 "No"
  /QH115C  
      1 "Yes"
      2 "No"
  /QH115D  
      1 "Yes"
      2 "No"
  /QH115E  
      1 "Yes"
      2 "No"
  /QH115F  
      1 "Yes"
      2 "No"
  /QH115G  
      1 "Yes"
      2 "No"
  /QH115H  
      1 "Yes"
      2 "No"
  /QH116   
      1 "Yes"
      2 "No"
  /QH117   
     11 "Natural: Earth/sand"
     12 "Natural: Dung"
     21 "Rudimentary: Wood planks"
     22 "Rudimentary: Palm/bamboo"
     31 "Finished: Parquet or polished wood"
     32 "Finished: Vinyl or asphalt strips"
     33 "Finished: Ceramic/marble/porcelain/tiles/terrazo"
     34 "Finished: Cement"
     35 "Finished: Woolen carpet/synthetic  carpet"
     36 "Finished: Linoleum/rubber carpet"
     96 "Other"
  /QH118   
     11 "Natural: Thatch/palm leaf"
     12 "Natural: Mud/sod"
     21 "Rudimentary: Rustic mat"
     22 "Rudimentary: Palm/bamboo"
     23 "Rudimentary: Wood planks"
     24 "Rudimentary: Cardboard"
     31 "Finished: Zinc/aluminium"
     32 "Finished: Wood"
     33 "Finished: Calamine/cement fiber"
     34 "Finished: Ceramic/brick tiles"
     35 "Finished: Cement"
     36 "Finished: Roofing shingles"
     37 "Finished: Asbestos/slate roofing sheets"
     96 "Other"
  /QH119   
     11 "Natural: Cane/palm/trunks"
     12 "Natural: Mud/landcrete"
     21 "Rudimentary: Bamboo with mud"
     22 "Rudimentary: Stone with mud"
     23 "Rudimentary: Uncovered adobe"
     24 "Rudimentary: Plywood"
     25 "Rudimentary: Cardboard"
     26 "Rudimentary: Reused wood"
     31 "Finished: Cement"
     32 "Finished: Stone with lime/cement"
     33 "Finished: Bricks"
     34 "Finished: Cement blocks"
     35 "Finished: Covered adobe"
     36 "Finished: Wood planks/shingles"
     96 "Other"
  /QH03    
      1 "Head"
      2 "Wife or husband"
      3 "Son or daughter"
      4 "Son-in-law or daughter-in-law"
      5 "Grandchild"
      6 "Parent"
      7 "Parent-in-law"
      8 "Brother or sister"
      9 "Other relative"
     10 "Adopted/foster/step child"
     11 "Not related"
     98 "Don't know"
  /QH04    
      1 "Male"
      2 "Female"
  /QH05    
      1 "Yes"
      2 "No"
  /QH06    
      1 "Yes"
      2 "No"
  /QH07    
     95 "95+"
     98 "Don't know"
  /QH08    
      1 "Yes"
      2 "No"
  /QH09A   
      0 "Pre-Primary"
      1 "Primary"
      2 "Middle"
      3 "Jss/jhs"
      4 "Secondary/Tech/Voc/Comm"
      5 "Sss/Shs/Tech/Voc/Comm"
      6 "Higher"
      8 "Don't know"
  /QH09B   
      0 "Less than 1 year completed"
     98 "Don't know"
  /QH10    
      0 "Not eligible"
  /ML07I   
     95 "95+"
     98 "Don't know"
  /ML07F   
      0 "No data from individual questionnaire"
      1 "Month and year"
      2 "Month and age -y imp"
      3 "Year and age - m imp"
      4 "Y & age - y ignored"
      5 "Year - a, m imp"
      6 "Age - y, m imp"
      7 "Month - a, y imp"
      8 "None - all imp"
  /MLPREG  
      1 "Yes"
      0 "No, don't know"
 .
 EXECUTE.
SAVE OUTFILE='C:\COUNTRIES\GH7I\GHPQ7IFL.sav'.
