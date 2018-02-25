# YARD-Cucumber: A Requirements Documentation Tool

## Synopsis

YARD-Cucumber (formerly Cucumber-In-The-Yard) is a YARD extension that processes
Cucumber features, scenarios, steps, tags, step definitions, and even transforms
to provide documentation similar to what you expect to how YARD displays
classes, methods and constants.This tools bridges the gap of having feature
files found in your source code and true documentation that your team, product
owners and stakeholders can use.

## Examples

I have created a trivial, example project to help provide a quick
visualization of the resulting documentation. I encourage you to look at it as
an example and see if it would assist your project from a multitude of
perspectives: as the project's core developer; another developer or a new
developer; quality assurance engineer; or product owner/stakeholder.

The implemented example has been deployed at [http://burtlo.github.io/yard-cucumber/](http://burtlo.github.io/yard-cucumber/).

**1. View Features and Scenarios** [example](http://burtlo.github.io/yard-cucumber/requirements.html)

**2. Search through [features, scenarios](http://burtlo.github.io/yard-cucumber/feature_list.html), and [tags](http://burtlo.github.io/yard-cucumber/tag_list.html)**

**3. Dynamic Tag Unions and Intersections** [example](http://burtlo.github.io/yard-cucumber/requirements/tags.html)

**4. View all features and scenarios by tag** [example](http://burtlo.github.io/yard-cucumber/requirements/tags/bvt.html)

**5. View Step Definitions and Transforms** [example](http://burtlo.github.io/yard-cucumber/requirements/step_transformers.html)

**6. All steps [matched](http://burtlo.github.io/yard-cucumber/requirements/step_transformers.html#definition_5-stepdefinition) to step definitions**

**7. [Steps](http://burtlo.github.io/yard-cucumber/requirements/step_transformers.html#step_transform7-steptransform) that have transforms applied to them**

**8. [Undefined steps](http://burtlo.github.io/yard-cucumber/requirements/step_transformers.html#undefined_steps) and even [Rubular](http://rubular.com/) links of your step definitions.**

**9. Feature directories with a README.md will be parsed into the description** [example](http://burtlo.github.io/yard-cucumber/requirements/example/child_feature.html)

**10. Configurable Menus - want a searchable steps menu and remove the tags menu**

**11. Step definitions in your language (Ruby 1.9.2 - Internationalization)**

## Installation

YARD-Cucumber requires the following gems installed:

Gherkin 2.2.9 - http://cukes.info
Cucumber 0.7.5 - http://cukes.info
YARD 0.8.1 - http://yardoc.org

To install `yard-cucumber` use the following command:

```bash
$ gem install yard-cucumber
```

(Add `sudo` if you're installing under a POSIX system as root)

## Usage

YARD supports for automatically including gems with the prefix `yard-`
as a plugin. To enable automatic loading yard-cucumber.

```bash
$ mkdir ~/.yard
$ yard config load_plugins true
$ yardoc 'example/**/*.rb' 'example/**/*.feature'
```

Now you can run YARD as you [normally](https://github.com/lsegal/yard) would and
have your features, step definitions and transforms captured.

An example with the rake task:

```ruby
require 'yard'

YARD::Rake::YardocTask.new do |t|
t.files   = ['features/**/*.feature', 'features/**/*.rb']
t.options = ['--any', '--extra', '--opts'] # optional
end
```


## Configuration

* Adding or Removing search fields (yardoc)

Be default the yardoc output will generate a search field for features and tags.
This can be configured through the yard configuration file `~/.yard/config` to
add or remove these search fields.

```yaml
--- !ruby/hash-with-ivars:SymbolHash
elements:
  :load_plugins: true
  :ignored_plugins: []
  :autoload_plugins: []
  :safe_mode: false
  :"yard-cucumber":
    menus: [ 'features', 'directories', 'tags', 'steps', 'step definitions' ]
ivars:
  :@symbolize_value: false
```

By default the configuration, yaml format, that is generate by the `yard config`
command will save a `SymbolHash`. You can still edit this file add the entry for
`:"yard-cucumber":` and the sub-entry `menus:` which can contain all of the above
mentioned menus or simply an empty array `[]` if you want no additional menus.

* Step definitions in your language (Ruby 1.9.2)

Again the yard configuration file you can define additional step definitions
that can be matched.

```yaml
:"yard-cucumber":
  language:
    step_definitions: [ 'Given', 'When', 'Then', 'And', 'Soit', 'Etantdonné', 'Lorsque', 'Lorsqu', 'Alors', 'Et' ]
```

In this example, I have included the French step definition words alongside the
English step definitions. Even without specifying this feature files in other
languages are found, this provides the ability for the step definitions to match
correctly to step definitions.

* Exclude features or scenarios from yardoc

You can exclude any feature or scenario from the yardoc by adding a predefined tags to them.
To define tags that will be excluded, again in yard configuration file:

```yaml
:"yard-cucumber":
  exclude_tags: [ 'exclude-yardoc', 'also-exclude-yardoc' ]
```

## Details

There are two things that I enjoy: a test framework written in my own Domain
Specific Language (DSL) that is easily understood by all those on a project
and the ability for all participants to easily read, search, and view the tests.

Cucumber is an amazing tool that allowed me to define exercisable requirements.
My biggest obstacle was bringing these requirements to my team, the product
owner, and other stakeholders.

Initially I tried to expose more of the functionality by providing freshly
authored requirements through email, attachments to JIRA tickets, or linked in
wiki documents. None of these methods were very sustainable or successful.
First, I was continually pushing out the documents to those interested.
Second, the documents were displayed to the user in text without the syntax
highlighting that was exceedingly helpful for quickly understanding the requirements.

I also found it hard to share the test framework that I had put together with
another developer that joined the team. It was difficult to direct them around
the features, tags, step definitions, and transforms. It was when I started to
convey to them the conventions that I had established that I wished I had a
tool that would allow me to provide documentation like one would find generated
by a great tool like YARD.

So I set out to integrate Cucumber objects like features, backgrounds,
scenarios, tags, steps, step definitions, and transforms into a YARD template.
From my quick survey of the landscape I can see that the my needs are
different than a lot of others that use Cucumber.  The entire project that
spawned this effort was solely to exercise the functionality of a different,
large project and so there is a huge dependence on having the requirements
documented.  This is in contrast to other projects that are using this on a
small scale to test the functionality of small software component.  Though,
ultimately, I realized that the functionality may provide a valuable tool for
many as I feel it helps more solidly bridge the reporting of the documentation
by putting a coat of paint on it.


## LICENSE

(The MIT License)

Copyright (c) 2011 Franklin Webber

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
