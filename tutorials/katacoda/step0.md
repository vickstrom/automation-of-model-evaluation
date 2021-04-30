### Tutorial Outline

The generel steps to complete our goal is described below. In further sections, there will be more detailed instructions.

1. A server that listens on pull request events.     
    For every event on GitHub, you have the option to specify an HTTP endpoint where you want to retrieve data regarding the event. In our case, we want to listen to the event of __setting a label__ on a pull request event. To listen, we need to create a webserver than listens for a __PUSH event__ for a specific endpoint. To be able to specify which endpoint and later on access the [GitHub API](https://docs.github.com/en/rest), we need to install our own [GitHub App](https://docs.github.com/en/developers/apps) on the specific repository.
   
2. Evaluate the model inside the pull request.  
   The data in this event contains the necessary information to evaluate the changes in the pull request. With this, we will clone the repository, evaluate and compare both the __HEAD__ and the __BASE__ of the pull request. Then we train and test the model against the test sets for each version of the code. This will be done by executing shell-commands via Python.

3. Comment the results   
   The result from the evaluation will be sent as comment on a pull request via the [GitHub API](https://docs.github.com/en/rest). To do this, we need to authenicate via our [GitHub App](https://docs.github.com/en/developers/apps). 

<!--- __PROOF OF CONCEPT__ AND SHOULD NOT BE USED IN __PRODUCTION__. --->

<!-- > ⚠️ The application created assumes that the code in the pull request is safe, if an unauthorized person decide to put in faulty code, it would run on your server. Proper security measures needs to be added. ⚠️️️️️ -->

### Prerequisites
As this tutorial makes use of GitHub itself, there are some prerequisites to do every part of this tutorial: 
- A GitHub account
- A public GitHub repository containing a machine learning model. 
  - We have included a repository containing a basic model which you can fork (see next step). 

Lets start!