class ApplicationTest << Minitest::Test
  include Rack::Test::Methods

  def app
    Application.new
  end

  def test_its_good_enough
    get "/"
    assert last_response.ok?
    assert_equal "Good enough", last_response.body
  end

end
