# Pagodabox Command Line Interface

Thank you for choosing pagodabox [Pagodabox](http://www.pagodabox.com).

## Features

This client currently supports:

* Application functions
  * Creation
  * Clone
  * init
  * Deploy
  * Rollback
* Tunnel to live database

## How to use:

Using the command line interface can be fun!

    $ gem install pagoda

    Fetching: pagoda-0.3.2.gem (100%)
    Successfully installed pagoda-0.3.2
    1 gem installed
    Installing ri documentation for pagoda-0.3.2...
    Installing RDoc documentation for pagoda-0.3.2...

    $ pagoda launch workflowdemo
   
    +> Registering workflowdemo
    +> Launching........  
    +> workflowdemo launched
   
    +> deploying to match current branch and commit.....  
    +> deployed
   
    -----------------------------------------------
   
    LIVE URL    : http://workflowdemo.pagodabox.com
    ADMIN PANEL : http://dashboard.pagodabox.com
   
    -----------------------------------------------


## Get Started

### Install Pagoda

Install ruby and the gem thing. then do "gem install pagoda"

### Navigate

Navigate into the folder of your repo

	$ cd /path/to/repo

### Launch your app

Select a app name and launch it

  $ pagoda launch <appname>


## More Information

More information can be found in our [Guides](http://guides.pagodabox.com/getting-started/pagoda-terminal-client)

