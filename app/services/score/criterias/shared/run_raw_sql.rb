module Score::Criterias::Shared::RunRawSql
  def run_raw_sql(sql)
    Contact.connection.select_all sql
  end
end
