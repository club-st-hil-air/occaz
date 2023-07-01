# Stand Consult Mobile

Application de consultation pour le grand public


- Technologie [Flutter](https://flutter.dev/) pour fonctionner sur un poste Windows, un browser ou même une application mobile, avec la même base de code. Pour l'instant, seule l'application Windows est générée
- Utilisation d'un bucket S3 avec un fichier json, qui est poussé régulièrement depuis le serveur du stand d'occasions (pas d'API en direct), et qui ne contient que les données déjà visibles sur les affiches
- Affichage du numéro de lot
- Recherche dans tous les champs avec affichage rapide. J'ai préféré cette approche, plus pratique je trouve pour les bénévoles qu'une vrai recherche multi-critères
- Rafraichissement avec un nouvel appel à l'API, sur demande

## Installation web

Automatique sur GitHub Pages: https://club-st-hil-air.github.io/occaz/, via GitHub actions

## Développer

- Installer Flutter: https://flutter.dev/docs/get-started/install

```doscon
flutter run -d chrome
```

Pour générer la version web:

```doscon
flutter build web  --base-href='/occaz/'
```
