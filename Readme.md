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
CouchDB, hosted by Cloudant. 
* Json Document DB
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
Backend allows quick set up of test dataset. 
Frontend is easy to set up for creating a GUI, and games are a good fit for using a Widget framework where writing gui-stuff is cheap. Elm would fit even better if the GUI had more interaction.
Functional programming maps well to this and the problem domain of game logics writing (in my experience). Especially for ensuring that the code is cohesive, epsecially when performing large refactorings.

Implementation details
======================
