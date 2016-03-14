module Score::Criteria::Shared::ContactOf
  def split_by_names(results)
    results.each_with_object(Set.new) do |row, memo|
      mkeys_by_name = row['mkeys'][1...-1].split(',')
      memo.merge(yield(mkeys_by_name))
    end
  end

  def query_by_contact(contact)
    <<-SQL
      WITH contact_values AS (
        SELECT
          DISTINCT value
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
        WHERE contacts.id = #{contact.id}
      ) SELECT
          name,
          array_agg(owner_mkey) mkeys
        FROM contacts
          JOIN vectors ON contacts.id = vectors.contact_id
          JOIN contact_values ON contact_values.value = vectors.value
        WHERE contact_id != #{contact.id}
        GROUP BY name
    SQL
  end

  def update_contact_additions(contact, key, data)
    additions = contact.additions ||= {}
    contact.update_attributes(additions: additions.merge(key => data))
  end
end
