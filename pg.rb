dropdb questionarios
createdb questionarios

bundle exec rack-console

Elaborador.create(nome:'Lucas',usuario:'lucas',senha:'123123')

Teste.create(
nome: 'Teste 1',
duracao: 5,
percentual_aprovacao: 50,
descricao: 'Primeiro teste'
)

change do
    add_column :candidatos, :inscricao, :text
end

Rack::Response.new do |response|
  response.redirect("/testes/#{$1}/questoes/new")
end

return [ 302, {'Location'=>"/testes/#{$1}/questoes/new"}, [] ]
