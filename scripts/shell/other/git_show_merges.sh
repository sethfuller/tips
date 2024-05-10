MAIN_BRANCH=$1

if [ -z "$MAIN_BRANCH" ]
then
    MAIN_BRANCH="develop"
fi

git log --merges --first-parent $MAIN_BRANCH \
    --pretty=format:"%h %<(10,trunc)%aN %C(white)%<(15)%ar%Creset %C(red bold)%<(15)%D%Creset %s"
