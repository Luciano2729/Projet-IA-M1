% Fichier: api.pl

% 1. Charger les bibliothèques nécessaires
:- use_module(library(http/http_server)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).
:- set_setting(http:cors, [*]).

:- consult('main.pl').

% 2. Définition des faits de l'enquête (la base de données)
% 3. Le prédicat qui gère la requête '/suspects'



handle_suspects(Request) :-
    cors_enable(Request,
                  [ methods([get])
                  ]),
    % Récupère tous les suspects de la base de données
    findall(S, suspect(S), Suspects),
    % Crée un terme Prolog pour la réponse JSON
    ListeJson = json{suspects:Suspects},
    % Envoie la réponse au format JSON
    reply_json(ListeJson).

handle_scene(Request) :-
    cors_enable(Request,
                  [ methods([get])
                  ]),
    % Récupère toutes les scènes de la base de données
    findall(S, scene(S), Scenes),
    % Crée un terme Prolog pour la réponse JSON
    ListeJson = json{scenes:Scenes},
    % Envoie la réponse au format JSON
    reply_json(ListeJson).

% 4. Définir le gestionnaire de requêtes
% Associe l'URL '/suspects' au prédicat 'handle_suspects'
:- http_handler('/suspects', handle_suspects, []).

% Associe l'URL '/scenes' au prédicat 'handle_scene'
:- http_handler('/scenes', handle_scene, []).

% 5. Démarrer le serveur avec l'option CORS
% C'est cette ligne qui résout votre erreur.
% L'option 'cors(true)' permet toutes les requêtes cross-origin.
:- http_server(http_dispatch, [port(8000)]).
