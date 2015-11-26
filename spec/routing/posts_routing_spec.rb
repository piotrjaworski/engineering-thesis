require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/topics/1/posts/new").to route_to("posts#new", topic_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/topics/1/posts/1/edit").to route_to("posts#edit", topic_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/topics/1/posts").to route_to("posts#create", topic_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/topics/1/posts/1").to route_to("posts#update", topic_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/topics/1/posts/1").to route_to("posts#update", topic_id: "1", id: "1")
    end
  end
end
