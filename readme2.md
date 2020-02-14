# Jenkins

This Jenkins readme is located only on the 'dev' branch, we learnt how to switch between
the dev and master branch and had Jenkins listen to only the dev branch and build when changes have
been committed to that branch.

TEST MERGE TEXT

Interview Questions:
- how are you planning on implementing devops to your company
- what projects are you working on
- what is a typical work day like in your company?

## Merging dev and master branch.
The two branches can be merged using :
````
git add .
git commit -m
git push origin dev
git push origin dev:master
````
The above example is how we could merge a development branch we are working on
and a master branch meant for tested working code.

In the real world we never really directly work on the master branch.

````
git merge master
````
The above command will merge any changes on the master branch with the current dev
branch.


# Task
We want to be know how to launch an AWS instance, and then with that instance be able to install our Sparta nodejs app as well as
the mongodb, run a provision script to install the libraries and dependencies on that AMW instance, replace the default sites-enabled nginx with the nginx.default that we modified ,and then be able to launch the app so that it can be navigated to though the public ip.

This means we have to know commands below such as the scp (Secure Copy) command which can copy local folders and files or even folders on our Jenkins workspace to our AWS instance, which are computers located elsewhere (e.g Ireland, North California, etc..).

- Port 22 is the SSH connection.

- ./<script or file name> runs the file

- scp -i ~/.ssh/Abiodun-Oluwade-Eng48-first-key.pem -r environment/ ubuntu@34.255.198.62:/home/ubuntu/ (command to copy entire folders to another machine, in this example copy environment to my AWS machine)

- scp -i ~/.ssh/Abiodun-Oluwade-Eng48-first-key.pem app/provision.sh ubuntu@34.255.198.62:/home/ubuntu/provision_file.sh (command to copy a single file folder)

- scp -o StrictHostKeyChecking='no' -r app ubuntu@54.194.15.75:/home/ubuntu/ (This command will skips the known host check and copy the app folder
  from our jenkins workspace,which is linked to our github, and copy it to our ubuntu AWS instance.)

- StrictHostKeyChecking='no' 'Makes it skip the asking of adding a computer to the known host'

What happens:
The GitHub for our repo is linked to Jenkins, and we have configured Jenkins so that whenever there is a change in code pushed to GitHub, Jenkins will be notified and if
the code passes the test will update our GitHub which in turn will update our workspace. this means any changes produced will be pushed to AWS through our Jenkins shell and essentially means we can automate our deployments to server:
1. Produce changes on GitHub and test on Jenkins
2. changes applied to Jenkins workspace
3. workspace code pushed to AWS server

Things like the 'restrict where project can be run' and 'provide nodejs and npm path' are set up by the Jenkins server owner who has the correct permissions.
So the Jenkins owner can create an instance of node and npm which the developers can access and is the same for all of them.

### CI
The CI part is where we implement the webhook to check for any changes pushed to the GitHub repo, after Jenkins will pull that repo to the workspace and execute any configurations we have set up which in this instance was:
````
cd app
npm install
npm test
````
We also used 'ssh-keygen' to create a private and public key for Jenkins so it can communicate with our repo, there were able to communicate as our
Jenkins instance had the private key and our repo for the source code we were tracking/managing had the public key. Meaning they could:
'(JenkinsPrivate)-shake hands-(RepoPublic)'.

We restricted where the project should be run by limiting it to the Sparta-Node which is a clean instance with only what we require within the environment to eliminate the possibilities of conflict's.

### CD
````
scp -o StrictHostKeyChecking='no' -r app ubuntu@54.194.15.75:/home/ubuntu/
scp -o StrictHostKeyChecking='no' -r environment ubuntu@54.194.15.75:/home/ubuntu/

ssh -o StrictHostKeyChecking='no' ubuntu@54.194.15.75 <<EOF
	echo 'Run bash files ./provision.sh-environement related'

    chmod +x environment/app/provison.sh
    chmod +x environment/db/provision.sh

    ./environment/app/provision.sh
    ./environment/db/provision.sh

    # echo 'Go to the right directory-everything below is app related'
    cd app
    # echo 'install dependecies
    sudo apt npm install
    npm install
    # echo 'Start our app'
    npm start & exit
EOF
````

- The above code is executed in the [Build] section of Jenkins, and is key for the CD part of CI/CD
, once the test are passed in the CI section the workspace code from GitHub is available here in CD.
, after which the scp (Secure Copy) command can be utilised to transfer folders/files in the workspace/GitHub to
our AWS server instance (which in this case is running ubuntu).

We must select additional behaviours in the source code management, we follow the same initial steps in the CI stage, but must add the [Additional Behaviours] and input the
name of the repo (origin) and branch to merge (master).

Earlier we used the 'ssh-keygen' to make a key for the Jenkins instance, however our AWS must use a separate private key in order for Jenkins and AWS to communicate, so we did this by supplying our Jenkins instance with the AWS private key and selecting that for [Build Environment] and checking the box that says 'SSH Agent'.

We added a build trigger so that the CD job can communicate/track the CI job and if successful will begin its job and configurations.
