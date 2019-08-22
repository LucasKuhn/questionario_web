class LoginController < BaseController
  class << self

    def layout(content, flash_messages = nil)
      <<~HTML
      <!DOCTYPE html>
      <html lang="en" dir="ltr">
      <head>
      <meta charset="utf-8">
      <title></title>
      <!-- Bootstrap core CSS -->
      <link href="/css/bootstrap.min.css" rel="stylesheet">
      </head>
      <body>
      #{html_alert(flash_messages)}
      #{content}
      </body>
      </html>
      HTML
    end

    def html_alert(flash_messages)
      if flash_messages
      <<~HTML
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto mt-3" role="alert">
        <div class="alert alert-primary" role="alert">
        #{flash_messages}
        </div>
      </div>
      HTML
      else
        ""
      end
    end

    def new(env)
      render("login/new.html.erb",env['x-rack.flash'].error)
    end

    def login(params)
      Pessoa.find(usuario:params['usuario'],senha:params['senha'])
    end

  end
end
