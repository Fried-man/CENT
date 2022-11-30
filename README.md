![Banner](assets/images/banner.png)
# About
The system being developed by Team 2133 is an application which can provide information and predictions about Covid-19 and its variants in a given geographic region. We aim to enable the general public to make informed decisions about travel and make predictive determination of likely Covid-19 genomic mutations in a specific area. It could also be used by epidemiologists and COVID researchers as a means of assessing recent variants through multiple genome alignment, and analyze developments through the aid of a predictive model which highlights components of the genome affected by mutations.

<img width="1840" alt="Demo" src="https://user-images.githubusercontent.com/17306743/204707446-643f0aa0-9849-4930-aaa3-d3e6b19d40ed.png">

## The Team
<a href="https://github.com/benburns20"><img src="https://avatars.githubusercontent.com/u/46821194?v=4" width=25% height=25%></a><a href="https://github.com/Fried-man"><img src="https://avatars.githubusercontent.com/u/17306743?v=4" width=25% height=25%></a><a href="https://github.com/Noel-Igbokwe"><img src="https://avatars.githubusercontent.com/u/90152530?v=4" width=25% height=25%></a><a href="https://github.com/JohnRehme"><img src="https://avatars.githubusercontent.com/u/98774873?v=4" width=25% height=25%></a><a href="https://github.com/NiharDS"><img src="https://avatars.githubusercontent.com/u/57595140?v=4" width=25% height=25%></a><a href="https://github.com/Tangerine2001"><img src="https://avatars.githubusercontent.com/u/29467345?v=4" width=25% height=25%></a><a href="https://github.com/WholeOfBagel"><img src="https://avatars.githubusercontent.com/u/98774846?v=4" width=25% height=25%></a>
| Name            | Email                  | Roles                                                            |
| --------------- | ---------------------- | ---------------------------------------------------------------- |
| Bennett Burns   | bburns39@gatech.edu    | Summarizer, Compromiser, Encourager                              |
| Andrew Friedman | afriedman38@gatech.edu | Information Giver, Harmonizer                                    |
| Noel Igbokwe    | nigbokwe3@gatech.edu   | Information Seeker, Summarizers                                  |
| John Rehme      | jrehme3@gatech.edu     | Information Seeker, Feeling Expressers                           |
| Nihar Shah      | nshah400@gatech.edu    | Energizers, Clarifiers                                           |
| Max Tang        | mtang80@gatech.edu     | Information Giver, Harmonizer                                    |
| Daniel Varzari  | dvarzari3@gatech.edu   | Energizer, Clarifier, Compromiser, Organizer, Information Seeker |
## Team Resources
- [Repository's Wikipedia](https://github.com/Fried-man/CENT/wiki)
- [Useful Links](https://github.com/Fried-man/CENT/wiki/Resources)
# Release Notes
## [v0.4.0](https://github.com/Fried-man/CENT/releases/tag/v0.4.0)
[Sprint 4 Demo Video](https://youtu.be/HB5osgjjkO0)
### Features
* Added new variant card - selecting a variant from a region pulls up additional info about the genome sequence, a link to the vairant on NCBI, and the ability to add the variant to a user's Saved list
* New relational database created in Azure - will allow final connection between backend and frontend to populate website with data
* New Postgres SQL commands allow us to filter genomes by region, date, etc. - 650,000 have been segregated so far
* [Minor] Moved FAQ menu to new button in bottom right of home screen - cleans up home screen tabs selection
### Bug Fixes
* Data cleaning has allowed us to finally store and work with genomic sequence data
* Made "card" feature universal - can now instantiate and remove cards at will
### Known Issues
* New variant card throws null error for non-logged in users
* API request needs to be created for relational database

## [v0.3.0](https://github.com/Fried-man/CENT/releases/tag/v0.3.0)
### Features
* Saved variant table added to user accounts - will allow saving of variants in future version of application
* Added animated Google Maps functionality when selecting a region
### Bug Fixes
* Fixed Google Maps Controller to support changing of map
### Known Issues
* Still able to open multiple region cards - due to unique implementation to support card feature
* Still running data cleaning - expected to end by this week or next due to the sheer volume of data
* Architecting the model has proven to be more difficult than initally presumed, at least to the degree of accuracy desired

## [v0.2.0](https://github.com/Fried-man/CENT/releases/tag/v0.2.0)
[Sprint 2 Demo Video](https://youtu.be/VByy5UfqoAM)
### Features 
* Multiselect for variants - can select group of variants to copy from a list displayed to the user 
* New copy & compare button – copies list of selected variants and can open BLAST to compare 
* Azure Databricks setup – have a place to run our notebooks from 
* Azure Functions – allows us to port data as JSON from blob storage to notebook  
### Bug Fixes 
* Country name now correctly shows in Variant View for the selected country  
### Known Issues 
* Able to open the same region card multiple times 
* Title for region cards shrinks when too long 
* FASTA format is not sufficient to give us all the data we need – consider .gbff 
* Azure is not connected as endpoint 

## [v0.1.0](https://github.com/Fried-man/CENT/releases/tag/v0.1.0)
[Sprint 1 Demo Video](https://www.youtube.com/watch?v=pdO0hcMbbtc)
### Features 
* Region card view – this extends from our search functionality for regions, and where we can start to see variant views. 
* Variant view – redirects to database link 
* Variant table view – can view more variants for a particular region 
### Bug Fixes 
* Fixed Google Maps agreement issue (was out-of-date) 
### Known Issues 
* Able to open the same region card multiple times 
* Title for region cards shrinks when too long 
