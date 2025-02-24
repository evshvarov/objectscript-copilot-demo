## intersystems objectscript copilot excercise
The ObjectScript code in the repository is created via copilot AI
See the related video demonstrating code generation

Code works, includes basic math operations, basic global operations, persistent class and records creation and REST API  follow the instructions below to try its functionality

## Installation

Clone/git pull the repo into any local directory

```
$ git clone git@github.com:evshvarov/objectscript-copilot-demo.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test it

Create random records:

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>do ##class(shvarov.copilot.Persistent).AddRandomValues()
```
### Test REST API
open the server/copilot/records link to receive back the sample data from server
