<div class="content">

<div class="blog-detail">

<div class="detail-banner" style="background:linear-gradient(45deg, slateblue, #00002b)">

# Devops Button Click Environment Build Tutorial

</div>

<div class="affiliate-disclaimer">

Disclosure: scottyfullstack.com is a participant in the Amazon Services LLC Associates Program, an affiliate advertising program designed to provide a means for sites to earn advertising fees by advertising and linking to amazon.com.

</div>

<div class="detail-signup">

# Sign Up for Your Free Foundations Primer Course!

<link href="//cdn-images.mailchimp.com/embedcode/horizontal-slim-10_7.css" rel="stylesheet" type="text/css">

<div id="mc_embed_signup">

<form action="https://scottyfullstack.us17.list-manage.com/subscribe/post?u=d71ef901066876c9713736833&amp;id=d97c715c0e" method="post" id="mc-embedded-subscribe-form" name="mc-embedded-subscribe-form" class="validate" target="_blank" novalidate="">

<div id="mc_embed_signup_scroll"><input type="text" value="" name="FNAME" class="email" id="mce-FNAME" placeholder="First Name" required=""> <input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="Email Address" required="">

<div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_d71ef901066876c9713736833_d97c715c0e" tabindex="-1" value=""></div>

<div class="clear"><input type="submit" value="Get Started" name="subscribe" id="mc-embedded-subscribe" class="button"></div>

</div>

</form>

</div>

</div>

<div class="post-text">

<div class="author">![](https://paradise-devs-media.s3.amazonaws.com/static/img/prof.png)

<div class="author-meta">

Scotty Parlor

Jan. 20, 2021

Read Time 23 min

</div>

</div>

<pre>

<div>A while back I was mindlessly scrolling through LinkedIn when I saw this promoted post. </div>

<div>Specifically, DevOps Engineers with GCP, RabbitMQ, and Terraform. Best of all? 100% remote. </div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/0233c8de-dc28-4f8c-8b58-c026f3d02381.PNG)

<div>Let it be said, I know **absolutely nothing** about this company or how they operate. I'm not promoting them...However, this is the future of this industry. Message brokers, Terraform, and the public cloud are everything you need to secure a career in 2021 and on for the foreseeable future.</div>

<div>Now, if you are new to the industry, the popular thing lately is "**button click**" environment builds. Believe me when I tell you it sounds way more annoying coming from a non-technical manager.</div>

<div>But it is important though. We really want to automate as many services as we can so that **when** catastrophe hits, we can quickly destroy and rebuilt with as few clicks as possible and in theory minimal experience required.  If the least technical person in the room can't rebuild your service, then you haven't automated enough.</div>

<div>Going off of this simple post, here is what I want to use.</div>

*   **<span style="font-size: 20px;">AWS</span> **<span style="font-size: 20px;">for our Cloud Provider (GCP is my weakest, and although I could get through it, I want to make sure you take away the core concepts of cloud)</span>
*   **<span style="font-size: 20px;">Terraform</span> **<span style="font-size: 20px;">for our Infrastructure as Code</span>
*   **<span style="font-size: 20px;">Ansible</span> **<span style="font-size: 20px;">for our server configuration (With Dynamic Inventory for our RMQ EC2)</span>
*   **<span style="font-size: 20px;">Jenkins</span> **<span style="font-size: 20px;">host and jobs to Deploy the Terraform and ansible files</span>
*   **<span style="font-size: 20px;">RabbitMQ</span> **<span style="font-size: 20px;">instance in EC2 and a direction forward for learning RMQ specifics.

    </span>

<div><span style="font-size: 20px;"><span data-markholder="true"></span></span></div>

<div><span style="font-size: 16px;">Reference the below visual for our flow:</span></div>

<div><span style="font-size: 16px;">
</span></div>

<div><span style="font-size: 16px;"><span data-markholder="true"></span></span></div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/4d35ab23-75dc-4d2e-9d50-ca91e51d7bd4.png)

## Prerequisites

<div>Some of this we have completed in other tutorials, but I don't want to use up space here going through each install. Reference each one below if needed!</div>

<div>[AWS account](https://portal.aws.amazon.com/billing/signup#/start) (this complies with free tier)</div>

<div>[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)</div>

<div>[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)</div>

<div>[Github Account](https://github.com)</div>

<div>[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)</div>

<div>[Jenkins](https://www.jenkins.io/doc/book/installing/)</div>

<div>Once you have those, begin below.</div>

<div>Alternatively, check out the video.

<div style="text-align: center;"><iframe width="560" height="315" src="https://www.youtube.com/embed/SmgS-kyhadI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe></div>

<div style="text-align: center;">[SUBSCRIBE](https://www.youtube.com/c/scottyfullstack?sub_confirmation=1)
</div>

</div>

* * *

## Part 1:  Setting Up AWS for our project

<div>The Preliminary AWS steps we need to take are:</div>

1.  Create an IAM role for this project
2.  Create an EC2 Key pair to ssh to our instances
3.  EC2 Security Group

<div>**<span data-highlight="yellow" style="background-color: #ffef9e;">IMPORTANT NOTE: I will not be covering remote state in this project. Although there are several ways, including Terraform cloud, Gruntwork has some great information and a tutorial on how to do this! Check it out if you want to manage remote state.</span> **<span data-highlight="yellow" style="background-color: #ffef9e;">See it [HERE](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)</span></div>

<div>Log into the aws console and navigate to **Services > Security, Identity, & Compliance > IAM**</div>

<div>**<span data-markholder="true"></span>**</div>

1.  In 'Users' click the 'Add User' .
2.  <div>Enter the username (I will be using DevOpsUser) and then select "Programmatic Access".</div>

    <div>
    ![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/e60ef129-208c-4c9b-93d6-9147b60862b8.png)</div>

3.  <div>Select 'Attach existing policies directly' and add ** AmazonEC2FullAccess**</div>

    <div>![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/4df715f8-8321-4451-b7b9-00ce795623dc.png)</div>

    <div>**<span data-markholder="true"></span>**</div>

4.  Click through the remaining steps and retrieve the Access and Secret Keys (hint, keep these safe)
5.  Open a terminal and configure your user with your keys like:

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">aws configure --profile DevOpsUser</div>

</div>

<div>Since we will be using Jenkins locally for this tutorial, let's copy that credential to our jenkins user (You could also run the configure as Jenkins if you want, but I figure you'd wanna be able to access the EC2 quick if needed).</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">sudo mkdir /var/lib/jenkins/.aws</div>

<div data-plaintext="true">sudo cp ~/.aws/* /var/lib/jenkins/.aws</div>

<div data-plaintext="true">sudo chown jenkins:jenkins /var/lib/jenkins/.aws/*</div>

</div>

<div>Ok, now that we have our IAM user, let's grab a key pair. Navigate to the EC2 Dashboard (via services or the search bar)</div>

1.  Scroll down the left menu and select 'Key Pairs'
2.  Click 'Create Key Pair' and name it what you'd like. I will be naming mine rabbitmq since I will be using this key pair for those instances. Up to you. Some companies use one key pair for all instances (yikes).

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/41b87f01-896b-4a99-b4d1-4b9a4972266b.png)

<div>While in the EC2 Dashboard, let's navigate to **security groups** as well.</div>

<div>Create a new security group and name it something you will recognize. Set Custom TCP for everywhere with the port 15672\. This will be important for RMQ Later. Also, add an SSH rule to your preference (either local IP or everywhere).</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/d9460d9e-d407-4423-903a-2681aa33aaf4.png)

<div>After creating it, make sure to click on it and take note of the ID. We will need this in the terraform step.</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/1be81c18-7b26-48af-962e-1d2b8a3ed0df.png)

<div>Lastly, in this tutorial, my laptop is going to act like my jenkins/ansible server. So I will be moving the downloaded pem file to my **jenkins user** ~/.ssh directory and chmoding it. Then we will want to change ownership to make sure jenkins can use it.</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">sudo mv ~/Downloads/rabbitmq.pem /var/lib/jenkins/.ssh</div>

<div data-plaintext="true">sudo chmod 400 /var/lib/jenkins/.ssh/rabbitmq.pem</div>

<div data-plaintext="true">sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/rabbitmq.pem</div>

</div>

<div>And we are done with the AWS prelim setup.</div>

* * *

## Part 2: GitHub and Jenkins Setup

<div>**<span style="font-size: 20px;">GITHUB</span>**</div>

<div>For this project (and most professional settings) you will want to keep your infra files in  their own repository and then have Jenkins checkout those files and run them as needed.</div>

<div>So for this, create a Github Repo now for your project. You can call this whatever you'd like. I am naming mine **devops3-Terraform-RMQ-AWS**.</div>

<div>I've also created this repo with a README and .gitignore file with the **[terraform](https://github.com/github/gitignore/blob/master/Terraform.gitignore)** template.</div>

<div>in your project dir on your machine, clone that here.</div>

<div>Next, for Jenkins to have access, we need to provide an ssh key.</div>

<div>In your terminal:</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">ssh-keygen</div>

</div>

<div>when prompted, you can rename this (in the .ssh dir) to be something that coincides with Jenkins (i.e. mine is jenkins_rsa)</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/6a929bc5-d753-4f25-b8c6-4130c7fee15b.png)

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">cat ~/.ssh/jenkins_rsa.pub</div>

</div>

<div>Copy that output and jump over to github and navigate to your users settings (click on your icon top right and select **settings > SSH and GPG Keys**)</div>

<div>Add a new ssh key and name it something like "Jenkins" and then paste the output you copied previously.</div>

<div>Save it and continue to Jenkins.</div>

<div>**<span style="font-size: 20px;">JENKINS</span>**</div>

<div>**<span style="font-size: 20px;">
</span>**</div>

<div>**<span style="font-size: 20px;"><span data-markholder="true"></span></span>**</div>

<div><span style="font-size: 16px;">If Jenkins is not started on your machine, go ahead and fire it up with</span></div>

<div><span style="font-size: 16px;">
</span></div>

<div><span style="font-size: 16px;"><span data-markholder="true"></span></span></div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">sudo service jenkins start</div>

</div>

<div>Once that is running, navigate to [http://localhost:8080](http://localhost:8080) and complete the standard prompted setup. Grab the initial password at </div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">sudo cat /var/lib/jenkins/secrets/initialAdminPassword</div>

</div>

<div>Once you are in navigate to "**Manage Jenkins" > "Manage Plugins".** We need to add the following in "Available"</div>

*   **CloudBees AWS Credentials**

<div>Now navigate back to **'Manage Jenkins'** > **'Manage Credentials'** and drill down to global creds.</div>

<div>Click on **Add Credential** and select **SSH Username with Private Key**. </div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">cat ~/.ssh/jenkins_rsa</div>

</div>

<div>Paste that output into this field with your username.</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/4737bd2a-fb4d-4c28-9202-59c29e08ad11.png)

<div>Add another credential and this time select "AWS Credentials". Enter your Access Key and Secret key from your ~/.aws/credentials file and give the Id the IAM username for reference.</div>

<div>Finally, navigate back to **manage jenkins > manage users** and click on <span data-highlight="yellow" style="background-color: #ffef9e;">your user</span>. Now click **configure** on the left. Under **API TOKEN** add and generate a new token. save this and keep it SAFE. We will need it at the end.</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/71568f9b-40e2-4bd7-8a6d-e61cc1e3a793.png)

* * *

## Part 3: Terraform

<div>Before we dive in, review the end result of our project and I recommend for this project you do the same (directories in blue):</div>

<div>.</div>

<div>├── **<span style="color:rgb(13, 58, 153);">ansible</span>**</div>

<div>│   └── **<span style="color:rgb(13, 58, 153);">rmq</span>**</div>

<div>│       └── rmq_playbook.yml</div>

<div>└── **<span style="color:rgb(13, 58, 153);">terraform</span>**</div>

<div>    └── **<span style="color:rgb(13, 58, 153);">rmq</span>**</div>

<div>        ├── main.tf</div>

<div>        └── variables.tf</div>

<div>So inside your main project directory do:</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">mkdir terraform</div>

<div data-plaintext="true">mkdir terraform/rmq</div>

<div data-plaintext="true">cd terraform/rmq</div>

<div data-plaintext="true">touch main.tf variables.tf</div>

</div>

<div>If you didn't notice from the dir structure, this is for our EC2 RabbitMQ instance.</div>

<div>Open both of those files in your editor and add the following:</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">provider "aws" {</div>

<div data-plaintext="true">    region = "us-east-1"</div>

<div data-plaintext="true">    profile = var.profile</div>

<div data-plaintext="true">}</div>

<div data-plaintext="true">resource "aws_instance" "rmq" {</div>

<div data-plaintext="true">    ami = "ami-07ebfd5b3428b6f4d"</div>

<div data-plaintext="true">    instance_type = "t2.micro"</div>

<div data-plaintext="true">    key_name = "rabbitmq"</div>

<div data-plaintext="true">    vpc_security_group_ids = ["sg-0e2e056a0c9e6abcc"]</div>

<div data-plaintext="true">    tags = {</div>

<div data-plaintext="true">        Name = var.name</div>

<div data-plaintext="true">        group = var.group</div>

<div data-plaintext="true">    }</div>

<div data-plaintext="true">}</div>

</div>

<div>Pretty simple in this case. We have the provider and resource here. We also have the security group ID from the SG we created back in the preliminary setup. Note the key_name is the rabbitmq key we created in the last example. In addition, we want to update our variables.tf file as well with the **name** and **profile** vars.</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">variable "name" {</div>

<div data-plaintext="true">    description = "name the instance on deploy"</div>

<div data-plaintext="true">}</div>

<div data-plaintext="true">variable "group" {</div>

<div data-plaintext="true">    description = "The group name that ansible's dynamic inventory will groups"</div>

<div data-plaintext="true">}</div>

<div data-plaintext="true">variable "profile" {</div>

<div data-plaintext="true">    description = "Which profile to use for IAM"</div>

<div data-plaintext="true">}</div>

</div>

<div>Now, a very important piece here is to push this branch to your repo, as Jenkins will need it. so:</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">git add .</div>

<div data-plaintext="true">git commit -m "initial commit with Terraform additions"</div>

<div data-plaintext="true">git push origin main</div>

</div>

<div>I used "main" here so I can skip a merge step...but it's recommended you create branches...</div>

<div>That's it for our Terraform segment.</div>

* * *

## Part 4: Jenkins Job

<div>Now that we have something in our repo, let's start on jenkins by opening http://localhost:8080</div>

<div>Head to the dashboard and create a new job (freestyle project) and name it:</div>

<div>**RabbitMQ_Terraform_Build**</div>

<div>**<span data-markholder="true"></span>**</div>

<div>In the first segment, select the box "This project is parameterized" and add the following Params: **Action (Choice), Ansible (Boolean), Name (String), Group (string)**:</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/e88c89ac-9a25-4fdb-b30d-1bb6e295c623.png)![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/e994df83-39de-4eb1-b261-d3a24a76e475.png)![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/ed2c58d0-6019-49fe-9be4-21fa649e38ae.png)![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/3303211f-e62b-49bf-8882-d24a2fa11811.png)

<div>Now, scroll to "Source Code Management" and select Git. Enter your repo information here and use the ssh key creds me made earlier. Select to build it off of Main (or a branch of your choice)</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/7e0fbd2d-d816-487f-b808-b26b334c2f28.png)

<div>Jump all the way down to Build Environment and select **Use secret text(s) or file(s)**. Select **AWS access key and secret key** and choose the key from the credentials that you created in the prelim steps.</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/919af4c6-c2b7-4109-8709-1e95378041ef.png)

<div>In the **Build Steps** and add a Shell build step in the drop down. In this text box we will add our commands. </div>

<div>Don't get too hung up on what I did here. In fact, I hope you will make it your own and make it better. I simply have an **if elif else** statement here. One for apply, plan, and destroy. ( you will see in the next step why we have a separate one for apply. Note the -auto-approve on apply and destroy. This is to get us through the terraform promt.</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">if [ $Action = "apply" ]; then</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" -auto-approve terraform/rmq</div>

<div data-plaintext="true">elif [ $Action = "plan" ]; then</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" terraform/rmq</div>

<div data-plaintext="true">else</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" -auto-approve terraform/rmq</div>

<div data-plaintext="true">fi</div>

</div>

<div>Now save it and run it with **plan** selected. You should see your terraform plan output in the jenkins console output.</div>

* * *

## Part 5: Ansible with a Dynamic inventory

<div>If you have used ansible with the /etc/ansible/hosts file, you can imagine that it gets out of hand adding hosts as they are created. So why not make use of a dynamic inventory?</div>

<div>From the main project dir, I want to mkdir ansible and then ansible/rmq (and make my playbook)</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">mkdir ansible</div>

<div data-plaintext="true">mkdir ansible/rmq</div>

<div data-plaintext="true">cd ansible/rmq</div>

<div data-plaintext="true">touch rmq_playbook.yml</div>

</div>

<div>Now, we also need to add an **ansible.cfg**  (if its not there) and a dir called **group_vars/** with a file inside called **tag_group_rmq.yaml**. </div>

<div>The config will be used here to set a default of not prompting to ask whether or not you want to add a new host to known_hosts.</div>

<div>The group vars are used by ansible to help us use the group tag in our EC2 and apply a specific set of params to that group. So in this case, **user** and **ssh private key**</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">printf "</div>

<div data-plaintext="true">[defaults]</div>

<div data-plaintext="true">host_key_checking = False" | sudo tee /etc/ansible/ansible.cfg</div>

<div data-plaintext="true">sudo mkdir /etc/ansible/group_vars</div>

<div data-plaintext="true">printf "</div>

<div data-plaintext="true">---</div>

<div data-plaintext="true">ansible_ssh_private_key_file: /var/lib/jenkins/.ssh/rabbitmq.pem</div>

<div data-plaintext="true">ansible_user: ubuntu" |sudo tee /etc/ansible/group_vars/tag_group_rmq.yaml</div>

</div>

<div>We also want to create a file /etc/ansible/aws_ec2.yaml and open it.</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">sudo touch /etc/ansible/aws_ec2.yaml</div>

</div>

<div>straight from Ansible's documentation (with some tweaks) we want to add</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">plugin: amazon.aws.aws_ec2</div>

<div data-plaintext="true">boto_profile: DevOpsUser</div>

<div data-plaintext="true">regions:</div>

<div data-plaintext="true">  - us-east-1</div>

<div data-plaintext="true">strict: False</div>

<div data-plaintext="true">keyed_groups:</div>

<div data-plaintext="true">  - prefix: tag</div>

<div data-plaintext="true">    key: 'tags'</div>

<div data-plaintext="true">compose:</div>

<div data-plaintext="true">  ansible_host: ip_address</div>

</div>

<div>Then in the playbook (in our project directory **ansible/rmq**), let's add our basic Rabbit install and then run it with the start command. The last two steps will be for our Admin panel and initial user.</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">---</div>

<div data-plaintext="true">    - name: Configure Jenkins Playbook</div>

<div data-plaintext="true">      hosts: tag_group_rmq</div>

<div data-plaintext="true">      tasks:</div>

<div data-plaintext="true">        - name: install RMQ</div>

<div data-plaintext="true">          become: yes</div>

<div data-plaintext="true">          shell: |</div>

<div data-plaintext="true">            apt-get update -y</div>

<div data-plaintext="true">            apt-get install curl gnupg -y</div>

<div data-plaintext="true">            curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add -</div>

<div data-plaintext="true">            apt-get install apt-transport-https</div>

<div data-plaintext="true">            tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF</div>

<div data-plaintext="true">            deb https://dl.bintray.com/rabbitmq-erlang/debian bionic erlang</div>

<div data-plaintext="true">            deb https://dl.bintray.com/rabbitmq/debian bionic main</div>

<div data-plaintext="true">            EOF</div>

<div data-plaintext="true">            apt-get update -y</div>

<div data-plaintext="true">            apt-get install rabbitmq-server -y --fix-missing</div>

<div data-plaintext="true">        - name: Start RMQ</div>

<div data-plaintext="true">          become: yes</div>

<div data-plaintext="true">          shell: service rabbitmq-server start</div>

<div data-plaintext="true">        - name: Enable admin gui</div>

<div data-plaintext="true">          become: yes</div>

<div data-plaintext="true">          shell: rabbitmq-plugins enable rabbitmq_management</div>

<div data-plaintext="true">        - name: Add initial user</div>

<div data-plaintext="true">          become: yes</div>

<div data-plaintext="true">          shell: |</div>

<div data-plaintext="true">            rabbitmqctl add_user sparlor welcome1</div>

<div data-plaintext="true">            rabbitmqctl set_user_tags sparlor administrator</div>

</div>

* * *

## Part 6: Final steps and launch

<div>Let's add a last job for our RMQ and call it **RabbitMQ_Configuration.** All we need to do for this job is add out git url like in our first jenkins job, add a build trigger and then add a **shell** build step with the following:</div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">ansible-playbook -i /etc/ansible/aws_ec2.yaml ansible/rmq/rmq_playbook.yml</div>

</div>

<div>To trigger this, under the **Build Trigger** section, check the box that says **<span style="color:rgb(51, 51, 51);">Trigger builds remotely (e.g., from scripts)</span> **<span style="color:rgb(51, 51, 51);">and then add an authentication token like...</span>**<span style="color:rgb(51, 51, 51);">verysecureansibletoken</span>**</div>

<div>**<span style="color:rgb(51, 51, 51);">
</span>**</div>

<div>**<span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span>**</div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/92e0088c-9b8f-466a-8a52-ef15d6bfe3b3.png)

<div>**<span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span>**</div>

<div><span style="color:rgb(51, 51, 51);">Use something more secure 🙂</span></div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

<div><span style="color:rgb(51, 51, 51);">Save it</span></div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

<div><span style="color:rgb(51, 51, 51);">Lastly, navigate back over to our first job and add an if statement nested inside the apply, as well as a new parameter</span></div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

<div><span style="color:rgb(51, 51, 51);">So in the</span> **RabbitMQ_Terraform_Build** configure panel add a boolean parameter called Ansible and then make sure your shell command looks like this (**<span data-highlight="yellow" style="background-color: #ffef9e;">Replace <u>USER:TOKEN</u> with your username and the token from the setup</span>**). </div>

<div data-codeblock="true" style="padding: 8px; font-family: Monaco, Menlo, Consolas, &quot;Courier New&quot;, monospace; font-size: 12px; color: rgb(51, 51, 51); border-radius: 4px; background-color: rgb(251, 250, 248); border: 1px solid rgba(0, 0, 0, 0.15);">

<div data-plaintext="true">if [ $Action = "apply" ]; then</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" -auto-approve terraform/rmq</div>

<div data-plaintext="true">    if [ $Ansible ]; then</div>

<div data-plaintext="true">        curl http://localhost:8080/job/RabbitMQ_Configuration/build?token=ansibletest \</div>

<div data-plaintext="true">        --user USER:TOKEN</div>

<div data-plaintext="true">    fi</div>

<div data-plaintext="true">elif [ $Action = "plan" ]; then</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" terraform/rmq</div>

<div data-plaintext="true">else</div>

<div data-plaintext="true">    terraform init terraform/rmq</div>

<div data-plaintext="true">    terraform $Action -var "name=$Name" -var "profile=DevOpsUser" -var "group=$Group" -auto-approve terraform/rmq</div>

<div data-plaintext="true">fi</div>

</div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

<div><span style="color:rgb(51, 51, 51);">
</span></div>

<div><span style="color:rgb(51, 51, 51);">Now you are done. If you check that ansible box on apply and run it, terraform will build your ec2, and then on success run the ansible script!</span></div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

* * *

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

<div><span style="color:rgb(51, 51, 51);">At this point, you can navigate over to</span> [RabbitMQ's tutorial](https://www.rabbitmq.com/tutorials/tutorial-one-python.html) <span style="color:rgb(51, 51, 51);">and complete it using your EC2 instance!</span></div>

<div><span style="color:rgb(51, 51, 51);"><span data-markholder="true"></span></span></div>

![](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2021-01-20/4855a31d-043f-45d4-9ae8-f9976987d561.png)

<div> <span style="color:rgb(51, 51, 51);">Try to think</span> **<span style="color:rgb(51, 51, 51);"><u>critically</u></span>** <span style="color:rgb(51, 51, 51);">about way's you can add certain steps to your configurations we made above. I do plan on doing more real world RMQ examples in the late future. But this will get you started. Happy learning!</span></div>

            </pre>

</div>

</div>

<div id="disqus_thread"><iframe id="dsq-app8483" name="dsq-app8483" allowtransparency="true" frameborder="0" scrolling="no" tabindex="0" title="Disqus" width="100%" src="https://disqus.com/embed/comments/?base=default&amp;f=scottyfullstack&amp;t_u=https%3A%2F%2Fwww.scottyfullstack.com%2Fblog%2Fdevops-button-click-environment-build-tutorial%2F&amp;t_d=Devops%20Button%20Click%20Environment%20Build%20Tutorial&amp;t_t=Devops%20Button%20Click%20Environment%20Build%20Tutorial&amp;s_o=default#version=cfefa856cbcd7efb87102e7242c9a829" style="width: 1px !important; min-width: 100% !important; border: none !important; overflow: hidden !important; height: 812px !important;" horizontalscrolling="no" verticalscrolling="no"></iframe></div>

<script>/** * RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS. * LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/ /* var disqus_config = function () { this.page.url = PAGE_URL; // Replace PAGE_URL with your page's canonical URL variable this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable }; */ (function() { // DON'T EDIT BELOW THIS LINE var d = document, s = d.createElement('script'); s.src = 'https://scottyfullstack.disqus.com/embed.js'; s.setAttribute('data-timestamp', +new Date()); (d.head || d.body).appendChild(s); })();</script>

<noscript>Please enable JavaScript to view the [comments powered by Disqus.](https://disqus.com/?ref_noscript)</noscript>

</div>
