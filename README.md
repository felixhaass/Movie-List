This R script searches the Open Movie Database (an API implementation of the IMDB) for information about the movies you have stored in any folder. It returns the movie information, e.g. director, year, genre, plot summary, etc. as a .csv. The script also generates an R data frame with this data, so you can do all sorts of analysis on the movies you're watching.

To function properly, the following requirements must be met:

(1) set your R working directory to the folder where you save your movies
(2) manually name your movie files as exactly as possible to increase the precision of the results
