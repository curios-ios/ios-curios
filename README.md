# InstaRecipe

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview
### Description
InstaRecipe is a social media platform, but for recipes! You can share your own recipes, like and comment on other recipes, and even make changes to the recipes you like and re-share them!

### App Evaluation
- **Category:** Social Media / Cooking
- **Mobile:** Primarily for mobile users, but it could be expanded to have a web component as well
- **Story:** Users can scroll through their recipe feed, and interact with three different ways: like, comment, and fork
- **Market:** Anyone with an interest in cooking can try out this app
- **Habit:** The users can use the app based on how often they want to explore new recipes
- **Scope:** In the beginning we will let the users scroll through all the available recipes. Later on, we can add a 'friends' feature, so that users will only see their friends' recipes on their feed. We can also develop a recommendation engine for an 'explore' section, where users will be able to explore recipes based on their habit on the app.

## Product Spec

### 1. User Stories (Required and Optional)

<!-- **Required Must-have Stories**

* Login
* Register
* User can create a class (they are the instructor).
* User can create posts (ask questions)
* User can answer to posts (with distinguishment between instructor and student answer) -->

**Required Must-have Stories**

* Login
* Register
* User can create and update a recipe 
* User can scroll through existing recipes, like and fork them
* Users can view their profiles (will include list of recipes forked)

<!-- **Optional Nice-to-have Stories**
* User can create a group (of students).
* Users can upvote posts
* Users can view their profiles (Will include classes enrolled, graduation date)
* Users can type in markdown
* If instructors upvote a student's answer, it highlights it (endorses it) -->
**Optional Nice-to-have Stories**
* Users can comment on recipes
* Users can send and receive follow requests
* Users will be recommended recipes via a recommendation engine: an explore section
* Users can chat with the people they are following


### 2. Screen Archetypes

* Login Screen
   * User can login
* Registration Screen
   * User can create a new account
* Create Recipe Screen
   * User can create a recipe
* View Recipes Screen
   * Users can explore existing recipes
* Profile Screen
    * Users can view their profile    
 

### 3. Navigation

<!-- **Tab Navigation** (Tab to Screen)

* Home Feed (View Recipes)
* Create Recipe (Add Button)
* Profile

Optional:
* Settings -> Dark Mode
* Stories -->

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Create Recipe -> Add Recipe Modal -> Back to Feed with new recipe added
* Profile Bubble on top right -> Profile screen
* Add Recipe on top left -> Add Recipe Modal -> Back to My Posts


## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
