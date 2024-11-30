# GraphORM

## Introduction

This project provides a basic utility to extract a database's schema and automate basic queries, like SELECT, INSERT,  UPDATE, etc.

## Note

This project uses a submodule Utility. The Utility submodule was originally located at:

https://git.prometheussoftware.ca/NodeModule/Utility.git

But the submodule exists also at:

https://gitlab.com/team-prometheussoftware/cpputility.git

When and if the initial prometheussoftware repositories are not used anymore, make the following change in the .gitmodules file of this project:

Old:
```
[submodule "Utility"]
	path = Utility
	url = https://git.prometheussoftware.ca/NodeModule/Utility.git
    
```

New:
```
[submodule "Utility"]
	path = Utility
	url = https://gitlab.com/team-prometheussoftware/cpputility.git
    
```
