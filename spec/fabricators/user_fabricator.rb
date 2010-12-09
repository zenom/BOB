Fabricator(:user) do
  first_name            { Faker::Name.first_name }
  last_name             { Faker::Name.last_name }
  email                 { Faker::Internet.email }
  role                  { ['admin', 'client'].sample }
  password              { '123456' }
  password_confirmation { '123456' }
end
