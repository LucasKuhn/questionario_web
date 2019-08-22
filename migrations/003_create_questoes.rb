Sequel.migration do
  change do
    create_table(:questoes) do
      primary_key :id
      column :texto, :text
      column :nome_ilustracao, :text
      column :ilustracao, :bytea
      column :teste_id, :integer
    end
  end
end
