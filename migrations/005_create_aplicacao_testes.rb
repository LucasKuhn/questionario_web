Sequel.migration do
  change do
    create_table(:aplicacao_testes) do
      primary_key :id
      foreign_key(:candidato_id, :pessoas)
      foreign_key(:teste_id, :testes)
      column :data, :date
      column :hora_inicio, :timestamp
      column :hora_fim, :timestamp
      column :percentual_acerto, :float
    end
  end
end
