---
name: google-to-mockup
description: >
  Génère une maquette de site web HTML complète + email de prospection client à partir
  d'un lien Google Business Profile / Google Maps. À utiliser IMMÉDIATEMENT dès que
  l'utilisateur fournit un lien Google Maps ou Google Business et veut créer un site,
  une maquette, ou une démo pour un client. Couvre tous types de commerces : restaurants,
  hôtels, salons, boutiques, cliniques, cabinets, bars, spas, etc. Se déclenche aussi sur :
  "crée un site à partir de la fiche Google", "génère une maquette pour ce commerce",
  "fais un site web pour ce client", "prospection avec maquette", "démo site pour client",
  "site web à partir de Google Maps", "maquette de prospection TheB2ATeK". Le dossier de
  travail doit être sélectionné dans Cowork et contenir un fichier design.webp ou design.jpg.
---

# Google → Website Mockup + Email (TheB2ATeK)

Transforme n'importe quelle fiche Google Business en maquette HTML professionnelle +
email de prospection prêt à envoyer.

## Vérification des prérequis

Avant toute chose, confirmer :
1. L'utilisateur a fourni un lien Google Maps ou Google Business Profile
2. Un dossier de travail est disponible (voir ci-dessous)
3. Ce dossier contient un fichier `design.webp` **ou** `design.jpg` (référence visuelle)

**Résolution du dossier de travail (dans cet ordre) :**
- Si un dossier est déjà sélectionné/monté dans la session Cowork → l'utiliser directement
- Sinon → charger l'outil `mcp__cowork__request_cowork_directory` via ToolSearch et demander à l'utilisateur de sélectionner le dossier du projet client

Ne jamais supposer un dossier par défaut. Si aucun dossier n'est disponible, l'étape de demande est obligatoire avant de continuer.

**Vérification du fichier de design :**
Chercher `design.webp` ou `design.jpg` à la racine du dossier sélectionné.
Si absent, demander à l'utilisateur de l'ajouter ou de le glisser-déposer dans le chat.

---

## Étape 1 — Extraction des données Google Business

Charger les outils Chrome via ToolSearch (`query: "chrome", max_results: 20`), puis :

```
navigate(url_google_business)
get_page_text()
```

Si Chrome MCP n'est pas disponible ou si la page ne se charge pas correctement,
utiliser `mcp__workspace__web_fetch` sur l'URL puis parser le contenu retourné.

**Extraire ces champs :**

| Champ | Description |
|-------|-------------|
| `business_name` | Nom complet du commerce |
| `business_type` | Catégorie Google (restaurant, salon, hôtel…) |
| `description` | Texte descriptif / "à propos" |
| `address` | Adresse complète |
| `city` | Ville |
| `phone` | Numéro de téléphone |
| `hours` | Horaires d'ouverture par jour |
| `rating` | Note Google (ex: 4.7) |
| `review_count` | Nombre d'avis |
| `top_reviews` | 2–3 extraits d'avis positifs courts |
| `photo_urls` | URLs des photos du commerce (viser 8–15 URLs) |
| `highlights` | Tags / attributs (terrasse, wifi, parking, etc.) |
| `price_range` | Fourchette de prix si disponible |

Si certains champs sont absents, générer un contenu plausible basé sur le type et la ville.

---

## Étape 2 — Téléchargement des photos

Créer le sous-dossier `images/` dans le dossier de travail, puis télécharger chaque photo :

```bash
mkdir -p "WORKSPACE_PATH/images"
curl -L --max-time 15 "PHOTO_URL" -o "WORKSPACE_PATH/images/photo_01.jpg"
# Répéter pour chaque photo : photo_02.jpg, photo_03.jpg, etc.
```

- Télécharger au moins 6 photos, idéalement 10+
- Nommer séquentiellement : `photo_01.jpg`, `photo_02.jpg`, etc.
- Si certaines URLs échouent, continuer avec les photos disponibles

---

## Étape 3 — Analyse du fichier de design de référence

Lire le fichier `design.webp` ou `design.jpg` dans le dossier de travail (tool Read).

Analyser et retenir :
- **Palette** : couleur de fond principale, couleur d'accent, couleur du texte
- **Sections** : identifier toutes les sections visibles (hero, about, menu/services, galerie, footer…)
- **Typographie** : serif/sans-serif, grand/petit, éditorial/propre
- **Style général** : dark luxury, warm organic, minimal corporate, vivant/coloré…
- **Hero** : collage photos, plein-écran, texte dominant, asymétrique…
- **Boutons CTA** : circulaires, pills, rectangulaires, avec bordure…

---

## Étape 4 — Adapter le contenu au type de commerce

Selon `business_type`, choisir les sections et le vocabulaire :

| Type | Sections | CTA principal |
|------|----------|---------------|
| Restaurant / Bar | Hero · À propos · Menu · Galerie · Moments · Footer | "Réserver une table" |
| Hôtel / Lodge | Hero · À propos · Chambres · Galerie · Expériences · Réservation · Footer | "Réserver" |
| Salon / Spa | Hero · À propos · Services & Tarifs · Galerie · Équipe · Avis · Footer | "Prendre rendez-vous" |
| Boutique / Shop | Hero · À propos · Produits phares · Galerie · Avis · Footer | "Découvrir la collection" |
| Clinique / Cabinet | Hero · À propos · Services · Équipe · Témoignages · Contact · Footer | "Prendre rendez-vous" |
| Autre | Hero · À propos · Services · Galerie · Témoignages · Contact · Footer | "Nous contacter" |

---

## Étape 5 — Génération de la maquette HTML

Créer `index.html` dans le dossier de travail. **Un seul fichier**, CSS et JS inclus inline.

### Règles de design à respecter

**Fidélité au design de référence :**
- Reproduire la palette de couleurs détectée à l'étape 3 (utiliser CSS custom properties)
- Répliquer la structure des sections du design de référence dans le même ordre
- Imiter le style typographique en choisissant des Google Fonts visuellement proches
- Reprendre le pattern du hero (collage, plein-écran, asymétrique selon la référence)

**Qualité du code :**
- CSS variables pour toutes les couleurs et polices
- Responsive (media queries ≤ 768px)
- Animations scroll-reveal avec `IntersectionObserver`
- Hover micro-interactions sur boutons et cartes
- Chemins d'images relatifs : `images/photo_01.jpg`
- **Jamais de Lorem Ipsum** — utiliser les données réelles extraites

**Typographie — ne jamais utiliser Inter, Arial, ou polices système génériques :**
- Style élégant/luxe : `Playfair Display` + `Cormorant Garamond`
- Style éditorial/moderne : `Fraunces` + `DM Sans`
- Style corporate/clean : `Josefin Sans` + `Lato`
- Style chaleureux/artisanal : `Libre Baskerville` + `Nunito`
- Choisir selon le style détecté dans le design de référence

**Hero — toujours inclure :**
- Nom du commerce en grande typographie d'affichage (overlapping ou compositional)
- 3–4 photos en collage ou layout éditorial (positions absolues)
- Bouton CTA adapté au type (circulaire ou pill)
- Ville + catégorie en petites capitales
- Copyright / année en bas à gauche

**Section À propos :**
- Grand titre italique serif (accroche évocatrice en 15–20 mots)
- Description réelle extraite de Google
- Deux colonnes de corps de texte
- Bouton "En savoir plus" inline

**Galerie :**
- Grid CSS sur fond sombre
- Hover zoom + overlay gradient
- Au moins 6 photos sur 2 rangées

**Footer :**
- Fond couleur d'accent
- Logo + slogan · Navigation · Horaires · Contact & réseaux
- Bouton CTA circulaire
- Nom du commerce en ghosté en arrière-plan (opacité 5–8%)

---

## Étape 6 — Email de prospection TheB2ATeK

Créer `email-client.md` dans le dossier de travail avec ce template personnalisé :

```
Objet : [Nom du commerce] — Votre présence web, repensée ✦

---

Cher(e) équipe de [Nom du commerce],

[ACCROCHE : 2–3 phrases spécifiques à leur fiche Google. Mentionner leur note,
un avis remarquable, leur spécialité, leur emplacement précis, ou un highlight
particulier. Être précis et authentique — jamais générique.]

Je m'appelle Aziz, fondateur de TheB2ATeK.
Nous aidons les [type de commerce] à transformer leur visibilité en ligne
en un vrai levier de croissance, grâce à l'IA et au design sur mesure.

En quelques heures, nous avons conçu une maquette de site web sur mesure
pour [Nom du commerce] — basée sur vos vraies photos, votre identité,
et l'essence de votre établissement.

Ce que nous avons préparé pour vous :
✦ Une maquette HTML complète et interactive
✦ Un design moderne fidèle à l'image de [Nom du commerce]
✦ Une architecture pensée pour convertir vos visiteurs en clients

Pas d'engagement. Pas de formalités.
Juste 20 minutes pour vous montrer ce que nous avons imaginé pour vous.

Je suis disponible cette semaine — quand vous êtes libre, je m'adapte.

Bien cordialement,
Aziz
TheB2ATeK — AI that works while you lead
📞 +[numéro] | ✉ aziz@theb2atek.com
```

**Personnalisation obligatoire :**
- L'accroche doit contenir au moins un fait réel extrait de la fiche (note, avis, spécialité)
- Adapter le vocabulaire au type de commerce
- Mentionner 1–2 highlights concrets de leur profil

---

## Rapport final

À la fin de chaque exécution, afficher :

```
✅ [business_name] | [business_type] | [city]
⭐ Note : [rating]/5 — [review_count] avis
📸 [N] photos téléchargées → images/
🌐 Maquette → index.html
✉  Email → email-client.md
```

Puis fournir les liens directs :
- `[Voir la maquette](computer://WORKSPACE_PATH/index.html)`
- `[Voir l'email](computer://WORKSPACE_PATH/email-client.md)`

---

## Gestion des cas limites

| Problème | Solution |
|----------|----------|
| Chrome MCP indisponible | Utiliser `web_fetch` + parser le HTML brut |
| Photos Google inaccessibles | Générer des placeholders CSS avec dégradés colorés |
| Pas de description sur Google | Créer un texte pertinent basé sur nom + type + ville |
| `design.webp` absent | Demander à l'utilisateur avant de continuer |
| Moins de 6 photos disponibles | Utiliser les photos disponibles + répéter si nécessaire |
