# Rassigny
Rassigny is an Open Source project to develop R-packages that enables students to take statistical assignments using R.
 
The key idea in this package is distributing assignments to students and improving their learning experience.

Instructors can use this package to automate the correction process.


## Getting Started
The documentations here gives instructions of use for Rassigny to you as students and instructors.


## Installation

First, make sure you have a working R installation.

[Downloaded the latest version of R](https://www.r-project.org/)


You need to install required packages. 

Run the following command on your R installation

```
install.packages(c("RJSONIO", "jsonlite", "plyr", "pROC", "dplyr", "httr", "logging", "digest", "moments"))
```


## Building the library
If you are an instructor and want to build the library, follow these steps:

1. Navigate to the directory Rassigny.

2. Run code below in commandline (if you are using Windows, install [Rtools](https://cran.r-project.org/bin/windows/Rtools/))
```
R CMD INSTALL --build Rassigny
```

## Adding a new assignment to the library

1. Go to data-raw directory in Rassigny library both on commandline and R. 

### For command line
```
cd path/to/Rassigny/data-raw
```
### For R
```
setwd(path/to/Rassigny/data-raw)
```

2. Add new json file for assignment. When you have dependencies, specify environment of the library with functions.


For example, dplyr::filter().


3. Use the following example JSON skeleton to design your assignments

```
{
	"AssignmentID": "Assignment1",     # Give the assignment unique ID 
	"AssignmentDescription": "Description",   # Briefly describe the problem statement here
	"data":["assignment1_data.R"],            # Include the R file used to generate the data here
	"temp_data":[""],                         # Store all the temporary data needed for computations over here. 
	                                          # This will be evaluated and stored as a list, hence access elements using [[]]
						  
	"defaultRubric": {"feedback":{"smaller":"Wrong Answer!",
				      "equal":"Correct Answer! Perfect!",
				      "bigger":"Wrong Answer!"}}          # Indicates default rubric to be used
				      
	"questions":[{"taskDescription":"paste('What is the c-statistic of this model?')", # Briefly describe required task
		      "CorrectAnswer":"suppressMessages(round(pROC::roc(temp_data[[1]] ~ (predict(glm(temp_data[[1]] ~ temp_data[[2]] + data$heartRate, family = binomial), type=c(\"response\") )))$auc[1],4))", # R Code to generate correct answer
                      "grade":0.05,                                       # Grade if answered correctly
		      "matchingThreshold":0.1,                            # Maximum error allowed
		      "rubricType":"default/custom"    		          # indicates whether to use defualt or custom rubric
		      
		      # if custom rubric is to be used specify it after this using the key "rubric"
				  
	              "rubric":{"lower_limit":"min(data)",               # lower limit for the answer 
			        "upper_limit":"max(data)",               # upper limit for the answer
			        "feedback":{"smaller":"Wrong answer!",   # feedback if entered value is less than the expected range
	                                    "equal":"Correct Answer!",   # feedback if entered value is correct
			                    "between":"Correct Answer!", # feedback if entered value is within the expected range
	                                    "bigger":"Wrong answer!"}    # feedback if entered value is greater than the expected range
    				           }
			       }]
}
```


4. Run add_files.sh on commandline. This will add json object and create binary package one upper level of directory, Rassigny 
```
../add_files.sh
```

5. Test the compiled package:

#### For Mac
```
install.packages("Rassigny.tgz", repos = NULL, type = .Platform$pkgType )
```

#### For Windows
```
install.packages("Rassigny.zip", repos = NULL, type = .Platform$pkgType )
```

#### For Linux
```
install.packages("Rassigny.tar.gz", repos = NULL, type = .Platform$pkgType )
```



## Use case
```
# load library
library(Rassigny)

# First generate data for assignment that you are trying to take with GenerateData() function.
# Put your email address(string) and assignmentID that you are trying to take(integer)

data <- GenerateData("student@bu.edu", assignmentID = 1)

# If you want to check what questions the assignment has, use GetListOfTasks() function.
# taskID parameter is optional. If you specify taskID, you will get only one question for the task.
# Otherwise, you will get list of questions corresponding to assignmentID
task_1_1 <- GetListOfTasks(assignmentID = 1, taskID = 1)

# Compute your answer.
# This can be any numeric number that you calculated for answer.
answer <- sd(data)

# Check the evaluation result.
# Pass variable of you answer(it can be any name) or value of number for answeer, correponding assignmentID and taskID.
EvaluateAnswer(answer, assignmentID = 1, taskID = 1)


# check student results
```
ListOfReviews(password = "PASSWORD", "student@bu.edu", assignmentID = 1)
```
