# YikYakMaster
Master clone of the og social media Yik Yak

## Git

#### Feature branch workflow

Create feature branch
```bash
# switch to develop
git checkout develop
# fetch the latest changes
git pull origin develop
# create feature branch
git checkout -b feature/add-some-feature
```
Commit changes & push to remote
```bash
# make changes, add, and commit
git add .
git commit -m "Commit message"
# push feature branch to remote repo
git push -u origin feature/add-some-feature
```
Pull feature branch into develop
```bash
# switch to develop
git checkout develop
# pull changes to develop
git pull
# pull changes from (remote) feature to (local) develop
git pull origin feature/add-some-feature
# push merged local develop branch to remote
git push
```
Delete feature branch when done
```bash
# delete remote feature branch
git push origin --delete feature/add-some-feature
# delete local feature branch
git branch -d feature/add-some-feature
```
