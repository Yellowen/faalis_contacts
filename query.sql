a = Advertise.find_by_sql("SELECT advertises.*, field.name as field_name, det.detail_type FROM advertises INNER JOIN contacts as con ON con.id = advertises.contact_id INNER JOIN contact_details as det ON det.contact_id = con.id INNER JOIN contact_fields as field ON field.id = det.detail_field_id INNER JOIN contact_types as types  ON  types.id = det.detail_type INNER JOIN contact_types ON types.name = 'Phone' WHERE field.name = 'Phone'")