FROM library/amazonlinux:latest
MAINTAINER Jim Tran and Justin Pirtle
WORKDIR /home/
ENV DIRPATH /home/aws-serverless-auth-reference-app/

# install git and pull down source code
RUN yum install -y git
RUN git clone https://github.com/awslabs/aws-serverless-auth-reference-app

# install npm
WORKDIR $DIRPATH
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum install -y nodejs

# install the latest Gulp CLI tools globally (you will need a newer version of Gulp CLI which supports Gulp v4)
RUN npm install gulpjs/gulp-cli -g

# install the Node modules for the bootstrapping process
WORKDIR $DIRPATH/api/
RUN npm install

# install the Node modules for the Lambda run-time
WORKDIR $DIRPATH/api/lambda
RUN npm install

# install latest version of the Ionic2 CLI, Cordova, and Bower tools
RUN npm install -g ionic cordova bower
WORKDIR $DIRPATH/app
RUN npm install

# install the Bower crypto components (for AWS request signing)
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN bower install

# install Cordova platform components if you would like to build the app for mobile
RUN cordova platform remove android
RUN cordova platform remove ios
RUN cordova platform add android@5.X.X
RUN cordova platform add ios@4.X.X

# change prompt color
RUN echo 'export PS1="\[\033[0;33m\]${LOGNAME}@$(hostname):[\w]  \[\033[0m\]"' >> /root/.bashrc && source /root/.bashrc

# Expose the Ionic ports
EXPOSE 8100 35729
WORKDIR $DIRPATH
