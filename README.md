## Simple Cuke For Chef

Description
===========
Cookbook provides dead simple way to test and verify node's setup after chef run using [cucumber](https://github.com/cucumber/cucumber) and [aruba](https://github.com/cucumber/aruba). Unlike its competitors it's designed to be fully understood and ready to use in less then 5 minutes by the average developer.

It could be used as a tool to support BDD style in development of your infrastructure and as regression testing tool.

Requirements
============
Cookbook depends on Opscode's [chef_handler](http://community.opscode.com/cookbooks/chef_handler) cookbook. (Run `knife cookbook site install chef_handler` to install it)

Attributes
==========
* `node["simple_cuke"]["suite_path"]` - Location for the test suite on the target node

Usage
=====
1. Install this cookbook
2. Add `recipe[simple_cuke]` to run_list
3. Start writing cucumber features and place them in `files/default/suite/features` folder
4. Enjoy

How it works
============
After each chef-client run a set of cucumber features is executed on a target node. As simple as it is. No black magic involved.


Running role specific features
==============================
Add role name as tag to the scenario or feature and it would be run only on nodes that have this role. Features/scenarios without tags would be run always.

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

Slightly more advanced example: check services are running, bind to their ports and are not blocked by firewall:

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