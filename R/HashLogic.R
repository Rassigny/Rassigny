#Environment for hashing student email to number
hash.env <- new.env(hash = TRUE, parent = emptyenv(), size = 10000)

#Environment to store student email of current user.
#This is used for avoiding making user input student email unnecessarily repeatedly
#into argument for EvaluateAnswer() function
general.env <- new.env(parent = emptyenv(), size=10000)

#function to store student email of current user to general.env environment
SetStudentEnv <- function(studentEmail) {
  assign("studentEmail", studentEmail, general.env)
}


SetAssignmentEnv <- function(assignmentID) {
  assignmentIDs <- general.env$assignmentIDs
  assignmentIDs <- c(assignmentIDs, assignmentID)
  assignmentIDs <- unique(assignmentIDs)
  assign("assignmentIDs", assignmentIDs, general.env)
}

#Function for assigning number for user's email address
# AssignRandom <- function(key, hash) {
#   value <- sum(utf8ToInt(key))
#   assign.hash(key, value, hash)
# }

#Function to set random seed to generate data.
#This random seed can be used to recreate data for evaluating user's answer
SetRandomSeed <- function(studentEmail) {
  #hash student email address
  hashID <- sum(utf8ToInt(digest::digest(studentEmail, algo = "sha256")))
  #get studentID
  assign("hashID", hashID, hash.env)
  #set random seed
  set.seed(hashID)
}
