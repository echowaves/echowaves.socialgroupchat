require File.dirname(__FILE__) + '/lib/socky'
require File.dirname(__FILE__) + '/lib/socky/helper'

ActionView::Base.send(:include, Socky::Helper)

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :socky => ['socky/swfobject', 'socky/FABridge', 'socky/web_socket', 'socky/json2', 'socky']