require 'test_helper'

class MockView
  include Gravatarify::Base
end

class GravatarifyBaseTest < Test::Unit::TestCase
  include Gravatarify::Base
  
  def setup; reset_gravatarify!; Gravatarify.subdomains = %w{www} end
    
  context "#gravatar_url, but without any options yet" do
    should "generate correct url for hash without options" do
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url('bella@gmail.com')
    end

    should "trim and lowercase email address (as according to gravatar docs)" do
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url("\tbella@gmail.com \n\t")
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url("BELLA@gmail.COM")
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url(" BELLA@GMAIL.com")
    end

    should "handle a nil email as if it were an empty string" do
      assert_equal NIL_JPG, gravatar_url(nil)
      assert_equal NIL_JPG, gravatar_url('')
    end
    
    should "be aliased to #build_gravatar_url, for backwards compatibility" do
      assert_equal BELLA_AT_GMAIL_JPG, build_gravatar_url('bella@gmail.com')
    end
  end
  
  context "#gravatar_url, with options" do
    should "add well known options like size, rating or default and always in alphabetical order" do
      assert_match "#{BELLA_AT_GMAIL_JPG}?s=16", gravatar_url('bella@gmail.com', :size => 16)
      assert_equal "#{BELLA_AT_GMAIL_JPG}?d=http%3A%2F%2Fexample.com%2Ftest.jpg&s=20", gravatar_url('bella@gmail.com', :size => 20, :default => 'http://example.com/test.jpg')
      assert_equal "#{BELLA_AT_GMAIL_JPG}?other=escaped%26yes%3F&r=x&s=30", gravatar_url('bella@gmail.com', :size => 30, :rating => :x, :other => "escaped&yes?")
    end
    
    should "ensure that all options are escaped correctly" do
      assert_equal "#{BELLA_AT_GMAIL_JPG}?unescaped=escaped%2Fme", gravatar_url('bella@gmail.com', 'unescaped' => 'escaped/me')
    end
    
    should "ignore false or nil options" do
      assert_equal "#{BELLA_AT_GMAIL_JPG}?s=24", gravatar_url('bella@gmail.com', :s => 24, :invalid => false, :other => nil)
    end
    
    should "allow different :filetype to be set, like 'gif' or 'png'" do
      assert_equal "#{BELLA_AT_GMAIL}.gif", gravatar_url('bella@gmail.com', :filetype => :gif)
      assert_equal "#{BELLA_AT_GMAIL}.png", gravatar_url('bella@gmail.com', :filetype => :png)
    end
  
    should "skip :filetype if set to false, nil or ''" do
      assert_equal "#{BELLA_AT_GMAIL}", gravatar_url('bella@gmail.com', :filetype => false)
      assert_equal "#{BELLA_AT_GMAIL}", gravatar_url('bella@gmail.com', :filetype => nil)
      assert_equal "#{BELLA_AT_GMAIL}", gravatar_url('bella@gmail.com', :filetype => '')
      assert_equal "#{BELLA_AT_GMAIL}.foobar", gravatar_url('bella@gmail.com', :filetype => 'foobar')
      assert_equal "#{BELLA_AT_GMAIL}.gif", gravatar_url('bella@gmail.com', :filetype => :gif)
    end
    
    should "handle Procs as :default, to easily generate default urls based on supplied :size" do
      default = Proc.new { |*args| "http://example.com/gravatar#{args.first[:size] ? '-' + args.first[:size].to_s : ''}.jpg" }
      assert_equal "#{BELLA_AT_GMAIL_JPG}?d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url('bella@gmail.com', :default => default)        
      assert_equal "#{BELLA_AT_GMAIL_JPG}?d=http%3A%2F%2Fexample.com%2Fgravatar-25.jpg&s=25", gravatar_url('bella@gmail.com', :size => 25, :d => default)
      assert_equal "#{BELLA_AT_GMAIL_JPG}?d=http%3A%2F%2Fexample.com%2Fgravatar-20.jpg&s=20", gravatar_url('bella@gmail.com', :size => 20, 'd' => default)
    end    
  end
  
  context "#gravatar_url when passed in an object" do
    should "look for :email method and use it to generate gravatar_url from" do
      obj = Object.new
      mock(obj).email { "bella@gmail.com" }
      
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url(obj)
    end
    
    should "look for :mail of field :email does not exist" do
      obj = Object.new
      mock(obj).mail { "bella@gmail.com" }
      
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url(obj)      
    end
    
    should "finally just use to_s... if neither :email nor :mail exists" do
      obj = Object.new
      mock(obj).to_s { "bella@gmail.com" }
      
      assert_equal BELLA_AT_GMAIL_JPG, gravatar_url(obj)      
    end
    
    should "handle Procs as :default and pass in the 'object' as second parameter" do
      default = Proc.new { |options, object| "http://example.com/gravatar#{object.respond_to?(:female?) && object.female? ? '_girl' : ''}.jpg" }
      girl = Object.new
      mock(girl).email { "bella@gmail.com" }
      mock(girl).female? { true }      
      assert_equal "#{BELLA_AT_GMAIL_JPG}?d=http%3A%2F%2Fexample.com%2Fgravatar_girl.jpg", gravatar_url(girl, :default => default)
      
      boy = Object.new
      mock(boy).email { "hans@gmail.com" }
      mock(boy).female? { false }
      assert_equal "http://www.gravatar.com/avatar/b6987c8f1d734e684cf9721970b906e5.jpg?d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url(boy, :default => default)      
    end    
  end
  
  context "Gravatar hosts support" do
    should "switch to different hosts based on generated email hash, yet always the same for consecutive calls with the same email!" do
      assert_match %r{\Ahttp://(0|1|2|www).gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg\z}, gravatar_url('bella@gmail.com')
      assert_equal gravatar_url('bella@gmail.com'), gravatar_url('bella@gmail.com')
      assert_match %r{\Ahttp://(0|1|2|www).gravatar.com/avatar/41d86cad3dd465d6913d5a3232744441.jpg\z}, gravatar_url('bella@bella.com')
      assert_match %r{\Ahttp://(0|1|2|www).gravatar.com/avatar/8f3af64e9c215d158b062a7b154e071e.jpg\z}, gravatar_url('bella@hotmail.com')
      assert_match %r{\Ahttp://(0|1|2|www).gravatar.com/avatar/d2279c22a33da2cb57defd21c33c8ec5.jpg\z}, gravatar_url('bella@yahoo.de')
    end
    
    should "switch to https://secure.gravatar.com if :secure => true is supplied" do
      assert_equal "https://secure.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg", gravatar_url('bella@gmail.com', :secure => true)
      assert_equal "https://secure.gravatar.com/avatar/41d86cad3dd465d6913d5a3232744441.jpg", gravatar_url('bella@bella.com', :secure => true)
      assert_equal "https://secure.gravatar.com/avatar/d2279c22a33da2cb57defd21c33c8ec5.jpg", gravatar_url('bella@yahoo.de', :secure => true)
    end
    
    should "allow Procs for :secure option, enables pretty cool stuff for stuff like request.ssl?" do
      Gravatarify.options[:secure] = Proc.new { |obj| obj.request.ssl? }
      
      mock_ssl = MockView.new
      mock(mock_ssl).request.stub!.ssl? { true }      
      assert_equal "https://secure.gravatar.com/avatar/1cacf1bc403efca2e7a58bcfa9574e4d.jpg", mock_ssl.gravatar_url('bella@gmail.com')
      
      mock_no_ssl = MockView.new
      mock(mock_no_ssl).request.stub!.ssl? { false }
      assert_equal BELLA_AT_GMAIL_JPG, mock_no_ssl.gravatar_url('bella@gmail.com')
    end
  end
    
  context "Gravatarify#options" do
    setup do
      Gravatarify.options[:anything] = "test"
      Gravatarify.options[:filetype] = "png"
      Gravatarify.options[:default] = "http://example.com/gravatar.jpg"
    end
    
    should "ensure that default options are always added" do
      assert_equal "#{BELLA_AT_GMAIL}.png?anything=test&d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url('bella@gmail.com')
    end
    
    should "ensure that default options can be overriden by passing options into gravatar_url call" do
      assert_equal "#{BELLA_AT_GMAIL}.gif?anything=else&d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url('bella@gmail.com', :anything => "else", :filetype => :gif)
    end
    
    should "ensure that no filetypes are added when :filetype set to false, unless locally specified" do
      Gravatarify.options[:filetype] = false
      assert_equal "#{BELLA_AT_GMAIL}?anything=test&d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url('bella@gmail.com')
      assert_equal "#{BELLA_AT_GMAIL}.png?anything=test&d=http%3A%2F%2Fexample.com%2Fgravatar.jpg", gravatar_url('bella@gmail.com', :filetype => 'png')
    end
  end
end
