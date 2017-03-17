Rotation - Game of rotating pipes
=================================


Usage
-----
* Install elm: http://elm-lang.org
* At the root of the project; run ``elm-reactor``
 
Choice of Technology
====================
Backend
-------
[CouchDB](https://couchdb.apache.org/) , hosted by [CloudAnt](https://cloudant.com/) . 

* Json Document Store
* Rest
* Functionality: CRUD, List, Search, Search
* Good documentation
* Easy to get started with
* Fairly ok Admin GUI
* Free at low usage
* Possible to host other files in DB; html, js, and effectively the entire app.

Frontend
--------
[Elm](http://elm-lang.org) 

* Functional language that genenerates, amongst other things, html and .js. 
* Great alternative as a whole language with streamlined libs + build environment and package manager, compared to volatile and ever-changing .js + libraries for EVERYTHING
* Great for writing admin/crud apps. Not necessarily for feature-rich customer-facing apps.
* Standardized programming model (widget framework) - " [The Elm Architecture](https://guide.elm-lang.org/architecture/)"
* Way steeper learning curve compared to .js and oo langs. Fluency with functional language; Scala, Haskell (or F#?) is very beneficial.
* Compiler makes refactoring a breeze and sorts out non-logic-related bugs.
* Not so evolved library set
* .js interoperability is not trivial
* Good fit with REST/JSON backend

Match with this task
--------------------

* Backend allows quick set up of test dataset. 
* Frontend is easy to set up for creating a GUI, and games are a good fit for using a Widget framework where writing gui-stuff is cheap. Elm would fit even better if the GUI had more interaction.
* Functional programming maps well to this and the problem domain of game logics writing (in my experience). Especially for ensuring that the code is cohesive, epsecially when performing large refactorings.

Implementation details
======================
* The goal of the algorithm is to produce Game Boards with differing but sane configurations of pipe-combinations.
* The cells are stored in a 2-dimensional list/array, with a hex-values stored as string.

* Board passes.
    * Combinations creation pass - Walk through each cell and find all possible rotations for this cell. Choose one rotation for this pass, and "fork off" the creation of a board alternative. All boards are stored in a list of boards. 
    * Horizontal verification pass. Walks through each cell, remembering the previous cell value. If the combination of the two is erronous, this board is thrown away. 
    * Vertical verification pass. As horizontal, just a different traversion. 
* When choosing which pipe to place inside the current cell, the algorithm will search for eligible pipes "X opening" listset, using the value from this cell, and the cell to the left as input parameters to a search against the "X Opening" dataset. 
    * If more than one rotation is eligible, a new game board will be added to the set of game boards. The original and new game board will now differ by the one pipe.


Pipe set
========
0 0 4╞  8╨  C╚
1╡  5═  9╝  D╩
2╥  6╔  A║  E╠
3╗  7╦  B╣  F╬

X Opening
---------

* Left Opening
    * 1, 3, 5, 7, 9, B, D, F
* Top Opening
    * 8, 9, A, B, C, D, E, F
* Right Opening
    * 4, 5, 6, 7, C, D, E, F
* Bottom Opening
    * 2, 3, 6, 7, A, B, E, F
    
State of implementation
=======================

* GUI mockup working
* Domain name and CouchDB functional

Todo's

* Implement Model
* Implement REST/JSON communication with backend
* Generate test set
* Implement rendering of data set
* Implement algorithm for traversing
* Implement algorithm for selecting eligible pipes  