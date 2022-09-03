library(waveslim)

extract <- function(data, level) {
    # Extract the wavelet coefficients at a given level
    # data: the data to be processed
    # level: the level of the wavelet coefficients to be extracted
    # return: the wavelet coefficients at the given level
    stations <- unique(data$IAGA)
    wf <- "la8"
    boundary <- "reflection"
    N <- 1439
    levels <- floor(log(N, 2))
    
    for (station in stations) {
        single_data <- data[data$IAGA == station,]
        single_data <- single_data[, 5]
        print(single_data)
        data_wavelet.wt <- modwt(single_data, wf = wf, n.levels = levels, boundary = boundary)
        data_wavelet_mra <- mra.wt(data_wavelet.wt)
        data_wavelet[station] <- data_wavelet_mra[[level]]
    }
}

write_to_csv <- function(data, file_name, level) {
    content <- data.frame(Station = c("VIC"), Wavelet = c("dBN"), Level = c(level), Data = data)
    write.csv(content, file_name, row.names = FALSE)
}

read_data <- function(file_name, argument) {
    data <- read.csv(file_name, header = TRUE, sep = ",", fill = TRUE, comment.char = "")
    data <- switch(argument,
        "dbn_nez" = data[, c("Date_UTC", "IAGA", "GEOLON", "GEOLAT", "dbn_nez")],
        "bou_nez" = data$bou_nez
    )
    return(data)
}

process_data <- function(input, output, argument, level) {
    data <- read_data(input, argument)
    data_wavelet_mra <- extract(data, level)
    write_to_csv(data_wavelet_mra, output, level)
}



process_data("D:/Personal/Coding/Space Weather/20031029-supermag.csv", "VIC_dbn.csv", "dbn_nez", 1)
# process_data("D:/Personal/Coding/Space Weather/test.csv", "6_station_dbn.csv", "dbn_nez", 1)





# for (j in 1:levels) {
#     plot(VIC_wavelet_mra_1029dbn[[j]], type = "l", , xlab = "", ylab = "nT")
#     axis(side = 2)
#     title(paste("dBN 20031029, level ", j, sep = ""))
#     print(diff(range(VIC_wavelet_mra_1029dbn[[j]])))
# }
# plot(VIC_csvdata_1029$dbn_nez, type = "l", , xlab = "", ylab = "nT")
# title("dBN 20031029 (raw data)")



# BOU, NEW, BSL, FRD, FRN, TUC