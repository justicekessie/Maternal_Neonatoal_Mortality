spss_labels <- function(sav_data, sav_map = NULL) {
      data <- haven::read_sav(sav_data)
     if(!is.null(sav_map)) {
        ##Creates script folder
        ifelse(!dir.exists(file.path("./", "Scripts")), 
               dir.create(file.path("./", "Scripts")), FALSE)
        ### imports the map from SPSS
        
        map_data <- readLines(sav_map)
        i <- 0
        # Generating a data frame with columns v1 to v3 initialized with empty strings
        result <- data.frame(v1 = '', v2 = '', v3 = '')
        for ( r in c(1:length(map_data))){
          i<- i+1
          result[i,] <- stringr::str_split_fixed(map_data[r], " {2,}", 3) # at least two white spaces, eight elements 
        }
         clean_result  <- result |>
           dplyr::as_tibble() |>
           dplyr::filter(v3 !='') |>
           dplyr::filter(v2 != '(record type)') |>
           dplyr::mutate(v3 = ifelse((v1 != '' & v3 != ""),'',v3))
         row_to_start <- which(clean_result$v1 == "Item Name")
         clean_result2 <- clean_result[row_to_start:nrow(clean_result),]
         ##Variable labels 
        variable_label <- clean_result2 |>
          dplyr::filter(v1 !="") |>
          dplyr::filter(!grepl(' ', v1))|>
          dplyr::mutate(
            variable_label = paste(v1, ' = "',v2,'",' ),
            variable_label = ifelse (dplyr::row_number()== 1,"data = expss::apply_labels(data,", variable_label),
            variable_label = ifelse (dplyr::row_number() == dplyr::n(),gsub('",','")',variable_label), variable_label)
          )
        writeLines(variable_label$variable_label,paste("./Scripts/","Variable Labels " ,gsub('.MAP|.map','.R',basename(sav_map)) ,sep = ''))
        ###value label 
        value_label <- clean_result2 |>
          dplyr::mutate(
            v3 = gsub("'"," ",v3),
            v1 = ifelse(v1 == '', NA, v1)) |>
          tidyr::fill(v1, .direction = 'down') |>
          dplyr::filter(v3 != '') |>
          dplyr::mutate(
            v4 = paste('"', v3, '" =',v2)
          ) |>
          dplyr::filter(stringr::str_detect(v2,"^\\s*[0-9]*\\s*$"))|>
          dplyr::group_by(v1)|>
          dplyr::mutate(
            labels = paste(v4, collapse = ", ", sep = ',')
          ) |>
          dplyr::slice(1)|>
          dplyr::ungroup() |>
          dplyr::mutate(
            value_label = ifelse((dplyr::row_number()== 1),paste(v1,' = c(',labels,')',sep = ''),paste(v1,' = c(',labels,'),',sep = '')),
            value_label = ifelse(dplyr::row_number()== 1,paste("data = expss::apply_labels(data,",value_label,',', sep = '' ), value_label),
            value_label = ifelse(dplyr::row_number() == dplyr::n(),gsub('),','))',value_label), value_label)
          ) |>
          dplyr::select(value_label)
         writeLines(variable_label$variable_label,paste("./Scripts/","Value Labels " ,gsub('.MAP|.map','.R',basename(sav_map)) ,sep = ''))
         source(paste("./Scripts/","Value Labels " ,gsub('.MAP|.map','.R',basename(sav_map)) ,sep = ''), local = TRUE)
         source(paste("./Scripts/","Variable Labels " ,gsub('.MAP|.map','.R',basename(sav_map)) ,sep = ''), local = TRUE)
         
     }
      return(data)
}


data_frames <- c()
data_notes<- c()
for (folder in c(list.files('./Data',full.names = TRUE))) {
  print(paste(folder,"on"))
  for (subfolder in  c(list.files(folder, pattern = 'SAV|sav', full.names = TRUE))) {
      data_frames[[gsub('.SAV|.sav','',basename(subfolder))]] <-  spss_labels(sav_data = subfolder, sav_map = list.files(folder, pattern = '.MAP|.map', full.names = TRUE))
      print(paste(subfolder, 'generated!'))
      if (length(list.files(folder, pattern = '.DOC|.doc', full.names = TRUE)) == 1) {
        data_notes[[paste(gsub('.SAV|.sav','',basename(subfolder)), 'notes',sep = '')]] <- strsplit(readtext(list.files(folder, pattern = '.DOC|.doc', full.names = TRUE))$text, "\n")[[1]] 
      }
   }
}

table(data_frames$GHVA7IFL_LAST5YEARS$Q110)

