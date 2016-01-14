# load results from experiments
speed.files <- list.files("habitat-speeds",".*R",full.names=TRUE)
names(speed.files) <- gsub("[-_]"," ",gsub("_speed.*R","",basename(speed.files)))
speed.results <- lapply( speed.files, function (fn) {
            this.env <- new.env()
            source(fn,local=this.env)
            # should be only one thing
            get(ls(this.env),this.env)
    } )

actual.sigmas <- rbind(
        "central saline" = c(126.2622,856.5154),
        "central scrub" = c(130.2535,911.4445),
        "central wash/wetland" = c(113.5158,768.1860),
        "central woods/chaparral" = c(123.813,809.005),
        "western saline" = c(123.0742,866.4747),
        "western scrub" = c(129.6022,906.3858),
        "western woods/chaparral" = c(126.0158,876.0518),
        "empidonax" = c(67.93892,952.16597),
        "eschscholzia" = c(79.13257,988.03524),
        "xerospermophilus" = c(81.30487,1005.65509),
        "yucca" = c(76.86104,992.72200)
    )
colnames(actual.sigmas) <- c("seed","pollen")
