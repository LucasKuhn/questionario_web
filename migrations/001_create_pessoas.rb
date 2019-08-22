Sequel.migration do
  change do
    create_table(:pessoas) do
      primary_key :id
      column :nome, :text
      column :endereco, :text
      column :cidade, :text
      column :usuario, :text
      column :senha, :text
      column :nascimento, :date
      column :titulacao, :text
      column :area, :text
      column :inscricao, :text
      column :kind, :text
    end
  end
end
