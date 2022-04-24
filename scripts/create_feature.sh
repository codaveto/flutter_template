cd ../lib/features/ || exit
echo "Name of the feature?"
read -r feature
mkdir "$feature"
cd "$feature" || exit
mkdir "abstracts"
mkdir "analytics"
mkdir "api"
mkdir "data"
cd data || exit
mkdir "constants"
mkdir "dtos"
mkdir "enums"
mkdir "exceptions"
mkdir "models"
mkdir "requests"
mkdir "responses"
cd ../
mkdir "forms"
mkdir "services"
mkdir "strings"
mkdir "util"
mkdir "views"
mkdir "widgets"
