Parser JSON to XML made in LEX
======
**Description :** This project is made to parse a specific JSON file into the XML conresponding
The specific JSON is describe by the **JSON_schema.json**
The XML is describe with the doctype file **DTD.xml**


##Required :
**gcc**
debian :
```
$ sudo apt-get install gcc
```
**archlinux**
```
$ pacman -S gcc
```

**lex**
debian :
```
$ sudo apt-get install flex
```
**archlinux**
```
$ pacman -S flex
```

##Generate the runfile :
```
$ cd <path of this repo>/src
$ ./newline Parseur_JSON_to_XML
```

##Run the application :
with the trace.json (the selected file we use)
**output on the command line**
```
$ ./Parseur_JSON_to_XML < trace.json
```
**output inside a new file**
```
$ ./Parseur_JSON_to_XML < trace.json > generated.xml
```

##Contributors :
Raphaël KUMAR

Günther JUNGBLUTH
