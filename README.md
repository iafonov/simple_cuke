## Simple Cuke

Description
===========
Cookbook provides dead simple ability to test & verify node setup after chef run using [cucumber](https://github.com/cucumber/cucumber) & [aruba](https://github.com/cucumber/aruba). Unlike its competitors it is designed to be fully understood and ready to use in less then 5 minutes by the average developer.

It could be used as a tool to support BDD style in development of your infrastructure.

How it works
============
After each chef-client run a set of cucumber features is executed on a target node. As simple as it is. No black magic involved.

Requirements
============
Cookbook depends on Opscode's chef_handler cookbook. (Run `knife cookbook site install chef_handler` to install it)

Attributes
==========
* `node["simple_cuke"]["suite_path"]` - Location for the test suite on the target node

Usage
=====
1. Install this cookbook
2. Add `recipe[simple_cuke]` to run_list
3. Start writing cucumber features and place them in `files/default/suite/features` folder
4. Enjoy

Running role specific features
==============================
Add role name as tag to the scenario or feature and it would be run only on nodes that have this role.

Example
=======

```gherkin
Feature: Web server

@appserver
Scenario: Apache should be running
  When I successfully run `ps aux`
  Then the output should contain "apache"
```
