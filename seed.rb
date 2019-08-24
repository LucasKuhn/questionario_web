require 'faker'
require 'sequel'

# Load DB
db_config_file = File.join(File.dirname(__FILE__), 'config', 'database.yml')
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
  Sequel.extension :migration
end

# Run migrations
if DB
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'migrations'))
end

# Load controllers
Dir[File.join(File.dirname(__FILE__), 'controllers', '**', '*.rb')].sort.each {|file| require file }
# Load models
Dir[File.join(File.dirname(__FILE__), 'models', '**', '*.rb')].sort.each {|file| require file }
# Load helpers
Dir[File.join(File.dirname(__FILE__), 'helpers', '**', '*.rb')].sort.each {|file| require file }


Elaborador.create(
  nome: "Lucas Kuhn",
  endereco: "Rua Aldeia",
  cidade: "Nova Petropolis",
  usuario: "lucas",
  senha: "123",
  nascimento: "1994-10-21",
  titulacao: "Graduando",
  area: "Ciências da Computação",
)

Elaborador.create(
  nome: "Lucas Kuhn",
  endereco: "Rua Aldeia",
  cidade: "Nova Petropolis",
  usuario: "lucas",
  senha: "123",
  nascimento: "1994-10-21",
  titulacao: "Graduando",
  area: "Ciências da Computação",
)

30.times do
  character = Faker::Movies::StarWars.character
  Candidato.create(
    nome: character,
    inscricao: Faker::Movies::StarWars.unique.call_sign,
    endereco: Faker::Movies::StarWars.call_squadron,
    cidade: Faker::Movies::StarWars.planet,
    usuario: character.downcase.delete(' '),
    senha: "123",
    nascimento: Faker::Date.birthday(min_age: 18, max_age: 65),
  )
end

teste = Teste.create(
  nome: "Formas geométricas",
  descricao: "Um teste simples de identificar formas",
  duracao: 5,
  percentual_aprovacao: 50,
)

def criar_questao(teste, resposta)
  path = File.expand_path("../public/temp/#{resposta}.png", __FILE__)
  File.read(path)
  Questao.create(
    texto: "Qual o nome desta forma?",
    nome_ilustracao: "#{resposta}.png",
    ilustracao: File.read(path),
    teste_id: teste.id,
    alternativas_attributes: [
      {texto:resposta, correta:true},
      {texto:'beep', correta:false},
      {texto:'boop', correta:false},
      {texto:'bling', correta:false},
    ]
  )
end

criar_questao(teste, "circulo")
criar_questao(teste, "octagono")
criar_questao(teste, "pentagono")
criar_questao(teste, "quadrado")

############
# Star Wars
############

teste = Teste.create(
  nome: "Você é um verdadeiro Jedi?",
  descricao: "Um teste sobre Star Wars",
  duracao: 10,
  percentual_aprovacao: 75,
)

def criar_questao_sw(teste, pergunta, resposta)
  path = File.expand_path("../public/temp/#{resposta}.png", __FILE__)
  File.read(path)
  Questao.create(
    texto: pergunta,
    nome_ilustracao: "#{resposta}.png",
    ilustracao: File.read(path),
    teste_id: teste.id,
    alternativas_attributes: [
      {texto: resposta, correta:true},
      {texto:Faker::Movies::StarWars.wookiee_sentence, correta:false},
      {texto:Faker::Movies::StarWars.wookiee_sentence, correta:false},
      {texto:Faker::Movies::StarWars.wookiee_sentence, correta:false},
    ]
  )
end

criar_questao_sw(teste,"Qual o nome da nave de Han Solo?","Millennium Falcon")
criar_questao_sw(teste,"Qual a arma de um Jedi?","Light Saber")
criar_questao_sw(teste,"Qual Jedi se tornou o Darth Vader?","Anakin Skywalker")
criar_questao_sw(teste,"Qual o nome desta Raça?","Ewok")
criar_questao_sw(teste,"Quem consegue capturar o Han Solo?","Boba Fett")
criar_questao_sw(teste,"Quem é a mãe de Luke Skywalker?","Padmé Amidala")
