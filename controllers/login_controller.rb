class LoginController < BaseController
  class << self

    def layout(content, flash_messages = nil)
      <<~HTML
      <!DOCTYPE html>
      <html lang="en" dir="ltr">
      <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="Plataforma web de aplicação de testes">
      <meta name="author" content="Lucas Kuhn">

      <title>Questionário Web</title>
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

    def login(env,params)
      user = Pessoa.find(usuario:params['usuario'],senha:params['senha'])
      if user
        env['rack.session'][:user_id] = user.id
        return [ 302, {'Location' =>"/"}, [] ]
      else
        env['x-rack.flash'].error = 'Credenciais inválidas'
        return [ 302, {'Location' =>"/sign_in"}, [] ]
      end
    end

  end
end
