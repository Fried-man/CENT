![image](https://user-images.githubusercontent.com/98774846/205793480-97b31778-2f3f-4a0c-8353-e796aafc2434.png)
# Backend Documentation
These are some of the backend files, most of which are testaments to our original work before we migrated over to an Azure environent. As our backend for the model and genomic data exist in the backend this document serves to aid the user in aggregating more data, developing further models, and managing the database. Here we will specify what features are present within our machine learning environment, how to run these models, and how to navigate the Azure environment.

<img width="61%" alt="Databricks Environement" src="https://user-images.githubusercontent.com/98774846/205796942-e1562a85-0578-4f83-9f1d-5a49c899325e.png"> <img height="10%" alt="Tables from PostgreSQL" src="https://user-images.githubusercontent.com/98774846/205797519-bde8bb18-f9db-4363-8824-56fb24f0cfda.png">


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
- [Repository's Wikipedia/Guides](https://github.com/Fried-man/CENT/wiki)
- [Useful Links](https://github.com/Fried-man/CENT/wiki/Resources)

### Features
* Multi node compute resource for notebooks
* Confidence Model is now reachable as an endpoint (this is yet to be connected to the frontend)
* Confidence Model has historical metrics and confusion matrix shown to display results
* Preprocessing utility script to convert genomes into kmers for bag of words approaches
* MLflow in Azure setup to record and deploy model experiments as versioned histories
* API calls to the backend to receive accurate and full accession data
### Bug Fixes
* Worked around memory issues within the notebooks by using smaller training sets
### Known Issues
* unable to pad csr matrix to be accepted by the MLflow API - could be solved by moving frontend to Azure as well
* unable to run large memory blocks like the unified tables found in clustering notebook

### How to Navigate our Azure Environment
* Single user compute resource can only be run
