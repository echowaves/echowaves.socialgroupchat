require File.dirname(__FILE__) + '/spec_helper'  

describe Socky do
  it "should have config in hash form" do
    Socky::CONFIG.should_not be_nil
    Socky::CONFIG.class.should eql(Hash)
  end
  
  it "should have host list taken from config" do
    Socky.hosts.should eql(Socky::CONFIG[:hosts])
  end
  
  context "#send" do
    before(:each) do
      Socky.stub!(:send_data)
    end
    it "should send broadcast with data" do
      Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
      Socky.send("test")
    end
    context "should normalize options" do
      it "when no data given" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => ""})
        Socky.send
      end
      it "when string given" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test")
      end
      it "when block given" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send do |page|
          page << "test"
        end
      end
      it "when hash given" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send({:data => "test"})
      end
    end
    context "with block" do
      it "should allow javascript helpers" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "alert(\"test!\");"})
        Socky.send do |page|
          page.alert("test!")
        end
      end
      it "should handle variables from current context" do
        phrase = "test phrase"
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => phrase})
        Socky.send do |page|
          page << phrase
        end
      end
    end
    context "should handle recipient conditions for" do
      it ":to => :client" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :to => { :clients => "first" }})
        Socky.send("test", :to => { :client => "first" })
      end
      it ":to => :clients" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :to => { :clients => ["first","second"] }})
        Socky.send("test", :to => { :clients => ["first","second"] })
      end
      it ":to => :channel" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :to => { :channels => "first" }})
        Socky.send("test", :to => { :channel => "first" })
      end
      it ":to => :channels" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :to => { :channels => ["first","second"] }})
        Socky.send("test", :to => { :channels => ["first","second"] })
      end
      it ":except => :client" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :except => { :clients => "first" }})
        Socky.send("test", :except => { :client => "first" })
      end
      it ":except => :clients" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :except => { :clients => ["first","second"] }})
        Socky.send("test", :except => { :clients => ["first","second"] })
      end
      it ":except => :channel" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :except => { :channels => "first" }})
        Socky.send("test", :except => { :channel => "first" })
      end
      it ":except => :channels" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test", :except => { :channels => ["first","second"] }})
        Socky.send("test", :except => { :channels => ["first","second"] })
      end
      it "combination" do
        Socky.should_receive(:send_data).with({
          :command => :broadcast,
          :body => "test",
          :to => {
            :clients => "allowed_user",
            :channels => "allowed_channel"
          },
          :except => {
            :clients => "disallowed_user",
            :channels => "disallowed_channel"
          }
        })
        Socky.send("test", :to => {
          :clients => "allowed_user",
          :channels => "allowed_channel"
        },
        :except => {
          :clients => "disallowed_user",
          :channels => "disallowed_channel"
        })
      end
    end
    context "should ignore nil value for" do
      it ":to => :clients" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :to => { :clients => nil })
      end
      it ":to => :channels" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :to => { :channels => nil })
      end
      it ":except => :clients" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :except => { :clients => nil })
      end
      it ":except => :channels" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :except => { :channels => nil })
      end
    end
    context "should handle empty array for" do
      it ":to => :clients by not sending message" do
        Socky.should_not_receive(:send_data)
        Socky.send("test", :to => { :clients => [] })
      end
      it ":to => :channels by not sending message" do
        Socky.should_not_receive(:send_data)
        Socky.send("test", :to => { :channels => [] })
      end
      it ":except => :clients by ignoring it" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :except => { :clients => [] })
      end
      it ":except => :channels by ignoring it" do
        Socky.should_receive(:send_data).with({:command => :broadcast, :body => "test"})
        Socky.send("test", :except => { :channels => [] })
      end
    end
  end
  
  context "#show_connections" do
    before(:each) do
      Socky.stub!(:send_data)
    end
    it "should send query :show_connections" do
      Socky.should_receive(:send_data).with({:command => :query, :type => :show_connections}, true)
      Socky.show_connections
    end
  end
  
end