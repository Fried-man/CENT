![Banner](assets/assets/images/banner.png)
# Building to Web
1) run `flutter build -web --release` in the main branch
2) the compiled code will be in genome_2133/build/web/. Make a copy of it somewhere
3) run `git checkout live-website` to branch to the live website's branch
4) delete the contents of genome_2133 (other than this README.md file) and paste in the compiled code you made a copy of earlier
5) remove the forward slash (/) from `<base href="/">` in the index.html file
6) commit and push to the branch to update the branch ([The website](https://fried-man.github.io/genome_2133/) looks at this branch)
7) Wait a little bit for the host to update
## Useful Links
- [Flutter documentation](https://docs.flutter.dev/get-started/web)
  - [Building and releasing a web app](https://docs.flutter.dev/deployment/web)
- [GitHub Pages documentation](https://pages.github.com)
- [Fix white page bug](https://www.fluttercampus.com/guide/163/how-to-fix-blank-white-page-from-hosted-flutter-web-app/)
