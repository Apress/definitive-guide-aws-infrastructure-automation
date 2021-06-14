# Errata for *The Definitive Guide to AWS Infrastructure Automation*

In **Chapter 6, Listing 6-5 cdk-app Directory Contents** [code/technical accuracy]:
 
There are a couple of errors here.
First of all, the line you are adding to the setup.py  "aws-cdk.ec2" is not valid anymore, now it should be pip install aws-cdk.aws-ec2 (see http://links.springernature.com/f/a/8L4SWF4tSPzHfnaQCVpefQ~~/AABE5gA~/RgRip8RdP0QpaHR0cHM6Ly9weXBpLm9yZy9wcm9qZWN0L2F3cy1jZGsuYXdzLWVjMi9XA3NwY0IKYMLdkMZgMExjEVIUZWRpdG9yaWFsQGFwcmVzcy5jb21YBAAABuc~)

This is what happens when I follow the instructions

```
(.venv) jvazquez@P52:~/workspace/aws-devops-template/cdk-app$ pip install -r requirements.txt Obtaining file:///home/jvazquez/workspace/aws-devops-template/cdk-app (from -r requirements.txt (line 1)) Collecting aws-cdk.core==1.108.1
  Using cached aws_cdk.core-1.108.1-py3-none-any.whl (942 kB)
ERROR: Could not find a version that satisfies the requirement aws-cdk.ec2 (from cdk-app) (from versions: none)
ERROR: No matching distribution found for aws-cdk.ec2 ```

Second error, the cdk sets a venv , yet when you are activating it this is the instruction

`$ source .env/bin/activate` , that won't work either in the cdk-app folder, because the folder is .venv ]

