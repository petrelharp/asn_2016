# load results from experiments
speed.files <- list.files("habitat-speeds",".*R",full.names=TRUE)
names(speed.files) <- gsub("[-_]"," ",gsub("_speed.*R","",basename(speed.files)))
speed.results <- lapply( speed.files, function (fn) {
            this.env <- new.env()
            source(fn,local=this.env)
            # should be only one thing
            get(ls(this.env),this.env)
    } )
