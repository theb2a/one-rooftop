cd "D:\Documents\Cowork\Sites web\One Rooftop website"

# 1. Créer le repository local
git init
git config user.name "theb2a"
git config user.email "bo.abdoul@gmail.com"

# 2. Ajouter et commiter le fichier HTML
git add index.html
git commit -m "Add mockup HTML for One Rooftop"

# 3. Créer le repository sur GitHub (via GitHub CLI)
git repo create theb2a/one-rooftop --public --source=. --remote=origin --push

# 4. Créer la branche 'site'
git checkout -b site
git push origin site

# 5. Ajouter .gitignore
@"
images/
email-client.md
design.webp
design.jpg
*.psd
.DS_Store
node_modules/
.env
"@ | Out-File -Encoding UTF8 .gitignore
git add .gitignore
git commit -m "Add gitignore to exclude non-essential files"
git push origin site