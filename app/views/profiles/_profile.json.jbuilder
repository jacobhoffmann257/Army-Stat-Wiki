json.extract! profile, :id, :name, :weapon_id, :attacks, :skill, :strength, :aarmor_piercing, :damage, :created_at, :updated_at
json.url profile_url(profile, format: :json)
