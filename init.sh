#!/bin/sh

echo "Please input Github username for setting homepage url"
echo "GitHub username:"
read USERNAME
if [ -z "$USERNAME" ]; then
    echo "Username should not null"
    exit
fi

FROM_USERNAME=USERNAME
FROM_APP=react-github-pages
APP_DIR=`git rev-parse --show-toplevel`
TO_APP=`basename $APP_DIR`
HOMEPAGE="http://${USERNAME}.github.io/${TO_APP}"

# Rename app dir to top dir name
echo Rename $FROM_APP to $TO_APP
mv $FROM_APP $TO_APP

# Update README.md <HOMEPAGE>
echo Update README.md HOMEPAGE → $HOMEPAGE
sed -i '' -e s@\<HOMEPAGE\>@${HOMEPAGE}@g README.md

# Change app settings for the current github repository
echo Update ${TO_APP}/package.json ${FROM_APP} → ${TO_APP}
echo Update ${TO_APP}/package.json ${FROM_USERNAME} → ${USERNAME}
cd $TO_APP
sed -i '' -e s/${FROM_APP}/${TO_APP}/g package.json
sed -i '' -e s/${FROM_USERNAME}/${USERNAME}/g package.json

# build and deploy
npm install
npm run deploy

echo Complete Deploy → ${HOMEPAGE}