# XML-Semestral
> A repository for XML semestral project.

- Semester: B211
- Authors:
  - Jakub Vondráček
  - Daniel Šimánek
  - Jiří Heller 

> To generate all files and outputs, please use `./xml-make.bat` command.

Folder `assignment` contains detailed instructions for this project (in Czech).

Folder `areas-html` contains original HTML files downloaded from https://www.cia.gov/the-world-factbook/ and lightly edited so they could be parsed using XML. List of rules used in editing HTML files can be found in file `htmlGuide.md` (in Czech).

Folder `areas-xml` contains XML file for each area generated from HTML files from `areas-html`. XSLT Template used is named `html2xml.xslt` and is located in `scripts` folder. Folder `areas-xml` also contains file Areas.xml, which was generated using `expandAreas.xslt` template and `AreasMin.xml` nested XML. Files in `areas-xml` folder can be generated using `./xml-make.bat xml` command.

Folder `validation` contains DTD and RNG files, that can be used to review generated XMLs in `areas-xml` folder. Files named `area.` are used for checking single areas, files named `areas.` are used for checking the combined XML (made from all areas). The XML files can be reviewed using DTD or RelaxNG with `./xml-make.bat dtd` or `./xml-make.bat rng` commands, respectively.

File `output/areas.pdf` is the PDF output file, generated from XML files of `areas-xml` folder using `xml2pdf.xslt` template. The PDF output can be generated using `./xml-make.bat pdf` command.

Folder `output/html` contains HTML output files, generated from XML files of `areas-xml` folder using `xml2html.xslt` template. Each area has own HTML output file, there is also an `index.html` file, that contains all areas together. All of these files are generated using `./xml-make.bat html` command.

Folder `scripts` contains different XSLT templates, used for generating XMLs and output files.
