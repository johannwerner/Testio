# Testio MVP Read Me


## Not a perfect solution
Due to limit amount of time I can spend on this and the fact that I did not consult with any other ios developer on this project there is lots of room for improvement and feedback. 
The app achiture and certain decisions were done in order to show my current knowledge and these decisions are not maybe what I would make in a production enviroment. 

I played around with a new achiteture style so I probably made some mistakes in the process but learned from these mistakes.
I would love to hear feedback and improvements.


## Achiteture
The app uses an MVVM-C Rx Architecture maybe more similiar to viper than MVVM.

The achitecture was a bit of an exiprement as I tried to play arround with an mvvm-rx achiteture and was maybe over kill for the solution.
I chose this archtiture mostly to show my skills not only building an app but coming up with an achiteture, even though this achiteture alot can be improvement. 

The idea behind the achiteture was to have separe frameworks for components UI which is used by each model. A model is like the login view or the server list view.
The idea was to give these modeles comply separate with no depencies between them. The only interaction would be by the cooridinator of login to give the ServerListCoordinator the dependencies it requires. One could easily delete a module and the app should still compile as long as the code in the coordinator is removed. 

The View Controller (handles view logic)
The View Model (handles business logic)
The use case would fetch get the data from the interactor and handle the data before giving data to the View model.
The interactor api would fetch the data from the backend or local database. 
The interacor is a protocol so for testing purposes you could use an interactor which mocks the data for testing purposes. 
Disadvantages of this achiteture
- difficult for new people to quickly learn it
- lots of files
- set up is time consuming

Advanatages
- easy to test the use case by passing through a mock  
- easy handling of success/loading or error state. 
- able to hanlde mutiple network requests with ease without landing into completion block or delegate hell.  

## Shortcomings

The achitecture didn't seam like a perfect solution so I found at the end relying to much in my resuable compontents and logic in the view controller.
I should have also created a lot more constants for the app margins that what I did. 
In some cases the naming of variables and functions are not optimised. Usually I ask for feedback on naming. 

## Still to do

A few things I missed because of time constraints
- icons for the buttons in the navigation bar
- proper error handling, didn't have time to dive into Rxswift error handling. 
- animation of filter view can be improved.

## Known issues

- error handling was not done well and need a better solution there. 
- tapping on the status bar while filter view will scroll the filter view up. I decided this was a feature and not a bug.
- Top cell divider on first row. Should ideally be removed
- Keyboard layout is different on iPhone 8 than design

## TOComponents

TOComponents was created as a framework

## Limitations of testing
Due to the fact that swift package manager has no control over its packages and swiftrx includes arm64 achitecture when running on simulator I was unable to test on simulator and therefore I only tested on iPhone 7, iPhone 8 and iPhone 6s

Due to the fact that I did not have a device with faceID I was unable to test faceID but was able to test TouchID. 


## Test Login details
username: tesonet
password: partyanimal
