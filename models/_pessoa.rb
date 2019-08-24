class Pessoa < Sequel::Model
  plugin :single_table_inheritance, :kind
  def classificacao
    kind
  end

  def idade
    Date.today.year - nascimento.year
  end
end
