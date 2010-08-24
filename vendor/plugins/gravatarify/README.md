Gravatarify
===========

Hassle-free construction of those pesky gravatar.com urls, with out-of-the-box support for
Rails, Haml and _your favorite framework_. It's not that there aren't any alternatives [out](http://github.com/mdeering/gravitar_image_tag),
[there](http://github.com/chrislloyd/gravtastic), but none seem to support stuff like `Proc`s
for the default picture url, or the multiple host names supported by gravatar.com (great when
displaying lots of avatars).

- **Source**: <http://github.com/lwe/gravatarify>
- **Docs**:   <http://rdoc.info/projects/lwe/gravatarify>
- **Gem**:    <http://gemcutter.org/gems/gravatarify>

**UPGRADE NOTES:** Version 2.x is a clean-up release which breaks backwards compatibility
with 1.x releases (in some cases!). HTML attributes must be passed like:
`gravatar_tag(@user, :size => 30, :html => { :class => "gravatar" })`, i.e. in a `:html` hash.
Furthermore the `gravatarify` method for ActiveRecord and DataMapper no longer exists,
see "Upgrading from 1.x" for more.

Ready, Set, Go!
---------------

**READY** Install gravatarify as a gem (requires gemcutter):

    [sudo] gem install gravatarify
    
or as Rails plugin: 
    
    ./script/plugin install git://github.com/lwe/gravatarify.git
    
**SET** When using the Rails plugin, skip this step. Anyhow, just ensure that when installed as a gem
it's bundled using `bundler` or defined in `config/environment.rb`, or just that it's on the `$LOAD_PATH`
and then `require 'gravatarify'`'d somehow.

**GO** Use it! When using Rails or Haml then just give it an email and it will return the gravatar url:

    # creates an 20x20 pixel <img/> tag in your Rails ERB views:
    <%= gravatar_tag @user.email, :size => 20 %>
    
    # or in HAML views
    # (Note: how it's possible to skip the email attribute, btw - that's a feature)
    %img{ gravatar_attrs(@user, :size => 20) }/
    
**More!?** Allright, that was just the quickstart, to get up and running with ease. However, this library provides
quite a bit more, like:

 * View helpers, namely `gravatar_url` and `gravatar_tag`, see "Using the view helpers".
 * Styles are like reusable definitions of options, nice to DRY-up your code, see "Using styles".
 * A base module which provides the gravatar url generation, ready to be integrated into
   custom helpers, plain ruby code or whatever, see "Back to the roots".

Using the view helpers
----------------------

Probably one of the easiest ways to add support for gravatar images is with the included view helpers.
When using Rails or HAML these should be automatically available, if not do something like:

    # e.g. for Sinatra
    helpers Gravatarify::Helper

    # or include for Haml
    Haml::Helpers.send(:include, Gravatarify::Helper)

    # NOTE: basically just include the Gravatarify::Helper module

This then provides three helper methods: `gravatar_url`, `gravatar_attrs` and `gravatar_tag`.
To just build a simple `<img/>` tag, pass in an object (if it responds to `email` or `mail`)
or a string containing the e-mail address:

    <%= gravatar_tag @user %> # => assumes @user.respond_to?(:email) or @user.respond_to?(:mail)

This builds a neat `<img/>`-tag. To display an "X" rated avatar which is 25x25 pixel in size
and the `<img/>` tag should have a class attribute, do:

    <%= gravatar_tag @user, :size => 25, :rating => :x, :html => { :class => "gravatar" } %>

If any additional HTML attributes are needed on the tag, or in the `gravatar_attrs`, just
pass them in the `:html` option as hash. If more control is needed, or just the plain URL is
required, resort to `gravatar_url`, which returns a string with the (unescaped) url:
    
    <img src="<%= h(gravatar_url(@user.author_email, :size => 16)) %>" alt="Gravatar"/>
        
Using styles
------------

With styles it's possible to easily change e.g. the size of all gravatars based on a name,
these are reusable presets of options:
  
    # in config/initializers/gravatarify.rb or similar:
    Gravatarify.styles[:mini] = { :size => 16, :html => { :class => 'gravatar gravatar-mini' } }
    Gravatarify.styles[:default] = { :size => 45, :html => { :class => 'gravatar' } }
 
    # then in/some/view.html.erb:
    <%= gravatar_tag @user, :mini %> # => <img alt="" class="gravatar gravatar-mini" height="16" src.... />
    
    # or in/another/view.html.haml:    
    %img{ gravatar_attrs(@user, :default) }/ # => <img alt="" class="gravatar" height="45" ... />
    
Need to change to size of all `:mini` gravatars? Easy, just change the definition in `Gravatarify.styles`.
Of course settings via `Gravatarify.options` are "mixed-in" as well, so:

    Gravatarify.options[:default] = Proc.new { |*params| "http://example.com/avatar-#{params.first[:size] || 80}.jpg" }
    Gravatarify.styles[:mini] => { :size => 16 }
    
    <%= gravatar_tag @user, :mini %> # => <img alt="" height="16" src=".....?d=http://example.com/avatar-16.jpg" width="16" />

All methods accept a style, i.e. a style parameter can be passed in to `gravatar_attrs`, `gravatar_tag` and
of course to `gravatar_url`. Any option can be passed in after a style, to customize the gravatar
if the styles needs slight alteration:

    gravatar_url(@user, :mini, :filetype => false, :rating => :x) # => "http://........123ab12?s=16&r=x"


Back to the roots?
------------------

No need for sophisticated stuff like view helpers, want to go back to the roots?
Then feel free to use `Gravatarify::Base#gravatar_url` directly.
    
When the ability to display image tags is required in different view frameworks (like liquid!?),
then just ensure that `Gravatarify::Helper` is included in the framework in question.
See {Gravatarify::Base#gravatar_url} and of course {Gravatarify::Helper} for more informations
and usage examples.

Need more control?
==================

<table>
  <tr>
    <th>Option</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>:default</tt></td>
    <td>String, Proc</td>
    <td>Fully qualified URL to an image, which is used if gravatar.com has no image for the supplied email.
        <tt>Proc</tt>s can be used to return e.g. an image based on the request size (see Advanced stuff).
        Furthermore gravatar.com provides several "special values" which generate icons, these are "wavatar",
        "monsterid" and "identicon", finally if set to <tt>404</tt> gravatar.com returns the <tt>HTTP 404 Not Found</tt> error.
        If nothing is specified gravatar.com returns it's gravatar icon.
    </td>
    <td>-</td>
  </tr>
  <tr>
    <td><tt>:rating</tt></td>
    <td>String, Symbol</td>
    <td>Each avatar at gravatar.com has a rating associated (which is based on MPAAs rating system), valid values are:<br/>
        <b>g</b> - general audiences, <b>pg</b> - parental guidance suggested, <b>r</b> - restricted and <b>x</b> - x-rated :).
        Gravatar.com returns <b>g</b>-rated avatars, unless anything else is specified.
    </td>
    <td>-</td>
  </tr>
  <tr>
    <td><tt>:size</tt></td>
    <td>Integer</td>
    <td>Avatars are square, so <tt>:size</tt> defines the length of the sides in pixel, if nothing is specified gravatar.com
        returns 80x80px images.</td>
    <td>-</td>
  </tr>
  <tr>
    <td><tt>:secure</tt></td>
    <td>Boolean, Proc</td>
    <td>If set to <tt>true</tt> gravatars secure host (<i>https://secure.gravatar.com/</i>) is used to serve the avatars
      from. Can be a Proc to inflect wheter or not to use the secure host based on request parameters.</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>:filetype</tt></td>
    <td>String, Symbol</td>
    <td>Change image type, gravatar.com supports <tt>:gif</tt>, <tt>:png</tt> and <tt>:jpg</tt>. If set to <tt>false</tt> 
      then a URL without an extension will be built (and gravatar.com then returns a JPG image).</td>
    <td><tt>:jpg</tt></td>
  </tr>
  <tr>
    <td><tt>:html</tt></td>
    <td>Hash</td>
    <td>Ignored in URL generation, only used in <tt>gravatar_attrs</tt> and <tt>gravatar_tag</tt> to pass in additional
      HTML attributes (like <tt>class</tt>, <tt>id</tt> etc.).</td>
    <td>-</td>
  </tr>
</table>

To set the options globally, access the `Gravatarify.options` hash and set any options which should apply to all
gravatar urls there. Of course all settings can be overridden locally:

    # disable suffix and set default size to 16x16px
    Gravatarify.options[:filetype] = false
    Gravatarify.options[:size] = 16
    
    gravatar_url(@user.email) # => http://0.gravatar.com/avatar/..f93ff1e?s=16
    gravatar_url(@user.email, :filetype => :png) # => http://0.gravatar.com/avatar/..f93ff1e.png?s=16
    
To define global HTML attributes go ahead and do something like:

    # add title attribute
    Gravatarify.options[:html] = { :title => "Gravatar" }
    
## Not yet enough?

The `:default` option can be passed in a `Proc`, so this is certainly useful to for example
to generate an image url, based on the request size:

    # in an initializer
    Gravatarify.options[:default] = Proc.new do |options, object|
      "http://example.com/avatar-#{options[:size] || 80}.jpg"
    end
    
    # now each time a gravatar url is generated, the Proc is evaluated:
    gravatar_url(@user)
    # => "http://0.gravatar.com/...jpg?d=http%3A%2F%2Fexample.com%2Fgravatar-80.jpg"
    gravatar_url(@user, :size => 16)
    # => "http://0.gravatar.com/...jpg?d=http%3A%2F%2Fexample.com%2Fgravatar-16.jpg&s=16"
    
Into the block is passed the options hash and as second parameter the object itself, so it's possible to do stuff like

    # doing stuff like showing default avatar based on gender...
    @user = User.new(:gender => :female, :email => 'bella@gmail.com') # => @user.female? = true
    
    gravatar_url @user, :default => Proc.new { |opts, obj| "http://example.com/avatar#{obj.respond_to?(:female) && obj.female? ? '_female' : ''}.jpg" }
    # => http://0.gravatar.com/...jpg?d=http%3A%2F%2Fexample.com%2Fgravatar_female.jpg

Not only the `:default` option accepts a Proc, but also `:secure`, can be useful to handle cases where
it should evaluate against `request.ssl?` for example.

## Upgrading from 1.x

All HTML options must be passed in the `:html` attribute. This allows for predictable results for
all methods and no magic involved! So instead of doing:

    gravatar_tag(@user, :size => 30, :class => "gravatar", :title => "Gravatar")
    # Note: in Version 2.0 this would build an image src like http://..gravatar.com/...../?class=gravatar&s=30&title=Gravatar
    
do:

    gravatar_tag(@user, :size => 30, :html => { :class => "Gravatar", :title => "Gravatar" })
    
An important thing to know is that the `:html` is deep merged, with defaults, so stuff like:

    Gravatarify.options[:html] = { :title => "Gravatar" }
    gravatar_tag(@user, :html => { :class => "gravatar" }) # => <img alt="" class="gravatar" ... title="Gravatar" .../>
    
Furthermore the option `:html` is ignored when building the url parameters.

If the `gravatarify` method was not used, there's no need to change anything at all :) Though if
it's used, then...

 1. Remove all occurences of `gravatarify` in the models
 2. Change calls from `<%= image_tag @user.gravatar_url %>` to
    saner `<%= gravatar_tag @user %>` calls, or if just the url
    is required to `gravatar_url(@user)`.

If the model used `gravatarify :author_email`, then changes in the views must reflect that and use it
directly: `<%= gravatar_tag @user.author_email %>`. If the model defines `author_email`, but **not**
`email` (and has no attribute named `email`), then it could be safely aliased like:

    # Fields: (id, name, author_email, ...)
    class Author < ActiveRecord::Base
      alias_attribute :email, :author_email
    end
    
    # and in the views:
    <%= gravatar_tag @author %>

In most cases the migration path should be pretty easy, just always use the helper
methods! The `gravatarify` method was introduced to provide compatibility with
`gravtastic`, yet it's not way to go in my opinion. If for some reason it's required
then feel free to fallback and use an older version (i.e. 1.2.1):

    [sudo] gem install gravatarify -v 1.2.1
    

About the code
==============

Eventhough this library has about 100 LOC, it's split into four files, maybe a bit
of an overkill, though I like neat and tidy classes :)

    lib/gravatarify.rb                      # loads the other files from lib/gravatarify
                                            # and hooks the necessary modules into
                                            # HAML or ActionView.
                                            
    lib/gravatarify/base.rb                 # Provides all logic required to generate
                                            # gravatar.com urls from an email address.
                                            # Check out Gravatarify::Base.gravatar_url,
                                            # this is the absolute core method.
                                                                                        
    lib/gravatarify/helper.rb               # Defines the view helpers: gravatar_attrs
                                            # and gravatar_tag
                                            
    lib/gravatarify/utils.rb                # Provides commonly used methods, like helpers to
                                            # uri and html escape strings or deep mergeing
                                            # hashes. Though these utils are only for internal
                                            # uses :)
                                            
### Contribute

 1. Fork the project and hack away
 2. Ensure that the changes are well tested
 3. Send me a pull request
 
### Thanks

 - [gudleik](http://github.com/gudleik) for his work on allowing an empty `:filetype`

Licence
=======

Copyright (c) 2009 Lukas Westermann

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
