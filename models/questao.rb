class Questao < Sequel::Model(:questoes)
  many_to_one :teste, :class=>:Teste
  one_to_many :alternativas
  plugin :nested_attributes
  nested_attributes :alternativas
  plugin :association_dependencies, alternativas: :delete
  def prepare_image!
    return unless ilustracao
    unless File.exist?("./public/temp/#{nome_ilustracao}")
      File.open("./public/temp/#{nome_ilustracao}", 'wb') { |new_file| new_file.write(ilustracao.to_s) }
    end
  end
end
