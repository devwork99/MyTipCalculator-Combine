#  Tip-Calculator

App calculates the tip of the total amount 



## Screen Shots

### ![alt text](https://github.com/devwork99/MyTipCalculator-Combine/blob/main/tip-calculator/Screenshots/tipcal_story.png?raw=true)


###Dependency

Using SPM for dependency management.
SDWebImage
CocoaCombine
SnapshotTesting

###MVVM architecture + Combine
- ViewModel that has all the business logic, fetching data from internet, and converting into formate that is useable for the view
- View is written with SwiftUI and is "Active", it means observe the changes from ViewModel with the Observable Protocol, has direct access to ViewModel
- Model, the business classes or the model objects
- Combine is used to fetch the data from API in the NetworkManager

###Unit Test

Different tests to varify the correct calculation of the Tip.

