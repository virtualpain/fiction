# Fiction

A ruby program to manage my fiction writings. All writings are
written in markdown. Textile supports soon.

## Install

Install gem requirements, do:

    $ bundle install

Then add bin/fiction to your PATH

## Usage

	$ fiction new "Your Story Title"
	$ cd your_story_title
	$ fiction chapter "New Chapter"
	$ fiction generate
	$ fiction serve

That will create new story with `Your Story Title`, then enter the fic directory, create new chapter, then generate it into html, and finally serve it on localhost:4000.

## Commands

* `new "Story Title"` : Generate new story
* `chapter "Chapter title"`:  Create new story (inside story folder)
* `doc`: generate empty documentation
* `generate`: compile the story into HTML
* `generatedoc`: compile the documentation into HTML
* `serve [port:4000]`: create local server to preview the generated HTML, by default: localhost:4000
* `backup`: create backup zip file of the story and documentation. Generated HTML is not included 

## TODOs

This few things I considered missing before version 1:

* html generator using nokogiri instead using template (hardcoded)
* custom template (must be .html) and style (css, less, sass, scss) if defined in the config. Template will be located in storyname/template
* license text (defined in config)
* pagination through chapters
* set default configs so config.yml content can be minified.
* `fix` command to generate missing files (config file,license file, docs dir, or html dir)
* showing help text if command is unknown
* generate readme on story generation