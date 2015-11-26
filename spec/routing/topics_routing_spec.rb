require "rails_helper"

RSpec.describe TopicsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/topics/new").to route_to("topics#new")
    end

    it "routes to #create" do
      expect(post: "/topics").to route_to("topics#create")
    end

    it "routes to #show" do
      expect(get: "topics/1").to route_to("topics#show", id: "1")
    end

    it "routes to #close" do
      expect(post: "topics/1/close").to route_to("topics#close", topic_id: "1")
    end

    it "routes to #open" do
      expect(post: "topics/1/open").to route_to("topics#open", topic_id: "1")
    end
  end
end
