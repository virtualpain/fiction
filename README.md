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