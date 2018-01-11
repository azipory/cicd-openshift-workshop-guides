#!/bin/bash 
#################################################
# This script is used to setup users and projects
# for the CICD workshop hosted oon AWS
# Author : Amir Zipory
#################################################
function create_user_projects() {
   local _PROJECTS=
   # create projects 
   for i in `seq 0 2`; do
       echo "creating user: user$i"
       _CMD="sudo htpasswd -b /etc/origin/master/htpasswd user$i openshift3";
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
       oc login -u user$i -p openshift3
       echo "creating project: explore-$i"
       oc new-project explore-$i
       oc login -u system:admin
   done
}

function clean_up_users() {
   # delete projects
   oc login -u system:admin;
   for i in `seq 0 2`; do
       echo "Deleting project explore-$i";
       oc delete project explore-$i;
       echo "Deleting user user$i";
       oc delete user user$i;
       oc delete identity htpasswd_auth:user$i;
       _CMD="sudo htpasswd -D /etc/origin/master/htpasswd user$i"
       ssh ec2-user@ec2-52-28-24-159.eu-central-1.compute.amazonaws.com "$_CMD";
   done
}

################################
# MAIN                         #
################################a

#   create_user_projects;
  clean_up_users;
