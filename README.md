# simple_cuke

Description
===========
This chef cookbook provides dead simple way to test and verify node's setup after chef run using [cucumber](https://github.com/cucumber/cucumber) and [aruba](https://github.com/cucumber/aruba). Unlike [similar](https://github.com/Atalanta/cucumber-chef) [tools](https://github.com/hedgehog/cuken) it's designed to be fully understood and ready to use in less then 5 minutes by the average developer.

It could be used as a tool to support BDD style in development of your infrastructure and as a regression testing tool.

You can find some background and more detailed information [here](http://iafonov.github.com/blog/pragmatic-infrastructure-testing-with-cucumber.html).

Requirements
============
Cookbook depends on Opscode's [chef_handler](http://community.opscode.com/cookbooks/chef_handler) cookbook. (Run `knife cookbook site install chef_handler` to install it)

There are no additional limitations on environment. You can use it with any kind of chef (hosted/private/solo).

Attributes
==========
* `node["simple_cuke"]["suite_path"]` - Location for the test suite on the target node (`/var/chef/handlers/suite` by default)

Usage
=====
1. Install this cookbook to your chef repo. (`git clone git://github.com/iafonov/simple_cuke.git cookbooks/simple_cuke`)
2. Add `recipe[simple_cuke]` to run_list
3. Start writing cucumber features and place them in `files/default/suite/features` folder
4. Run `chef-client` and enjoy

How it works
============
After each `chef-client` run a set of cucumber features is executed on a target node. As simple as it is. No black magic involved[*](#details).

Running role specific features
==============================
Add role name as tag to the scenario or feature and it would be run only on nodes that have this role. Features/scenarios without tags would be run always.

Aruba
=====
The cookbook will automatically install and link aruba gem for you. Aruba is a set of handy cucumber steps that are intended to test command line applications and test manipulation with file system - this is exactly what is needed during verification of infrastructure setup. I recommend you to quickly go through provided steps definitions to prevent reintroducing already available steps. You can see the complete definitions list [here](https://github.com/cucumber/aruba/blob/master/lib/aruba/cucumber.rb).

Custom steps
============
There are no restrictions - you can use your own defined steps. Put the step definitions into `features/step_definitions/[younameit]_steps.rb` file and they would be loaded automatically. 

Examples
========

Simple example - check that Apache is running:

```gherkin
@appserver
Feature: Application server

Scenario: Apache configuration check
  When I successfully run `ps aux`
  Then the output should contain "apache"
```

Slightly more advanced example: check services are running, bind to their ports and aren't blocked by firewall:

```gherkin
@base
Feature: Services

Scenario Outline: Service should be running and bind to port
  When I run `lsof -i :<port>`
  Then the output should match /<service>.*<user>/

  Examples:
    | service | user     | port |
    | master  | root     |   25 |
    | apache2 | www-data |   80 |
    | dovecot | root     |  110 |
    | mysqld  | mysql    | 3306 |

Scenario Outline: Service should not be blocked by firewall
  When I run `ufw status`
  Then the output should match /<service>.*<action>/

  Examples:
    | service | action |
    | OpenSSH |  ALLOW |
    | Apache  |  ALLOW |
    | Postfix |  ALLOW |
```
<a name="details"></a>
How it works (in details)
=========================
The idea behind implementation is to be as simple and straightforward as possible. The workflow consists of the following three steps:

1. Default recipe synchronizes the `files/default/suite` cookbook's folder with remote node via calling `remote_directory` LWRP.
2. [Chef handler](http://wiki.opscode.com/display/chef/Exception+and+Report+Handlers) is registered.
3. When handler is executed it installs the bundle (it consists of cucumber & aruba) and runs cucumber features.

For now reporting is done only to console.

© 2012 [Igor Afonov](http://iafonov.github.com)