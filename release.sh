
#...Look for the latest git tag for each release type.  Do a build if there is a new tag.
for TYPE in TODOS SHORES BLACKS; do
  echo "cd /var/lib/jenkins/workspace/${TYPE}-Release"
  cd /var/lib/jenkins/workspace/${TYPE}-Release
  LATEST_TAG=$(git for-each-ref --format="%(refname)" --sort=-taggerdate refs/tags | grep HD3.0 | head -1 |cut -d'/' -f3)


  #Current tag for TODOS is HD3.03.02.33
  #Current tag for SHORES is HD3.01.00.41
  #Current tag for TODOS is HD3.03.02.33
  #Current tag for SHORES is HD3.01.00.41
  #Current tag for BLACKS is HD3.02.02.13
  CURRENT_TAG=$(cat /home/jstanley/release_build_scripts/current_${TYPE}_tag)

 echo CUR: $CURRENT_TAG
 echo LATEST: $LATEST_TAG

exit 0

  if [ $LATEST_TAG != $CURRENT_TAG ]; then
     echo tag is current: $LATEST_TAG
     echo $LATEST_TAG > /home/jstanley/release_build_scripts/current_${TYPE}_tag
     echo New tag present, doing the build...
     echo "java -jar jenkins-cli.jar -s http://10.201.16.250:8080 build ${TYPE}-Release -p GIT_TAG=$LATEST_TAG"
     java -jar /home/build/jenkins-cli.jar -s http://10.201.16.250:8080 build ${TYPE}-Release -p GIT_TAG=$LATEST_TAG
  else
     echo tag is current: $LATEST_TAG
  fi
done
