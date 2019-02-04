# Using this Project #

The purpose of this project is to show how you can use GitHub and OpenShift to deploy code in a CI/CD fashion.  

>This is just one example, and was purposely kept simple.  If you look at Source 2 Image or Pipeline style build strategies there are much more robust examples for CI/CD utilizing source control management and integrating it with various other systems (ticketing, approval, test suites, etc)

1.    Create a new project
    
        ```
        oc new-project <project name>
        ```


2.  Create a secret 

    a.  For SSH/GIT

    ```
    oc create secret generic <secret_name> \
    --from-file=ssh-privatekey=<path_to_ssh_priv_key> \
    --type=kubernetes.io/ssh-auth
    ```

    b.  For authenticated HTTPS either...

    Using a token
        
    ```
    oc create secret generic <secret_name> \
    --from-literal=password=<your_token> \
    --type=kubernetes.io/basic-auth
    ```

    Or using credentials
    ```
    oc create secret generic <secret_name> \
    --from-literal=username=<username> \
    --from-literal=password=<password> \
    --type=kubernetes.io/basic-auth
    ```

3.  Give the 'builder' service account access to the credentials
    ```
    oc secrets link builder <secret_name>
    ```


4.  Create the App

    a.)  Using git/ssh
    ```
    oc new-app ssh://git@<git_host>/<project_path>#<branch> \
    --name=<app_name> \
    --source-secret=<secret_name>
    ```
    
    
    b.)  Using http/https (without authentication/public repos)
    ```
    oc new-app https://<git_host>/<project_path>#<branch> \
    --name=<app_name>
    ```

    c.)  Using http/https (with authentication/private repos)

    ```
    oc new-app https://<git_host>/<project_path>#<branch> \
    --name=<app_name> \
    --source-secret=<secret_name>
    ```

    >  If using http/https for a private repo you will be prompted for credentials


5.  Create a route to expose external traffic to your app
    ```
    oc expose svc/<app_name>
    ```


6.  Set resource limits for your deployment
    ```
    oc set resources dc/<app_name> \
    --requests='cpu=10m' \
    --limits='cpu=100m'
    ```
    >  These limits are very low so that scaling can be show in a demo environment (m=millicores=1/1000 cpu core)

7.  Set a scaling policy for your app
    ```
    oc autoscale dc/test-app \
    --min 1 \
    --max 10 \
    --cpu-percent 5
    ```
    
    >This scale policy is very low again to show scaling in a demo environment

8.  Get the URI and secret used for GitHub webhooks
    ```
    oc describe bc/<app_name> | \
    grep -A 1 'Webhook GitHub' | \
    grep https | cut -f 3 -d$'\t'
    ```
    ```
    oc get bc/<app_name> | \
    grep -A 1 github: | \
    cut -f 2 -d ':' | \
    tr -d ' '
    ```
    >The URI provided in the 'oc describe' command will have a field shown as \<secret\>, replace that with the string obtained from the 'oc get' command

9. Update GitHub to utilize your webhook

    a.  From within the web interface of GitHub navigate to your repo
    
    b.  Click on the 'Settings' tab
    
    c.  Click on the 'Webhooks' sidebar
    
    d.  Click on the 'Add webhook' button
    
    e.  For the Payload URL enter in the URI from step 8 (remembering to replace the \<secret\> with your own secret)
    
    f.  Set content type to 'application/json'
    
    g.  For the 'Secret' field enter your secret from step 8
    
    h.  For the events section select the 'Just the push event'
    
    i.  Click 'Add webhook'

10.  Profit (branches)

        Now that you have it all configured, anytime there is a push event to the repo the webhook will trigger, which will cause OpenShift to re-build your app, and in the process pulling down the new code.

        For bonus points you can do this across several branches of the same repository, and give each branch its own name and deployment (you can do this by following the steps above again).

        When a pull request is approved/merged the upstream branch will automatically trigger its webhook as well and start a re-build.

11.  Extra Profit (A/B)

        If you have multiple branches and apps and want to do a blue-green deployment (for UAT, perhaps) we can spread the traffic across them.

        ```
        oc set route-backends <app_name_1> <app_name_1>=<weight> <app_name_2>=<weight> 
        ```
        > It is worth noting that in this instance traffic hitting the route for <app_name_1> will be split between the two environments depending on the weight, however traffic hitting the route for <app_name_2> will only hit the <app_name_2> environment (unless its route also has A/B routing configured)

        Check your routes and weights for the app
        ```
        oc set route-backends <app_name_1>
        ```

        If you wish to adjust the weights you can do so with the --adjust option, ex:
        ```
        oc set route-backends <app_name_1> \
        --adjust <app_name_1>=<weight> <app_name_2>=<weight>
        ```