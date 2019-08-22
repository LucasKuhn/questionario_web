Sequel.migration do
  change do
    create_table(:testes) do
      primary_key :id
      column :nome, :text
      column :descricao, :text
      column :duracao, :int
      column :percentual_aprovacao, :float
      column :elaborador_id, :int

    end
  end
end
