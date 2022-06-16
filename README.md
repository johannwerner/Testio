# Testio MVP Read Me

## First Feedback

Good project folder structure, simple and clear code separation;
* No leftovers or boilerplate, dead code, etc;
* UI was recreated accurately;
* MVVM+C architecture with interactors, but interactors do API calls instead of making interaction between UI and ViewModel;
* Lack encapsulation for some code parts;
* Repetitive code for API requests.
* Not so good to have singletons for Persistent or Keychain layers;
* Nice to have unit tests, but it actually isn't testing existing code.


## Not a perfect solution
Due to the limited amount of time I can spend on this and the fact that I did not consult with any other ios developer on this project, there is lots of room for improvement and feedback. 
The app achitecture and certain decisions were done in order to best display my current knowledge and these decisions are not maybe what I would make in a production environment. 
I had to make quick decisions based on the limited amount of time I had to quickly deliver this code challenge.

I played around with a new architecture style so I probably made some mistakes in the process but learned from these mistakes. 
I'm relatively new at RxSwift and still need to learn more about the framework and some decisions resulting from my limited knowledge of RxSwift. 
I would love to hear feedback and improvements.


## Achiteture
The app uses an MVVM-C Rx Architecture potentially more similar to viper than MVVM.

The architecture was a bit of an experiment as I tried to play around with an MVVM-C-RX architecture and was maybe overkill for the solution but was done this way to demonstrate I can create a unique architecture style as well as use existing architectures. 
I chose this architecture mostly to show my skills not only in building an app but coming up with an architecture, even though this architecture a lot can be improved. 

The idea behind the architecture was to have separate frameworks for components UI which is used by each model. A model is like a login view or the server list view.
The idea was to keep these modules completely separate with no dependencies between them except in the coordinator. The only interaction would be by the coordinator of login to give the ServerListCoordinator the dependencies it requires. One could easily delete a module and the app should still compile as long as the code in the coordinator is removed. 
The modules are designed in such a way that they can be easily removed. 

The View Controller (handles view logic)
The View Model (handles business logic)
The use case would fetch get the data from the interactor and handle the data before giving data to the View model.
The interactor API would fetch the data from the backend or local database and conforms to the interactor protocol. 
The interactor is a protocol so for testing purposes you could use an interactor that mocks the data for testing purposes. 

Disadvantages of this architecture
- difficult for new team members to quickly learn it
- lots of files
- set up is time-consuming even using Xcode Templates.
- duplicate boilerplate code
- duplicate code to avoid interdependencies. 

Advantages
- easy to test the use case by passing through a mock interactor
- easy handling of success/loading or error state. 
- able to handle multiple network requests with ease without landing into completion block or delegate hell.  
- no interdependencies

## Shortcomings

The architecture didn't seem like a perfect solution so I found the end relying too much on my reusable components and logic in the view controller.
I should have also created a lot more constants for the app margins than I did. 
In some cases, the naming of variables and functions could be improved but in the interest of moving quickly, I used the names that first come to mind. I tried keeping the same naming style throughout the project.  Usually, I ask for feedback on naming. 

## Still to do

A few things I missed because of time constraints
- proper error handling, didn't have time to dive into Rxswift error handling. 

## Known issues

- error handling was not done well and need a better solution there. 
- Keyboard layout is different on iPhone 8 than design
- The requirements are not clear on when to update from the cache to live data and the switching from cache data to live data potentially leaves users with a bad experience. Possibly should have an update from the cache to the live data button. 
- Simulator has an issue with touch when the keyboard is active. Works on an actual device.

## TOComponents

TOComponents was created as an independent framework so it can be reused in the future with other projects.

## Limitations of testing
I only tested on iPhone 7, iPhone 8 and iPhone 6s devices that I currently have with me.

Due to the fact that I did not have a device with FaceID I was unable to test FaceID but I was able to test TouchID. 


## Test Login details
username: tesonet
password: partyanimal


