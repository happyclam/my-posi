require "spec_helper"

describe StrategiesController do
  describe "routing" do

    it "routes to #index" do
      get("/strategies").should route_to("strategies#index")
    end

    it "routes to #new" do
      get("/strategies/new").should route_to("strategies#new")
    end

    it "routes to #show" do
      get("/strategies/1").should route_to("strategies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/strategies/1/edit").should route_to("strategies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/strategies").should route_to("strategies#create")
    end

    it "routes to #update" do
      put("/strategies/1").should route_to("strategies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/strategies/1").should route_to("strategies#destroy", :id => "1")
    end

  end
end
