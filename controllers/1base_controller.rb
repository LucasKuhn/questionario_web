class BaseController
  class << self

    def layout(content, flash_messages = nil)
      <<~HTML
      <!DOCTYPE html>
      <html lang="en">

      <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="Plataforma web de aplicação de testes">
      <meta name="author" content="Lucas Kuhn">

      <title>Plataforma Web</title>

      <link href="/css/bootstrap.min.css" rel="stylesheet">
      <link href="/css/sidebar.css" rel="stylesheet">

      <!-- Bootstrap -->
      <script src="/js/jquery.min.js" charset="utf-8"></script>
      <script src="/js/bootstrap.bundle.min.js" charset="utf-8"></script>

      </head>

      <body>

      <div class="d-flex" id="wrapper">

      <!-- Sidebar -->
      <div class="bg-light border-right" id="sidebar-wrapper">
      <a href="/" class="text-info"><div class="sidebar-heading"><strong>Questionário Web</strong></div></a>
      #{sidebar_links(Current.user)}
      </div>

      <!-- Page Content -->
      <div id="page-content-wrapper">
      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
      <button class="" id="menu-toggle"><span><</span></button>
      <button></button>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse text-right" id="navbarSupportedContent">
      <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
      <li class="nav-item dropdown">
      <a class="nav-link">
      <span class="badge badge-pill badge-info "> #{Current.user.classificacao}</span>
      </a>
      </li>
      <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
      Bem vindo #{Current.user.nome}
      </a>
      <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
      <a class="dropdown-item" href="/sign_out">Sair</a>
      </div>
      </li>
      </ul>
      </div>
      </nav>
      <div class="container-fluid">
      <h2>#{FlashMessages.read()}</h2>
      <div class="container mt-4">
      #{content}
      </div>
      </div>
      </div>
      </div>

      <script>
      // Custom validation
      document.querySelectorAll('[required]').forEach((function(x){ x.setAttribute("oninvalid","this.setCustomValidity('Este campo é obrigatório')");}))
      document.querySelectorAll('[required]').forEach((function(x){ x.setAttribute("oninput","setCustomValidity('')");}))

      // Menu Toggle
      $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        });
      </script>

      </body>

      </html>

      HTML
    end

    def sidebar_links(user)
      if user.classificacao == 'Candidato'
        <<~HTML
        <div class="list-group list-group-flush">
          <a href="/aplicacoes/new" class="list-group-item list-group-item-action bg-light">Fazer um teste</a>
          <a href="/aplicacoes" class="list-group-item list-group-item-action bg-light">Meus resultados</a>
        </div>
        HTML
      else
        <<~HTML
        <div class="list-group list-group-flush">
        <a href="/elaboradores" class="list-group-item list-group-item-action bg-light">Elaboradores</a>
        <a href="/candidatos" class="list-group-item list-group-item-action bg-light">Candidatos</a>
        <a href="/testes" class="list-group-item list-group-item-action bg-light">Testes</a>
        <a href="/aplicacoes" class="list-group-item list-group-item-action bg-light">Aplicações</a>
        </div>
        HTML
      end
    end

    def render(template,flash_messages = nil)
      path = File.expand_path("../../views/#{template}/", __FILE__)
      # ERB.new(File.read(path )).result(binding)
      content = ERB.new(File.read(path)).result
      response = layout(content,flash_messages)
      Rack::Response.new(response)
    end
  end
end
