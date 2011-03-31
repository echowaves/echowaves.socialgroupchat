# require 'spec_helper'
# 
# describe ConvosController do
# 
#   def mock_convo(stubs={})
#     @mock_convo ||= mock_model(Convo, stubs).as_null_object
#   end
# 
#   # WORKAROUND
#   before do
#     # request.env['warden'] = mock_model(Warden, :authenticate => @user, :authenticate! => @user)
#     User.make
# 
# 
#   end
# 
#   describe "GET index" do
#     it "assigns all convos as @convos" do
#       Convo.stub(:all) { [mock_convo] }
#       get :index
#       assigns(:convos).should eq([mock_convo])
#     end
#   end
# 
#   describe "GET show" do
#     it "assigns the requested convo as @convo" do
#       Convo.stub(:find).with("37") { mock_convo }
#       get :show, :id => "37"
#       assigns(:convo).should be(mock_convo)
#     end
#   end
# 
#   describe "GET new" do
#     it "assigns a new convo as @convo" do
#       Convo.stub(:new) { mock_convo }
#       get :new
#       assigns(:convo).should be(mock_convo)
#     end
#   end
# 
#   describe "GET edit" do
#     it "assigns the requested convo as @convo" do
#       Convo.stub(:find).with("37") { mock_convo }
#       get :edit, :id => "37"
#       assigns(:convo).should be(mock_convo)
#     end
#   end
# 
#   describe "POST create" do
# 
#     describe "with valid params" do
#       it "assigns a newly created convo as @convo" do
#         Convo.stub(:new).with({'these' => 'params'}) { mock_convo(:save => true) }
#         post :create, :convo => {'these' => 'params'}
#         assigns(:convo).should be(mock_convo)
#       end
# 
#       it "redirects to the created convo" do
#         Convo.stub(:new) { mock_convo(:save => true) }
#         post :create, :convo => {}
#         response.should redirect_to(convo_url(mock_convo))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns a newly created but unsaved convo as @convo" do
#         Convo.stub(:new).with({'these' => 'params'}) { mock_convo(:save => false) }
#         post :create, :convo => {'these' => 'params'}
#         assigns(:convo).should be(mock_convo)
#       end
# 
#       it "re-renders the 'new' template" do
#         Convo.stub(:new) { mock_convo(:save => false) }
#         post :create, :convo => {}
#         response.should render_template("new")
#       end
#     end
# 
#   end
# 
#   describe "PUT update" do
# 
#     describe "with valid params" do
#       it "updates the requested convo" do
#         Convo.should_receive(:find).with("37") { mock_convo }
#         mock_convo.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => "37", :convo => {'these' => 'params'}
#       end
# 
#       it "assigns the requested convo as @convo" do
#         Convo.stub(:find) { mock_convo(:update_attributes => true) }
#         put :update, :id => "1"
#         assigns(:convo).should be(mock_convo)
#       end
# 
#       it "redirects to the convo" do
#         Convo.stub(:find) { mock_convo(:update_attributes => true) }
#         put :update, :id => "1"
#         response.should redirect_to(convo_url(mock_convo))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns the convo as @convo" do
#         Convo.stub(:find) { mock_convo(:update_attributes => false) }
#         put :update, :id => "1"
#         assigns(:convo).should be(mock_convo)
#       end
# 
#       it "re-renders the 'edit' template" do
#         Convo.stub(:find) { mock_convo(:update_attributes => false) }
#         put :update, :id => "1"
#         response.should render_template("edit")
#       end
#     end
# 
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested convo" do
#       Convo.should_receive(:find).with("37") { mock_convo }
#       mock_convo.should_receive(:destroy)
#       delete :destroy, :id => "37"
#     end
# 
#     it "redirects to the convos list" do
#       Convo.stub(:find) { mock_convo(:destroy => true) }
#       delete :destroy, :id => "1"
#       response.should redirect_to(convos_url)
#     end
#   end
# 
# end
