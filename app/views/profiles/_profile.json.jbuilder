json.extract! profile, :id, :weapon_id, :attacks, :skill, :strength, :armor_piercing, :damage, :created_at, :updated_at
json.url profile_url(profile, format: :json)
