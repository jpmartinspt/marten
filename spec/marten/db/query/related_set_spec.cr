require "./spec_helper"

describe Marten::DB::Query::RelatedSet do
  describe "#all" do
    it "is scoped to the related field target" do
      user_1 = TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")
      user_2 = TestUser.create!(username: "jd2", email: "jd2@example.com", first_name: "John", last_name: "Doe")

      post_1 = Post.create!(author: user_1, title: "Post 1")
      Post.create!(author: user_2, title: "Post 2")
      post_3 = Post.create!(author: user_1, title: "Post 3")

      qset = Marten::DB::Query::RelatedSet(Post).new(user_1, "author_id")

      qset.all.to_set.should eq(Set{post_1, post_3})
    end
  end

  describe "#create" do
    it "creates a new record with the related field set" do
      user = TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")

      qset = Marten::DB::Query::RelatedSet(Post).new(user, "author_id")

      new_post = qset.create(title: "Post")

      new_post.valid?.should be_true
      new_post.persisted?.should be_true
      new_post.author.should eq user
    end

    it "creates a new record with the related field set when a block is used" do
      user = TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")

      qset = Marten::DB::Query::RelatedSet(Post).new(user, "author_id")

      new_post = qset.create do |p|
        p.title = "Post"
      end

      new_post.valid?.should be_true
      new_post.persisted?.should be_true
      new_post.author.should eq user
    end
  end

  describe "#create!" do
    it "creates a new record with the related field set" do
      user = TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")

      qset = Marten::DB::Query::RelatedSet(Post).new(user, "author_id")

      new_post = qset.create!(title: "Post")

      new_post.valid?.should be_true
      new_post.persisted?.should be_true
      new_post.author.should eq user
    end

    it "creates a new record with the related field set when a block is used" do
      user = TestUser.create!(username: "jd1", email: "jd1@example.com", first_name: "John", last_name: "Doe")

      qset = Marten::DB::Query::RelatedSet(Post).new(user, "author_id")

      new_post = qset.create! do |p|
        p.title = "Post"
      end

      new_post.valid?.should be_true
      new_post.persisted?.should be_true
      new_post.author.should eq user
    end
  end
end
