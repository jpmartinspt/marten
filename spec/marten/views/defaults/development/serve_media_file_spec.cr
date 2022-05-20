require "./spec_helper"

describe Marten::Views::Defaults::Development::ServeMediaFile do
  describe "#get" do
    it "returns the content of a specific media file with the right content type" do
      dir_path = File.join(Marten.settings.media_files.root, "test")
      file_path = File.join(dir_path, "test.txt")

      FileUtils.mkdir_p(dir_path)
      File.write(file_path, "Hello World")

      request = Marten::HTTP::Request.new(
        ::HTTP::Request.new(
          method: "GET",
          resource: "",
          headers: HTTP::Headers{"Host" => "example.com"}
        )
      )
      params = Hash(String, Marten::Routing::Parameter::Types){"path" => "test/test.txt"}
      view = Marten::Views::Defaults::Development::ServeMediaFile.new(request, params)

      response = view.dispatch

      response.status.should eq 200
      response.content_type.should eq MIME.from_filename(file_path)
      response.content.should eq File.read(file_path)
    end

    it "returns a 404 response if the media file cannot be found" do
      request = Marten::HTTP::Request.new(
        ::HTTP::Request.new(
          method: "GET",
          resource: "",
          headers: HTTP::Headers{"Host" => "example.com"}
        )
      )
      params = Hash(String, Marten::Routing::Parameter::Types){"path" => "test/unknown.txt"}
      view = Marten::Views::Defaults::Development::ServeMediaFile.new(request, params)

      response = view.dispatch

      response.status.should eq 404
    end

    it "returns a 404 response if the passed path corresponds to a directory" do
      FileUtils.mkdir_p(File.join(Marten.settings.media_files.root, "test"))

      request = Marten::HTTP::Request.new(
        ::HTTP::Request.new(
          method: "GET",
          resource: "",
          headers: HTTP::Headers{"Host" => "example.com"}
        )
      )
      params = Hash(String, Marten::Routing::Parameter::Types){"path" => "test"}
      view = Marten::Views::Defaults::Development::ServeMediaFile.new(request, params)

      response = view.dispatch

      response.status.should eq 404
    end
  end
end