require 'test_helper'
require 'gravatarify/helper'

class GravatarifyHelpersTest < Test::Unit::TestCase
  include Gravatarify::Helper  
  
  def setup
    # just ensure that no global options are defined when starting next test
    reset_gravatarify!
    Gravatarify.subdomains = %w{www}
  end
  
  context "#gravatar_attrs" do
    should "return hash with :height, :width, :alt and :src defined" do
      hash = gravatar_attrs('bella@gmail.com', :size => 16)
      expected = { :alt => "", :src => "#{BELLA_AT_GMAIL_JPG}?s=16", :width => 16, :height => 16 }
      assert_equal expected, hash
      assert_nil hash[:size]
    end
    
    should "allow any param to be defined/overridden, except src, width and heigth" do
      hash = gravatar_attrs('bella@gmail.com', :size => 20, :r => :x, :foo => 40,
                  :html => { :alt => 'bella', :id => 'test', :title => 'something', :class => 'gravatar'})
      expected = {
        :alt => 'bella', :src => "#{BELLA_AT_GMAIL_JPG}?foo=40&r=x&s=20", :width => 20, :height => 20,
        :id => 'test', :title => 'something', :class => 'gravatar'
      }
      assert_equal expected, hash
      assert_nil hash[:size]
      assert_nil hash[:r]
    end
  end  
  
  context "#gravatar_tag helper" do
    should "create <img/> tag with correct gravatar urls" do
      assert_equal '<img alt="" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg" width="80" />', gravatar_tag('bella@gmail.com')
    end
    
    should "create <img/> tags and handle all options correctly, other options should be passed to Rails' image_tag" do
      assert_equal '<img alt="" height="16" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg?s=16" width="16" />',
              gravatar_tag('bella@gmail.com', :size => 16)
      assert_equal '<img alt="" class="gravatar" height="16" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg?d=x&amp;s=16" width="16" />',
              gravatar_tag('bella@gmail.com', :html => { :class => "gravatar" }, :size => 16, :d => "x")
    end
    
    should "ensure that all values are correctly html-esacped!" do
      assert_equal '<img alt="" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg" title="&lt;&gt;" width="80" />',
              gravatar_tag('bella@gmail.com', :html => { :title => '<>' })
    end
    
    should "be html_safe if rails ~> 2.3.5" do
      require 'active_support'
      require 'active_support/core_ext/string/output_safety' # for rails 3, be explicit...
      assert gravatar_tag('bella@gmail.com').html_safe?, "#html_safe? expected to return <true>"
    end
  end
  
  context "#gravatar_tag when passed in an object" do
    should "create <img/>-tag based on :email field" do
      obj = Object.new
      mock(obj).email { "bella@gmail.com" }
      
      assert_equal '<img alt="" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg" width="80" />',
                      gravatar_tag(obj)      
    end    
  end
  
  context "Gravatarify::Helper#html_options" do
    should "add be added to all tags/hashes created by gravatar_tag or gravatar_attrs" do
      Gravatarify.options[:html] = { :title => "Gravatar", :class => "gravatar" } # add a title attribute, yeah neat-o!
      
      assert_equal '<img alt="" class="gravatar" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg" title="Gravatar" width="80" />',
                      gravatar_tag('bella@gmail.com')
      hash = gravatar_attrs('bella@gmail.com', :size => 20, :html => { :title => "Gravatar for Bella", :id => "test" })
      expected = {
        :alt => "", :width => 20, :height => 20, :src => "http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg?s=20",
        :title => "Gravatar for Bella", :id => "test", :class => "gravatar"
      }
      assert_equal expected, hash
    end
    
    should "not allow :src, :height or :width to be set via global options and all local options should override!" do
      Gravatarify.options[:html] = { :src => "avatar-30.jpg", :width => 30, :title => "Avatar" }
      
      assert_equal '<img alt="" height="25" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg?s=25" title="Gravatar" width="25" />',
                   gravatar_tag('bella@gmail.com', :size => 25, :html => { :title => 'Gravatar' })
    end
    
    should "allow :alt to be set globally" do
      Gravatarify.options[:html] = { :alt => "Gravatar" }
      
      assert_equal '<img alt="Gravatar" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg" width="80" />',
                   gravatar_tag('bella@gmail.com')
      assert_equal '<img alt="Avatar" height="80" src="http://www.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d" width="80" />',
                   gravatar_tag('bella@gmail.com', :filetype => false, :html => { :alt => 'Avatar' })
    end
  end
end