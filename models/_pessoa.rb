class Pessoa < Sequel::Model
  plugin :single_table_inheritance, :kind
  def classificacao
    kind
  end
end
