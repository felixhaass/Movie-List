# we need RCurl for curlEscape & json for reading the OMDB output
library(RCurl)
library(rjson)

# setwd() to movie directory

#create a list of movie names in the working directory
movie_names <- dir()

#clean movie names from special characters such as [,(, and - to get better search results
movie_names <- sub(" \\[.*", "", movie_names)
movie_names <- sub("\\[.*", "", movie_names)
movie_names <- sub(" \\(.*", "", movie_names)
movie_names <- sub("\\(.*", "", movie_names)
movie_names <- sub(" \\-.*", "", movie_names)

IMDBcat <- c("Title", "Year", "Rated", "Released", "Runtime", "Genre", "Director", "Writer", "Actors", "Plot", "Poster", "imdbRating", "imdbVotes", "imdbID", "Type", "Response", "Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short")
cat_names <- c("Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short")


#Preparing the API
api <- c("http://www.omdbapi.com/?t=")


movie_list <- data.frame(t(rep(NA,length(IMDBcat))), stringsAsFactors=FALSE)
names(movie_list) <- IMDBcat
movie_list[length(movie_names), ] <- NA
  

i <- 1

while (i <= length(movie_names)){
  
  #getting data from OMDB
  search <- paste(api, curlEscape(movie_names[i]), sep='') #this gives us the URL for the API
  film <- getURL(search) #save the search result for the movie name in film
  
  #parse resulting JSON
  parser <- newJSONParser()
  parser$addData( film )
  
  #saving film data
  film_parsed <- parser$getObject()
  
  #checking whether movie was found in OMDB (a successful query results in 16 columns)
  if (length(film_parsed)==16) {
    
    #assigning categories
    categories <- c(rep(0, 7))
    
    #search for categorie names in "Genre" and assign 1 to category if found
    for (x in 1:7) {
      if(grepl(cat_names[x], film_parsed$Genre)) categories[x] <- 1 
    }
    film_parsed[c("Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short")] <- categories
    
    #adding movie data to final list
    movie_list[i, ] <- film_parsed
    rm(film_parsed)
  }
  
  #create error entry
  else {
    error_msg <- data.frame(t(rep(NA,length(IMDBcat))), stringsAsFactors=FALSE)
    names(error_msg) <- IMDBcat
    error_msg <- error_msg[-1,]
    
    # put in the output which movie wasn't found
    error_msg[1, 1] <- movie_names[i] 
    
    movie_list[i, ] <- error_msg
    rm(error_msg)
  }
  
  i <- i+1
}

rm(movie_names, IMDBcat, api, film, parser, search)
write.table(movie_list, "Movie List.csv", sep=",", col.names=T, row.names=F)
