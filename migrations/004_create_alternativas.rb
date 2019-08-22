Sequel.migration do
  change do
    create_table(:alternativas) do
      primary_key :id
      column :texto, :text
      column :correta, :boolean
      foreign_key(:questao_id, :questoes)
    end
  end
end
