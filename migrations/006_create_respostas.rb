Sequel.migration do
  change do
    create_table(:respostas) do
      primary_key :id
      foreign_key(:aplicacao_teste_id, :aplicacao_testes)
      foreign_key(:alternativa_id, :alternativas)
      column :observacao, :text
    end
  end
end
